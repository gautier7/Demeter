# Feature Specification: Voice Input Interface

**Feature Branch**: `004-voice-input`  
**Created**: 2025-11-18  
**Status**: Draft  
**Input**: User description: "Create a feature specification for the Voice Input interface of the Demeter iOS calorie tracking app. Build the main voice input interface that allows users to record their food intake through voice. This is the primary interaction method for the app where users tap a button to start recording, speak their food description, and see real-time transcription feedback."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Quick Voice Recording (Priority: P1)

As a user, I want to tap a single button to start recording my food intake so that I can quickly log meals without navigating through multiple screens.

**Why this priority**: This is the core interaction pattern for the entire app. Single-tap voice activation is the primary value proposition that differentiates Demeter from manual calorie tracking apps.

**Independent Test**: Can be fully tested by opening the app, tapping the voice button once, and verifying that recording starts immediately with visual feedback within 500ms.

**Acceptance Scenarios**:

1. **Given** the app is open on the main screen, **When** user taps the voice recording button, **Then** recording starts immediately with visual feedback (button state change, animation)
2. **Given** recording has started, **When** user speaks "I ate a grilled chicken breast with rice", **Then** real-time transcription appears on screen showing the words as they are spoken
3. **Given** user is recording, **When** they tap the button again, **Then** recording stops and the complete transcription is displayed for review

---

### User Story 2 - Real-Time Transcription Feedback (Priority: P1)

As a user, I want to see my words transcribed in real-time as I speak so that I can verify the app is understanding me correctly and adjust my speech if needed.

**Why this priority**: Real-time feedback builds user confidence and allows immediate correction if transcription is inaccurate. Without this, users won't trust the voice input system.

**Independent Test**: Can be fully tested by recording a food description and verifying that transcribed text appears on screen within 500ms of speaking and updates continuously as more words are spoken.

**Acceptance Scenarios**:

1. **Given** recording is active, **When** user speaks "chicken breast", **Then** the text "chicken breast" appears on screen within 500ms
2. **Given** partial transcription is displayed, **When** user continues speaking "with vegetables", **Then** the display updates to show "chicken breast with vegetables"
3. **Given** transcription is in progress, **When** user pauses for 2 seconds, **Then** recording automatically stops and final transcription is confirmed

---

### User Story 3 - Permission Handling (Priority: P1)

As a user, I want to be clearly informed why the app needs microphone access and easily grant permission so that I can start using voice input without confusion.

**Why this priority**: Without microphone permission, the core feature is unusable. Clear permission handling is essential for first-time user experience and App Store compliance.

**Independent Test**: Can be fully tested by installing the app fresh, attempting voice input, and verifying that a clear permission dialog appears with explanation before the system permission prompt.

**Acceptance Scenarios**:

1. **Given** the app is launched for the first time, **When** user taps the voice button, **Then** a clear explanation dialog appears describing why microphone access is needed
2. **Given** the explanation dialog is shown, **When** user taps "Allow", **Then** the system permission prompt appears
3. **Given** user denies microphone permission, **When** they tap the voice button again, **Then** a helpful message appears with a button to open Settings

---

### User Story 4 - Visual Recording States (Priority: P2)

As a user, I want clear visual indicators of the recording state so that I always know whether the app is listening, processing, or ready for input.

**Why this priority**: Clear state feedback prevents user confusion and errors. Users need to know when they can speak and when the app is processing.

**Independent Test**: Can be fully tested by cycling through recording states (idle → recording → processing → complete) and verifying distinct visual feedback for each state.

**Acceptance Scenarios**:

1. **Given** the app is idle, **When** displayed, **Then** the voice button shows a microphone icon in the default state
2. **Given** recording starts, **When** the button state changes, **Then** it displays a pulsing animation and changes color to indicate active recording
3. **Given** recording stops, **When** transcription is being processed, **Then** a loading indicator appears with "Processing..." text
4. **Given** an error occurs, **When** displayed, **Then** the button shows an error state with red color and an error icon

---

### User Story 5 - Haptic Feedback (Priority: P2)

As a user, I want to feel haptic feedback when I start and stop recording so that I have tactile confirmation of my actions even without looking at the screen.

**Why this priority**: Haptic feedback enhances the user experience and provides confirmation during hands-free or eyes-free usage scenarios (e.g., while eating).

**Independent Test**: Can be fully tested by tapping the voice button with the device in hand and verifying distinct haptic feedback occurs at recording start and stop.

**Acceptance Scenarios**:

1. **Given** user taps the voice button to start recording, **When** recording begins, **Then** a medium-impact haptic feedback is triggered
2. **Given** recording is active, **When** user taps to stop or automatic endpoint detection triggers, **Then** a medium-impact haptic feedback is triggered
3. **Given** an error occurs, **When** the error state is entered, **Then** a notification-style haptic feedback is triggered

