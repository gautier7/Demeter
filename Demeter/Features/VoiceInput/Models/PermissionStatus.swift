import Foundation

/// Represents the current status of microphone and speech recognition permissions
enum PermissionStatus: Equatable, Hashable, Codable {
    case notDetermined
    case authorized
    case denied
    case restricted

    var isAuthorized: Bool {
        self == .authorized
    }

    var isDenied: Bool {
        self == .denied
    }

    var isRestricted: Bool {
        self == .restricted
    }

    var requiresAction: Bool {
        self == .denied || self == .restricted
    }
}