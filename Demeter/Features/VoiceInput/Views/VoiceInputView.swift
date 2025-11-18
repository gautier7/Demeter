import SwiftUI

/// Main view for voice input interface
struct VoiceInputView: View {
    @StateObject var viewModel: VoiceInputViewModel
    var onTranscriptionComplete: (NutritionData) -> Void
    var onError: (VoiceInputError) -> Void

    @State private var showPermissionDialog = false
    @State private var showErrorAlert = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Main recording interface
            VStack(spacing: 32) {
                // Recording button
                VoiceRecordingButton(
                    state: viewModel.recordingState,
                    isEnabled: viewModel.permissionStatus.isAuthorized,
                    action: handleRecordingButtonTap,
                    hapticFeedback: true
                )
                .accessibilityLabel("Voice recording button")
                .accessibilityHint(viewModel.recordingState.isRecording ?
                    "Double tap to stop recording" : "Double tap to start recording")

                // Transcription display
                TranscriptionDisplayView(
                    text: viewModel.transcribedText,
                    isAnimating: viewModel.recordingState.isRecording,
                    highlightedRange: nil // Will be implemented with real-time highlighting
                )
            }

            // Error message display
            if let errorMessage = viewModel.errorMessage {
                errorMessageView(message: errorMessage)
            }

            // Manual entry fallback
            manualEntryButton

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .alert("Microphone Permission Required", isPresented: $showPermissionDialog) {
            Button("Cancel", role: .cancel) {}
            Button("Settings") {
                openSettings()
            }
            Button("Allow") {
                Task {
                    await requestPermission()
                }
            }
        } message: {
            Text("To log your meals by voice, the app needs access to your microphone. This allows the app to record and transcribe your speech.")
        }
        .alert("Recording Error", isPresented: $showErrorAlert) {
            Button("Try Again") {
                handleRecordingButtonTap()
            }
            Button("Type Instead", role: .cancel) {
                // Will trigger manual entry
            }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred")
        }
        .onChange(of: viewModel.recordingState) { newState in
            handleStateChange(newState)
        }
        .onAppear {
            checkInitialPermissions()
        }
    }

    private func errorMessageView(message: String) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .accessibilityHidden(true)

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel("Error message")
                    .accessibilityValue(message)
            }

            // Action buttons for error recovery
            if let error = viewModel.recordingState.error,
               error.shouldOfferManualEntry {
                HStack(spacing: 12) {
                    Button("Try Again") {
                        handleRecordingButtonTap()
                    }
                    .buttonStyle(.bordered)

                    Button("Type Instead") {
                        // Will trigger manual entry navigation
                    }
                    .buttonStyle(.borderedProminent)
                }
                .font(.subheadline)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Error notification")
    }

    private var manualEntryButton: some View {
        Button(action: {
            // Will trigger manual entry navigation
        }) {
            HStack(spacing: 8) {
                Image(systemName: "keyboard")
                    .font(.body)
                Text("Type instead")
                    .font(.body)
            }
            .foregroundColor(.blue)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue.opacity(0.1))
            )
        }
        .accessibilityLabel("Switch to manual text entry")
        .accessibilityHint("Double tap to enter food description manually")
    }

    private func handleRecordingButtonTap() {
        Task {
            if viewModel.recordingState.isRecording {
                await viewModel.stopRecording()
            } else {
                await viewModel.startRecording()
            }
        }
    }

    private func handleStateChange(_ newState: RecordingState) {
        switch newState {
        case .success:
            if let nutritionData = viewModel.getNutritionData() {
                onTranscriptionComplete(nutritionData)
            }
        case .error(let error):
            onError(error)
            showErrorAlert = true
        default:
            break
        }
    }

    private func checkInitialPermissions() {
        let status = viewModel.checkPermissionStatus()
        if status.requiresAction {
            showPermissionDialog = true
        }
    }

    private func requestPermission() async {
        let granted = await viewModel.requestMicrophonePermission()
        if !granted {
            showPermissionDialog = true // Show dialog again if denied
        }
    }

    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    VoiceInputView(
        viewModel: VoiceInputViewModel(),
        onTranscriptionComplete: { nutritionData in
            print("Nutrition analysis complete: \(nutritionData.totalNutrition.calories) calories")
        },
        onError: { error in
            print("Error: \(error)")
        }
    )
}