---

### User Story 6 - Graceful Error Handling (Priority: P1)

As a user, I want clear, actionable error messages when voice input fails so that I know what went wrong and how to fix it.

**Why this priority**: Voice input can fail for many reasons (no permission, no network, speech recognition unavailable). Users need guidance to resolve issues without frustration.

**Independent Test**: Can be fully tested by simulating various error conditions (denied permission, airplane mode, speech recognition unavailable) and verifying appropriate error messages appear.

**Acceptance Scenarios**:

1. **Given** microphone permission is denied, **When** user attempts voice input, **Then** a message appears: "Microphone access required. Please enable in Settings." with a Settings button
2. **Given** speech recognition is unavailable, **When** user attempts voice input, **Then** a message appears: "Speech recognition unavailable. Please try again later or use manual entry."
3. **Given** recording fails mid-session, **When** the error occurs, **Then** the partial transcription is preserved and user is offered options to retry or enter manually

---

### User Story 7 - Manual Entry Fallback (Priority: P2)

As a user, I want the option to manually type my food description if voice input isn't working or convenient so that I can always log my meals.

**Why this priority**: Voice input won't work in all situations (noisy environments, privacy concerns, technical issues). Manual entry ensures the app remains usable.

**Independent Test**: Can be fully tested by tapping a "Type instead" button and verifying a text input field appears where users can manually enter their food description.

**Acceptance Scenarios**:

1. **Given** the voice input screen is displayed, **When** user taps "Type instead" button, **Then** a text input field appears with keyboard
2. **Given** manual entry mode is active, **When** user types a food description and taps "Done", **Then** the text is processed the same way as voice transcription
3. **Given** voice input fails, **When** the error message appears, **Then** a "Type instead" option is prominently displayed

---

### Edge Cases

- What happens when the user speaks in a very noisy environment and transcription quality is poor?
- How does the system handle extremely long voice inputs (>60 seconds)?
- What happens when the user switches apps while recording is in progress?
- How does the system handle rapid button taps (double-tap, triple-tap)?
- What happens when speech recognition service is temporarily unavailable?
- How does the system handle voice input in languages other than English?
- What happens when the device is in low power mode and audio processing is restricted?
- How does the system handle simultaneous voice input attempts from multiple app instances (iPad multitasking)?

## Requirements *(mandatory)*

### Functional Requirements

#### Voice Input UI Components

- **FR-001**: System MUST display a prominent voice recording button on the main screen that is easily tappable (minimum 44x44 points)
- **FR-002**: System MUST show real-time transcription text in a clearly visible area below or near the recording button
- **FR-003**: System MUST provide visual feedback for recording states: idle, recording, processing, error, and success
- **FR-004**: System MUST display a "Type instead" button as an alternative to voice input
- **FR-005**: System MUST show recording duration timer when voice input is active
- **FR-006**: System MUST display a waveform or audio level indicator during recording to show audio is being captured

#### Recording Button States

- **FR-007**: Recording button MUST show distinct visual states for: idle (ready), recording (active), processing (analyzing), error (failed)
- **FR-008**: Recording button MUST use color coding: default (blue/primary), recording (red/accent), processing (gray), error (red)
- **FR-009**: Recording button MUST display appropriate icons for each state: microphone (idle), stop (recording), spinner (processing), alert (error)
- **FR-010**: Recording button MUST animate smoothly between state transitions (fade, scale, or pulse animations)

#### Transcription Display

- **FR-011**: System MUST display transcribed text in real-time with updates appearing within 500ms of speech
- **FR-012**: Transcription display MUST support Dynamic Type for accessibility (minimum Large, maximum AX5)
- **FR-013**: Transcription display MUST show a placeholder text when empty: "Tap to start recording..."
- **FR-014**: Transcription display MUST highlight or emphasize newly added words to show real-time progress
- **FR-015**: Transcription display MUST be scrollable if text exceeds visible area

#### Permission Handling

- **FR-016**: System MUST check microphone permission status before attempting to record
- **FR-017**: System MUST display a pre-permission explanation dialog before showing system permission prompt
- **FR-018**: Pre-permission dialog MUST clearly explain why microphone access is needed: "To log your meals by voice"
- **FR-019**: System MUST handle all permission states: not determined, authorized, denied, restricted
- **FR-020**: System MUST provide a direct link to Settings when permission is denied
- **FR-021**: System MUST check speech recognition authorization separately from microphone permission

#### Haptic Feedback

- **FR-022**: System MUST trigger medium-impact haptic feedback when recording starts
- **FR-023**: System MUST trigger medium-impact haptic feedback when recording stops (manual or automatic)
- **FR-024**: System MUST trigger notification-style haptic feedback when errors occur
- **FR-025**: System MUST respect user's haptic feedback settings (disabled in Settings)

#### Error Handling

