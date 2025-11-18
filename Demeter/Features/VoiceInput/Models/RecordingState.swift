import Foundation

/// Represents the current state of voice recording
enum RecordingState: Equatable, Hashable, Codable {
    case idle
    case recording
    case processing
    case success
    case error(VoiceInputError)

    var isRecording: Bool {
        if case .recording = self { return true }
        return false
    }

    var isProcessing: Bool {
        if case .processing = self { return true }
        return false
    }

    var hasError: Bool {
        if case .error = self { return true }
        return false
    }

    var error: VoiceInputError? {
        if case .error(let error) = self { return error }
        return nil
    }
}