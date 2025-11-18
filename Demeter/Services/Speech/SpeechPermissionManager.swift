import Foundation
import Speech
import AVFoundation
import UIKit

/// Manages microphone and speech recognition permissions for voice input
@MainActor
class SpeechPermissionManager: ObservableObject {
    @Published var microphoneStatus: PermissionStatus = .notDetermined
    @Published var speechRecognitionStatus: PermissionStatus = .notDetermined

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

    init() {
        Task {
            await updatePermissionStatuses()
        }
    }

    /// Check current microphone permission status
    func checkMicrophonePermission() -> PermissionStatus {
        // Using AVAudioSession.recordPermission despite deprecation warning
        // as AVAudioApplication.recordPermission doesn't provide current status
        // This is a known issue with the iOS 17+ API transition
        let status = AVAudioSession.sharedInstance().recordPermission

        switch status {
        case .undetermined:
            return .notDetermined
        case .granted:
            return .authorized
        case .denied:
            return .denied
        @unknown default:
            return .denied
        }
    }

    /// Check current speech recognition authorization status
    func checkSpeechRecognitionAuthorization() -> PermissionStatus {
        let status = SFSpeechRecognizer.authorizationStatus()

        switch status {
        case .notDetermined:
            return .notDetermined
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        @unknown default:
            return .denied
        }
    }

    /// Request microphone permission with explanation
    func requestMicrophonePermission() async -> PermissionStatus {
        let granted = await AVAudioApplication.requestRecordPermission()
        let status: PermissionStatus = granted ? .authorized : .denied

        microphoneStatus = status
        return status
    }

    /// Request speech recognition authorization
    func requestSpeechRecognitionAuthorization() async -> PermissionStatus {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                let permissionStatus: PermissionStatus
                switch status {
                case .authorized:
                    permissionStatus = .authorized
                case .denied:
                    permissionStatus = .denied
                case .restricted:
                    permissionStatus = .restricted
                case .notDetermined:
                    permissionStatus = .notDetermined
                @unknown default:
                    permissionStatus = .denied
                }

                self.speechRecognitionStatus = permissionStatus
                continuation.resume(returning: permissionStatus)
            }
        }
    }

    /// Check if all required permissions are authorized
    func areAllPermissionsAuthorized() -> Bool {
        return microphoneStatus.isAuthorized && speechRecognitionStatus.isAuthorized
    }

    /// Check if any permission requires user action
    func requiresUserAction() -> Bool {
        return microphoneStatus.requiresAction || speechRecognitionStatus.requiresAction
    }

    /// Get URL for Settings app
    func getSettingsURL() -> URL? {
        return URL(string: UIApplication.openSettingsURLString)
    }

    /// Update all permission statuses
    private func updatePermissionStatuses() async {
        microphoneStatus = checkMicrophonePermission()
        speechRecognitionStatus = checkSpeechRecognitionAuthorization()
    }

    /// Refresh permission statuses (call after returning from Settings)
    func refreshPermissionStatuses() {
        Task {
            await updatePermissionStatuses()
        }
    }
}