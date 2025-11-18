import Foundation
import Combine
import SwiftUI

/// ViewModel managing voice input business logic and state
@MainActor
class VoiceInputViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var recordingState: RecordingState = .idle
    @Published var transcribedText: String = ""
    @Published var permissionStatus: PermissionStatus = .notDetermined
    @Published var errorMessage: String?

    // MARK: - Private Properties
    private var speechRecognitionService: SpeechRecognitionService?
    private var permissionManager: SpeechPermissionManager?
    private var hapticManager: HapticManager?
    private let llmService: LLMService

    private var cancellables = Set<AnyCancellable>()
    private var currentNutritionData: NutritionData?

    // MARK: - Initialization
    init(
        speechRecognitionService: SpeechRecognitionService? = nil,
        permissionManager: SpeechPermissionManager? = nil,
        hapticManager: HapticManager? = nil,
        llmService: LLMService = .shared
    ) {
        // Use provided instances or create new ones (will be set up asynchronously)
        self.llmService = llmService

        // Setup will be completed asynchronously
        Task { @MainActor in
            self.speechRecognitionService = speechRecognitionService ?? SpeechRecognitionService()
            self.permissionManager = permissionManager ?? SpeechPermissionManager()
            self.hapticManager = hapticManager ?? HapticManager()

            setupBindings()
            updatePermissionStatus()
        }
    }

    // MARK: - Public Methods
    func startRecording() async {
        guard let permissionManager = permissionManager,
              let speechRecognitionService = speechRecognitionService,
              let hapticManager = hapticManager else {
            // Services not yet initialized
            let error = VoiceInputError.unknown("Services not initialized")
            recordingState = .error(error)
            errorMessage = error.errorDescription
            return
        }

        // Check permissions first
        let micStatus = permissionManager.checkMicrophonePermission()
        let speechStatus = permissionManager.checkSpeechRecognitionAuthorization()

        guard micStatus.isAuthorized && speechStatus.isAuthorized else {
            let error: VoiceInputError
            if micStatus.isDenied || speechStatus.isDenied {
                error = .permissionDenied
            } else if micStatus.isRestricted || speechStatus.isRestricted {
                error = .permissionRestricted
            } else {
                error = .permissionDenied
            }
            recordingState = .error(error)
            errorMessage = error.errorDescription
            hapticManager.triggerError()
            return
        }

        // Check if speech recognition is available
        guard speechRecognitionService.isSpeechRecognitionAvailable() else {
            let error = VoiceInputError.speechRecognitionUnavailable
            recordingState = .error(error)
            errorMessage = error.errorDescription
            hapticManager.triggerError()
            return
        }

        // Start recording
        do {
            recordingState = .recording
            errorMessage = nil
            hapticManager.triggerRecordingStart()

            try speechRecognitionService.startRecording()
        } catch {
            let voiceError = mapSpeechError(error)
            recordingState = .error(voiceError)
            errorMessage = voiceError.errorDescription
            hapticManager.triggerError()
        }
    }

    func stopRecording() async {
        guard recordingState.isRecording,
              let speechRecognitionService = speechRecognitionService,
              let hapticManager = hapticManager else { return }

        recordingState = .processing
        hapticManager.triggerRecordingStop()

        speechRecognitionService.stopRecording()

        // Check if we have valid transcription
        if transcribedText.isEmpty {
            let error = VoiceInputError.transcriptionFailed("No speech detected")
            recordingState = .error(error)
            errorMessage = error.errorDescription
            hapticManager.triggerError()
            return
        }

        // Process transcription with LLM
        await processTranscriptionWithLLM()
    }

    /// Process transcribed text with LLM service
    private func processTranscriptionWithLLM() async {
        do {
            // For now, use empty ingredient context (will be enhanced in future phases)
            let ingredientContext = [String]()
            let nutritionData = try await llmService.analyzeFood(
                description: transcribedText,
                ingredientContext: ingredientContext
            )

            currentNutritionData = nutritionData
            recordingState = .success
            errorMessage = nil

        } catch let error as LLMService.LLMError {
            let voiceError = mapLLMError(error)
            recordingState = .error(voiceError)
            errorMessage = voiceError.errorDescription
            hapticManager?.triggerError()

        } catch {
            let voiceError = VoiceInputError.unknown(error.localizedDescription)
            recordingState = .error(voiceError)
            errorMessage = voiceError.errorDescription
            hapticManager?.triggerError()
        }
    }

    func requestMicrophonePermission() async -> Bool {
        guard let permissionManager = permissionManager else {
            return false
        }

        // Request microphone permission
        let micStatus = await permissionManager.requestMicrophonePermission()

        if micStatus == .authorized {
            // Also request speech recognition authorization
            let speechStatus = await permissionManager.requestSpeechRecognitionAuthorization()
            return speechStatus == .authorized
        }

        return false
    }

    func checkPermissionStatus() -> PermissionStatus {
        guard let permissionManager = permissionManager else {
            return .notDetermined
        }

        let micStatus = permissionManager.checkMicrophonePermission()
        let speechStatus = permissionManager.checkSpeechRecognitionAuthorization()

        if micStatus.isAuthorized && speechStatus.isAuthorized {
            return .authorized
        } else if micStatus.isDenied || speechStatus.isDenied {
            return .denied
        } else if micStatus.isRestricted || speechStatus.isRestricted {
            return .restricted
        } else {
            return .notDetermined
        }
    }

    /// Get the processed nutrition data (available after successful LLM processing)
    func getNutritionData() -> NutritionData? {
        return currentNutritionData
    }

    // MARK: - Private Methods
    private func setupBindings() {
        guard let speechRecognitionService = speechRecognitionService,
              let permissionManager = permissionManager else {
            // Services not yet initialized, bindings will be set up later
            return
        }

        // Bind to speech recognition service updates
        speechRecognitionService.$isRecording
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRecording in
                guard let self = self else { return }
                if !isRecording && self.recordingState.isRecording {
                    // Recording stopped externally (e.g., silence detection)
                    Task {
                        await self.stopRecording()
                    }
                }
            }
            .store(in: &cancellables)

        speechRecognitionService.$transcribedText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.transcribedText = text
            }
            .store(in: &cancellables)

        speechRecognitionService.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.handleSpeechError(error)
                }
            }
            .store(in: &cancellables)

        // Bind to permission manager updates
        permissionManager.$microphoneStatus
            .combineLatest(permissionManager.$speechRecognitionStatus)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] micStatus, speechStatus in
                // Determine overall permission status
                if micStatus == .authorized && speechStatus == .authorized {
                    self?.permissionStatus = .authorized
                } else if micStatus == .denied || speechStatus == .denied {
                    self?.permissionStatus = .denied
                } else if micStatus == .restricted || speechStatus == .restricted {
                    self?.permissionStatus = .restricted
                } else {
                    self?.permissionStatus = .notDetermined
                }
            }
            .store(in: &cancellables)
    }

    private func updatePermissionStatus() {
        permissionManager?.refreshPermissionStatuses()
    }

    private func handleSpeechError(_ error: Error) {
        let voiceError = mapSpeechError(error)
        recordingState = .error(voiceError)
        errorMessage = voiceError.errorDescription
        if let hapticManager = hapticManager {
            hapticManager.triggerError()
        }
    }

    private func mapSpeechError(_ error: Error) -> VoiceInputError {
        // Map SpeechRecognitionService errors to VoiceInputError
        if let speechError = error as? SpeechRecognitionService.SpeechError {
            switch speechError {
            case .audioEngineError:
                return .recordingFailed("Audio engine error")
            case .recognitionNotAvailable:
                return .speechRecognitionUnavailable
            case .permissionDenied:
                return .permissionDenied
            case .audioSessionError:
                return .recordingFailed("Audio session error")
            case .recordingFailed:
                return .recordingFailed("Recording failed")
            }
        }

        // Handle other errors
        return .unknown(error.localizedDescription)
    }

    private func mapLLMError(_ error: LLMService.LLMError) -> VoiceInputError {
        // Map LLMService errors to VoiceInputError
        switch error {
        case .noAPIKey:
            return .networkError("OpenAI API key not configured")
        case .invalidResponse:
            return .networkError("Invalid response from nutrition service")
        case .parsingError:
            return .networkError("Failed to parse nutritional data")
        case .apiError(let message):
            return .networkError("Nutrition service error: \(message)")
        }
    }
}