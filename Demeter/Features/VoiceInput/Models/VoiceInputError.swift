import Foundation

/// Represents errors that can occur during voice input operations
enum VoiceInputError: LocalizedError, Equatable, Hashable, Codable {
    case microphoneNotAvailable
    case permissionDenied
    case permissionRestricted
    case speechRecognitionUnavailable
    case recordingFailed(String)
    case transcriptionFailed(String)
    case networkError(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .microphoneNotAvailable:
            return "Microphone is not available on this device"
        case .permissionDenied:
            return "Microphone access denied. Please enable in Settings."
        case .permissionRestricted:
            return "Microphone access is restricted. Please check parental controls."
        case .speechRecognitionUnavailable:
            return "Speech recognition is not available. Please try again later."
        case .recordingFailed(let details):
            return "Recording failed: \(details)"
        case .transcriptionFailed(let details):
            return "Transcription failed: \(details)"
        case .networkError(let details):
            return "Network error: \(details)"
        case .unknown(let details):
            return "An unknown error occurred: \(details)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .permissionDenied:
            return "Go to Settings > Privacy & Security > Microphone and enable access for this app."
        case .permissionRestricted:
            return "Check your device's parental controls or restrictions."
        case .speechRecognitionUnavailable:
            return "Ensure you have an internet connection and try again."
        case .networkError:
            return "Check your internet connection and try again."
        case .microphoneNotAvailable:
            return "Ensure your microphone is not blocked and try again."
        default:
            return "Try again or use manual entry instead."
        }
    }

    var shouldOfferManualEntry: Bool {
        switch self {
        case .permissionDenied, .permissionRestricted, .speechRecognitionUnavailable,
             .recordingFailed, .transcriptionFailed, .networkError, .unknown:
            return true
        case .microphoneNotAvailable:
            return false // Device issue, manual entry won't help
        }
    }
}