- **FR-026**: System MUST display user-friendly error messages for all failure scenarios
- **FR-027**: Error messages MUST be specific and actionable (not generic "An error occurred")
- **FR-028**: System MUST preserve partial transcription when errors occur mid-recording
- **FR-029**: System MUST offer retry option for transient errors (network timeout, temporary service unavailable)
- **FR-030**: System MUST offer manual entry fallback for all error scenarios
- **FR-031**: System MUST log errors for debugging without exposing technical details to users

#### Accessibility

- **FR-032**: All interactive elements MUST support VoiceOver with descriptive labels
- **FR-033**: Recording button MUST announce state changes to VoiceOver users: "Recording started", "Recording stopped"
- **FR-034**: System MUST support Dynamic Type scaling for all text elements
- **FR-035**: System MUST provide sufficient color contrast (WCAG AA minimum) for all visual states
- **FR-036**: System MUST support Reduce Motion accessibility setting with alternative animations
- **FR-037**: System MUST be fully navigable using Switch Control

#### Integration with Services

- **FR-038**: Voice input view MUST integrate with [`SpeechRecognitionService`](Demeter/Services/Speech/SpeechRecognitionService.swift) for audio capture and transcription
- **FR-039**: System MUST pass transcribed text to LLM service for nutritional analysis
- **FR-040**: System MUST handle service errors gracefully and provide appropriate user feedback
- **FR-041**: System MUST display loading state while LLM processes transcription
- **FR-042**: System MUST navigate to results view after successful transcription and processing

### Key Entities

- **VoiceInputView**: Main SwiftUI view containing the voice input interface. Key attributes: recordingState, transcribedText, errorMessage, isPermissionGranted
- **VoiceRecordingButton**: Custom SwiftUI button component for voice recording. Key attributes: buttonState (idle/recording/processing/error), isEnabled, hapticFeedback
- **TranscriptionDisplayView**: SwiftUI view for showing real-time transcription. Key attributes: text, isAnimating, highlightedRange
- **VoiceInputViewModel**: ObservableObject managing business logic. Key attributes: speechService, transcriptionText, recordingState, permissionStatus, errorMessage
- **RecordingState**: Enum representing current state. Values: idle, recording, processing, success, error(Error)
- **PermissionStatus**: Enum representing permission state. Values: notDetermined, authorized, denied, restricted

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can start voice recording with a single tap, with recording beginning within 500ms
- **SC-002**: Real-time transcription appears on screen within 500ms of user starting to speak
- **SC-003**: 95% of users successfully complete their first voice input without errors in normal conditions
- **SC-004**: Recording automatically stops within 2 seconds of user finishing speech (silence detection)
- **SC-005**: All recording state transitions provide clear visual feedback within 100ms
- **SC-006**: Haptic feedback triggers within 50ms of button tap for immediate tactile confirmation
- **SC-007**: Permission request flow completes in under 30 seconds for first-time users
- **SC-008**: Error messages appear within 1 second of error occurrence with clear next steps
- **SC-009**: Manual entry fallback is accessible within 2 taps from any error state
- **SC-010**: Voice input interface maintains 60fps animation performance on supported devices
- **SC-011**: VoiceOver users can complete voice input flow with same success rate as sighted users
- **SC-012**: Interface adapts correctly to all Dynamic Type sizes without layout breaking

## Assumptions

- Users will primarily use voice input in relatively quiet environments suitable for speech recognition
- The [`SpeechRecognitionService`](Demeter/Services/Speech/SpeechRecognitionService.swift) is already implemented and functional (from spec 003)
- Users have iOS 18.0+ devices with Speech framework support
- Microphone hardware is functional and not physically blocked
- Users understand basic voice input concepts (speak clearly, avoid background noise)
- English language is sufficient for MVP (internationalization is post-MVP)
- Users will grant microphone permission when properly explained
- Network connectivity is available for speech recognition (on-device recognition is fallback)

## Dependencies

- [`SpeechRecognitionService`](Demeter/Services/Speech/SpeechRecognitionService.swift) from spec 003-core-services-infrastructure
- LLMService for processing transcribed text (from spec 003)
- iOS 18.0+ with Speech framework and AVFoundation
- SwiftUI for UI implementation
- Combine framework for reactive state management
- Microphone hardware and permissions
- Speech recognition service availability (on-device or cloud)

## Out of Scope (Post-MVP)

- Multi-language voice input support
- Custom wake word detection ("Hey Demeter")
- Voice commands for app navigation
- Continuous listening mode (always-on voice input)
- Voice profile training for improved accuracy
- Noise cancellation or audio enhancement
- Voice input from Apple Watch
- Offline voice recognition (cloud-based is MVP)
- Voice input history or playback
- Sharing voice recordings
- Voice-to-text editing capabilities
- Custom vocabulary or pronunciation training