import Foundation
import Speech
import AVFoundation
import UIKit

/// SpeechRecognitionService handles voice input capture and transcription
/// using AVAudioEngine and SFSpeechRecognizer
@MainActor
class SpeechRecognitionService: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var transcribedText = ""
    @Published var error: Error?
    
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    private var silenceTimer: Timer?
    private let silenceThreshold: TimeInterval = 2.0
    
    enum SpeechError: LocalizedError {
        case audioEngineError
        case recognitionNotAvailable
        case permissionDenied
        case audioSessionError
        case recordingFailed
        
        var errorDescription: String? {
            switch self {
            case .audioEngineError:
                return "Audio engine error"
            case .recognitionNotAvailable:
                return "Speech recognition not available"
            case .permissionDenied:
                return "Microphone permission denied"
            case .audioSessionError:
                return "Audio session error"
            case .recordingFailed:
                return "Recording failed"
            }
        }
    }
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    /// Request microphone permission
    func requestMicrophonePermission() async -> Bool {
        let status = await AVAudioApplication.requestRecordPermission()
        return status
    }
    
    /// Check if speech recognition is available
    func isSpeechRecognitionAvailable() -> Bool {
        guard let recognizer = speechRecognizer else { return false }
        return recognizer.isAvailable
    }
    
    /// Start recording voice input
    func startRecording() throws {
        // Check if already recording
        if isRecording {
            return
        }
        
        // Check speech recognition availability
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            throw SpeechError.recognitionNotAvailable
        }
        
        // Reset state
        transcribedText = ""
        error = nil
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw SpeechError.recordingFailed
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = false
        
        // Get audio input node
        let inputNode = audioEngine.inputNode
        
        // Create audio format
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        // Install tap on audio engine
        inputNode.installTap(
            onBus: 0,
            bufferSize: 1024,
            format: recordingFormat
        ) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        // Start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            throw SpeechError.audioEngineError
        }
        
        // Start recognition task
        recognitionTask = recognizer.recognitionTask(
            with: recognitionRequest
        ) { [weak self] result, error in
            Task { @MainActor in
                if let result = result {
                    self?.transcribedText = result.bestTranscription.formattedString
                    
                    // Reset silence timer
                    self?.resetSilenceTimer()
                    
                    if result.isFinal {
                        self?.stopRecording()
                    }
                }
                
                if let error = error {
                    self?.error = error
                    self?.stopRecording()
                }
            }
        }
        
        isRecording = true
        
        // Provide haptic feedback
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
    }
    
    /// Stop recording voice input
    func stopRecording() {
        guard isRecording else { return }
        
        // Stop audio engine
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        // End recognition request
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        // Clean up
        recognitionRequest = nil
        recognitionTask = nil
        silenceTimer?.invalidate()
        silenceTimer = nil
        
        isRecording = false
        
        // Provide haptic feedback
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
    }
    
    /// Reset silence timer for endpoint detection
    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        
        silenceTimer = Timer.scheduledTimer(withTimeInterval: silenceThreshold, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.stopRecording()
            }
        }
    }
    
    /// Setup audio session
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(
                .record,
                mode: .measurement,
                options: []
            )
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            self.error = SpeechError.audioSessionError
        }
    }
}