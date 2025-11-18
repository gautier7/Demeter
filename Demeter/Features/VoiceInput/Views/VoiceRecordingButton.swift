import SwiftUI

/// Custom button component for voice recording with state-based visual feedback
struct VoiceRecordingButton: View {
    let state: RecordingState
    let isEnabled: Bool
    let action: () -> Void
    let hapticFeedback: Bool

    @State private var isAnimating = false

    private var buttonColor: Color {
        switch state {
        case .idle:
            return .blue
        case .recording:
            return .red
        case .processing:
            return .gray
        case .success:
            return .green
        case .error:
            return .red
        }
    }

    private var iconName: String {
        switch state {
        case .idle:
            return "mic.fill"
        case .recording:
            return "stop.fill"
        case .processing:
            return "hourglass"
        case .success:
            return "checkmark"
        case .error:
            return "exclamationmark.triangle.fill"
        }
    }

    private var accessibilityLabel: String {
        switch state {
        case .idle:
            return "Start recording"
        case .recording:
            return "Stop recording"
        case .processing:
            return "Processing speech"
        case .success:
            return "Recording completed"
        case .error:
            return "Recording error"
        }
    }

    private var accessibilityHint: String {
        switch state {
        case .idle:
            return "Double tap to start voice recording"
        case .recording:
            return "Double tap to stop recording"
        case .processing:
            return "Please wait while processing your speech"
        case .success:
            return "Recording completed successfully"
        case .error:
            return "An error occurred during recording"
        }
    }

    var body: some View {
        Button(action: {
            if hapticFeedback {
                triggerHapticFeedback()
            }
            action()
        }) {
            ZStack {
                // Background circle with state-based color
                Circle()
                    .fill(buttonColor.opacity(0.2))
                    .frame(width: 80, height: 80)

                // Pulsing animation for recording state
                if state.isRecording {
                    Circle()
                        .stroke(buttonColor, lineWidth: 3)
                        .frame(width: 80, height: 80)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.0 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }

                // Icon
                Image(systemName: iconName)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(buttonColor)
                    .scaleEffect(state.isProcessing ? 1.1 : 1.0)
                    .rotationEffect(state.isProcessing ? .degrees(isAnimating ? 180 : 0) : .degrees(0))
                    .animation(
                        state.isProcessing ?
                            Animation.linear(duration: 1.0).repeatForever(autoreverses: false) :
                            .default,
                        value: isAnimating
                    )
            }
            .frame(width: 80, height: 80)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(.isButton)
        .onAppear {
            if state.isRecording || state.isProcessing {
                isAnimating = true
            }
        }
        .onChange(of: state) { newValue in
            isAnimating = newValue.isRecording || newValue.isProcessing
        }
    }

    private func triggerHapticFeedback() {
        let generator: UIImpactFeedbackGenerator
        switch state {
        case .idle, .recording:
            generator = UIImpactFeedbackGenerator(style: .medium)
        case .error:
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.notificationOccurred(.error)
            return
        default:
            generator = UIImpactFeedbackGenerator(style: .light)
        }
        generator.impactOccurred()
    }
}

#Preview {
    VStack(spacing: 20) {
        VoiceRecordingButton(state: .idle, isEnabled: true, action: {}, hapticFeedback: true)
        VoiceRecordingButton(state: .recording, isEnabled: true, action: {}, hapticFeedback: true)
        VoiceRecordingButton(state: .processing, isEnabled: true, action: {}, hapticFeedback: true)
        VoiceRecordingButton(state: .success, isEnabled: true, action: {}, hapticFeedback: true)
        VoiceRecordingButton(state: .error(VoiceInputError.unknown("Test error")), isEnabled: true, action: {}, hapticFeedback: true)
        VoiceRecordingButton(state: .idle, isEnabled: false, action: {}, hapticFeedback: true)
    }
    .padding()
}