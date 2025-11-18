import SwiftUI

/// View component for displaying real-time speech transcription
struct TranscriptionDisplayView: View {
    let text: String
    let isAnimating: Bool
    let highlightedRange: NSRange?

    @State private var recordingDuration: TimeInterval = 0
    @State private var timer: Timer?

    private let placeholderText = "Tap to start recording..."

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Transcription text
            ZStack(alignment: .topLeading) {
                // Placeholder text
                if text.isEmpty {
                    Text(placeholderText)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Transcription placeholder")
                        .accessibilityHint("Tap the record button to start voice input")
                }

                // Actual transcription text
                if !text.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        Text(attributedText)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 4)
                    }
                    .frame(maxHeight: 120)
                    .accessibilityLabel("Transcription text")
                    .accessibilityValue(text)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .topLeading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            )

            // Recording duration indicator
            if isAnimating {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .opacity(isAnimating ? 1.0 : 0.3)
                        .animation(
                            Animation.easeInOut(duration: 0.5)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )

                    Text(formatDuration(recordingDuration))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .monospacedDigit()
                }
                .accessibilityLabel("Recording duration")
                .accessibilityValue(formatDuration(recordingDuration))
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onChange(of: isAnimating) { newValue in
            if newValue {
                recordingDuration = 0
                startTimer()
            } else {
                stopTimer()
            }
        }
    }

    private var attributedText: AttributedString {
        var attributed = AttributedString(text)

        // Highlight newly added text if range is provided
        if let range = highlightedRange,
           let nsRange = Range(range, in: text) {
            if let attributedRange = Range(nsRange, in: attributed) {
                attributed[attributedRange].foregroundColor = .blue
                attributed[attributedRange].font = .body.bold()
            }
        }

        return attributed
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func startTimer() {
        stopTimer() // Ensure no duplicate timers
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                recordingDuration += 1
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    VStack(spacing: 20) {
        TranscriptionDisplayView(
            text: "",
            isAnimating: false,
            highlightedRange: nil
        )

        TranscriptionDisplayView(
            text: "I ate a grilled chicken breast with rice and vegetables",
            isAnimating: true,
            highlightedRange: NSRange(location: 35, length: 11) // "vegetables"
        )

        TranscriptionDisplayView(
            text: "This is a very long transcription text that should demonstrate the scrolling capability when the text exceeds the available space and needs to be scrollable within the view container.",
            isAnimating: false,
            highlightedRange: nil
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}