import Foundation
import UIKit

/// Manages haptic feedback for voice input interactions
@MainActor
class HapticManager {
    private var recordingStartGenerator: UIImpactFeedbackGenerator?
    private var recordingStopGenerator: UIImpactFeedbackGenerator?
    private var errorGenerator: UINotificationFeedbackGenerator?

    init() {
        prepareGenerators()
    }

    /// Prepare haptic feedback generators for better performance
    private func prepareGenerators() {
        recordingStartGenerator = UIImpactFeedbackGenerator(style: .medium)
        recordingStopGenerator = UIImpactFeedbackGenerator(style: .medium)
        errorGenerator = UINotificationFeedbackGenerator()

        recordingStartGenerator?.prepare()
        recordingStopGenerator?.prepare()
        errorGenerator?.prepare()
    }

    /// Trigger haptic feedback for recording start
    func triggerRecordingStart() {
        guard shouldTriggerHaptics() else { return }

        recordingStartGenerator?.impactOccurred()
        recordingStartGenerator?.prepare() // Prepare for next use
    }

    /// Trigger haptic feedback for recording stop
    func triggerRecordingStop() {
        guard shouldTriggerHaptics() else { return }

        recordingStopGenerator?.impactOccurred()
        recordingStopGenerator?.prepare() // Prepare for next use
    }

    /// Trigger haptic feedback for errors
    func triggerError() {
        guard shouldTriggerHaptics() else { return }

        errorGenerator?.notificationOccurred(.error)
        errorGenerator?.prepare() // Prepare for next use
    }

    /// Check if haptics should be triggered based on user preferences
    private func shouldTriggerHaptics() -> Bool {
        // Check if haptics are enabled in system settings
        let feedbackSupportLevel = UIDevice.current.value(forKey: "_feedbackSupportLevel") as? Int ?? 0
        return feedbackSupportLevel > 0
    }

    /// Clean up generators when no longer needed
    func cleanup() {
        recordingStartGenerator = nil
        recordingStopGenerator = nil
        errorGenerator = nil
    }
}