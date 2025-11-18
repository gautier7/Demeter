# Implementation Tasks: Voice Input Interface

**Feature**: 004-voice-input | **Plan**: [plan.md](plan.md) | **Spec**: [spec.md](spec.md)

**Generated**: 2025-11-18 | **Status**: Ready for Phase 0 Research

---

## Phase 0: Research & Clarification (3 days)

### Task 0.1: Research Speech Framework Best Practices
**Objective**: Understand iOS 18 Speech Framework patterns for real-time transcription

**Deliverables**:
- Real-time transcription implementation patterns
- Endpoint detection (silence detection) strategies
- Error handling and recovery approaches
- Performance optimization techniques

**Acceptance Criteria**:
- [ ] Document 3+ real-time transcription patterns
- [ ] Identify endpoint detection threshold recommendations
- [ ] List common error scenarios and recovery strategies
- [ ] Provide performance optimization checklist

**Estimated Effort**: 1 day

---

### Task 0.2: Research Permission Handling Patterns
**Objective**: Identify iOS 18 best practices for microphone permission requests

**Deliverables**:
- Pre-permission explanation dialog patterns
- System permission request flow
- Permission denied state handling
- Permission caching strategies

**Acceptance Criteria**:
- [ ] Document 2+ pre-permission dialog patterns
- [ ] Outline system permission request flow
- [ ] Identify Settings navigation approach
- [ ] Define permission caching strategy

**Estimated Effort**: 0.5 days

---

### Task 0.3: Research Haptic Feedback Implementation
**Objective**: Understand haptic feedback patterns and accessibility integration

**Deliverables**:
- UIImpactFeedbackGenerator vs UINotificationFeedbackGenerator comparison
- Accessibility settings integration approach
- Performance impact analysis
- Haptic pattern recommendations

**Acceptance Criteria**:
- [ ] Compare feedback generator types with pros/cons
- [ ] Document accessibility settings integration
- [ ] Measure performance impact
- [ ] Define haptic patterns for each state

**Estimated Effort**: 0.5 days

---

### Task 0.4: Research Accessibility Compliance
**Objective**: Ensure WCAG AA compliance for voice input interface

**Deliverables**:
- VoiceOver announcement patterns
- Dynamic Type scaling implementation
- Color contrast requirements
- Reduce Motion alternatives

**Acceptance Criteria**:
- [ ] Document VoiceOver announcement patterns
- [ ] Identify Dynamic Type scaling approach
- [ ] Verify WCAG AA color contrast requirements
- [ ] Design Reduce Motion alternatives

**Estimated Effort**: 0.5 days

---

### Task 0.5: Research State Management Patterns
**Objective**: Identify best practices for Combine-based state management

**Deliverables**:
- Combine publisher patterns for real-time updates
- Error handling in async/await context
- State machine implementation patterns
- Testing async state changes

**Acceptance Criteria**:
- [ ] Document 2+ Combine publisher patterns
- [ ] Outline error handling approach
- [ ] Design state machine structure
- [ ] Identify testing strategies

**Estimated Effort**: 0.5 days

---

### Task 0.6: Verify SpeechRecognitionService Integration
**Objective**: Confirm SpeechRecognitionService API and integration approach

**Deliverables**:
- API signature documentation
- Real-time transcription support verification
- Error type enumeration
- Integration pattern recommendations

**Acceptance Criteria**:
- [ ] Confirm SpeechRecognitionService exists and is functional
- [ ] Document all public methods and their signatures
- [ ] Verify real-time transcription via Combine publishers
- [ ] List all error types and handling approach

**Estimated Effort**: 0.5 days

---

## Phase 1: Design & Contracts (4 days)

### Task 1.1: Define Data Models
**Objective**: Create entity definitions for voice input feature

**Deliverables**: `data-model.md`

**Components to Define**:
- RecordingState enum (idle, recording, processing, success, error)
- PermissionStatus enum (notDetermined, authorized, denied, restricted)
- VoiceInputError enum (microphoneNotAvailable, permissionDenied, etc.)
- State transition rules and validation

**Acceptance Criteria**:
- [ ] RecordingState enum with all states documented
- [ ] PermissionStatus enum with all states documented
- [ ] VoiceInputError enum with 8+ error cases
- [ ] State transition diagram included
- [ ] Validation rules documented

**Estimated Effort**: 1 day

---

### Task 1.2: Create API Contracts
**Objective**: Define component APIs and integration contracts

**Deliverables**: 
- `contracts/voice-input-apis.md`
- `contracts/permission-contracts.md`
- `contracts/state-machine.md`

**Contracts to Define**:
- VoiceInputView API and props
- VoiceRecordingButton API and props
- TranscriptionDisplayView API and props
- VoiceInputViewModel API and methods
- Permission request flow
- State machine transitions

**Acceptance Criteria**:
- [ ] VoiceInputView contract with all props documented
- [ ] VoiceRecordingButton contract with state handling
- [ ] TranscriptionDisplayView contract with update patterns
- [ ] VoiceInputViewModel contract with all methods
- [ ] Permission flow diagram included
- [ ] State machine diagram included

**Estimated Effort**: 1.5 days

---

### Task 1.3: Create Quickstart Guide
**Objective**: Provide developer integration guide

**Deliverables**: `quickstart.md`

**Content**:
- Component usage examples
- SpeechRecognitionService integration
- Permission handling walkthrough
- Error handling patterns
- Testing examples

**Acceptance Criteria**:
- [ ] 3+ component usage examples
- [ ] SpeechRecognitionService integration example
- [ ] Permission flow example
- [ ] Error handling example
- [ ] Unit test example

**Estimated Effort**: 1 day

---

### Task 1.4: Update Agent Context
**Objective**: Update agent knowledge base with new components

**Deliverables**: Updated agent-specific context file

**Actions**:
- Run `.specify/scripts/bash/update-agent-context.sh kilocode`
- Add Swift 5.9 (iOS 18.0+) components
- Document SwiftUI view patterns
- Add Speech Framework integration notes
- Document Combine reactive patterns
- Add accessibility requirements

**Acceptance Criteria**:
- [ ] Script executed successfully
- [ ] Agent context file updated
- [ ] New components documented
- [ ] Integration patterns added
- [ ] Accessibility requirements included

**Estimated Effort**: 0.5 days

---

## Phase 2A: Foundation (3 days)

### Task 2A.1: Implement RecordingState and PermissionStatus Enums
**Objective**: Create core state enums

**Deliverables**:
- `Features/VoiceInput/Models/RecordingState.swift`
- `Features/VoiceInput/Models/PermissionStatus.swift`
- `Features/VoiceInput/Models/VoiceInputError.swift`

**Requirements**:
- RecordingState with 5 cases (idle, recording, processing, success, error)
- PermissionStatus with 4 cases (notDetermined, authorized, denied, restricted)
- VoiceInputError with 8+ error cases
- Equatable and Hashable conformance
- Codable conformance for persistence

**Acceptance Criteria**:
- [ ] RecordingState enum compiles and has all cases
- [ ] PermissionStatus enum compiles and has all cases
- [ ] VoiceInputError enum compiles with 8+ cases
- [ ] All enums conform to Equatable
- [ ] All enums conform to Hashable
- [ ] Unit tests pass for enum behavior

**Estimated Effort**: 1 day

---

### Task 2A.2: Implement SpeechPermissionManager
**Objective**: Create permission request and status checking service

**Deliverables**: `Services/Speech/SpeechPermissionManager.swift`

**Requirements**:
- Check microphone permission status
- Check speech recognition authorization
- Request microphone permission with explanation
- Request speech recognition authorization
- Handle all permission states (notDetermined, authorized, denied, restricted)
- Provide Settings URL for denied state

**Acceptance Criteria**:
- [ ] checkMicrophonePermission() returns PermissionStatus
- [ ] checkSpeechRecognitionAuthorization() returns PermissionStatus
- [ ] requestMicrophonePermission() shows explanation dialog
- [ ] requestSpeechRecognitionAuthorization() requests authorization
- [ ] All permission states handled correctly
- [ ] Settings URL provided for denied state
- [ ] Unit tests pass with 80%+ coverage

**Estimated Effort**: 1 day

---

### Task 2A.3: Implement HapticManager
**Objective**: Create haptic feedback service

**Deliverables**: `Core/Utilities/HapticManager.swift`

**Requirements**:
- Trigger medium-impact haptic on recording start
- Trigger medium-impact haptic on recording stop
- Trigger notification-style haptic on error
- Respect user's haptic feedback settings
- Handle devices without haptic support

**Acceptance Criteria**:
- [ ] triggerRecordingStart() triggers medium-impact feedback
- [ ] triggerRecordingStop() triggers medium-impact feedback
- [ ] triggerError() triggers notification-style feedback
- [ ] Respects system haptic settings
- [ ] Gracefully handles devices without haptics
- [ ] Unit tests pass with 80%+ coverage

**Estimated Effort**: 0.5 days

---

### Task 2A.4: Create VoiceInputViewModel Skeleton
**Objective**: Implement ViewModel with state management

**Deliverables**: `Features/VoiceInput/ViewModels/VoiceInputViewModel.swift`

**Requirements**:
- @Published properties for recordingState, transcribedText, permissionStatus, errorMessage
- startRecording() async method
- stopRecording() async method
- requestMicrophonePermission() async method
- checkPermissionStatus() method
- Combine publishers for real-time updates
- Error handling and recovery

**Acceptance Criteria**:
- [ ] ViewModel compiles and is @MainActor
- [ ] All @Published properties present
- [ ] startRecording() method implemented
- [ ] stopRecording() method implemented
- [ ] requestMicrophonePermission() method implemented
- [ ] checkPermissionStatus() method implemented
- [ ] Combine publishers configured
- [ ] Unit tests pass with 80%+ coverage

**Estimated Effort**: 1 day

---

## Phase 2B: UI Components (5 days)

### Task 2B.1: Implement VoiceRecordingButton
**Objective**: Create custom recording button with state animations

**Deliverables**: `Features/VoiceInput/Views/VoiceRecordingButton.swift`

**Requirements**:
- Display microphone icon in idle state
- Show pulsing animation in recording state
- Show loading spinner in processing state
- Show error icon in error state
- Color coding: blue (idle), red (recording), gray (processing), red (error)
- Smooth state transitions with animations
- Accessibility labels and announcements
- Haptic feedback on tap
- Minimum 44x44 points size

**Acceptance Criteria**:
- [ ] Button renders correctly in all states
- [ ] Animations are smooth and 60fps
- [ ] Color coding matches specification
- [ ] Icons display correctly for each state
- [ ] VoiceOver labels present and accurate
- [ ] Haptic feedback triggers on tap
- [ ] Minimum size requirement met
- [ ] UI tests pass for all states

**Estimated Effort**: 1.5 days

---

### Task 2B.2: Implement TranscriptionDisplayView
**Objective**: Create real-time transcription display component

**Deliverables**: `Features/VoiceInput/Views/TranscriptionDisplayView.swift`

**Requirements**:
- Display transcribed text in real-time
- Show placeholder text when empty: "Tap to start recording..."
- Support Dynamic Type (Large to AX5)
- Highlight newly added words
- Scrollable if text exceeds visible area
- Recording duration timer display
- Waveform or audio level indicator
- Accessibility support

**Acceptance Criteria**:
- [ ] Text displays correctly in real-time
- [ ] Placeholder text shows when empty
- [ ] Dynamic Type scaling works for all sizes
- [ ] New words are highlighted
- [ ] Scrolling works when needed
- [ ] Timer displays and updates
- [ ] Audio level indicator animates
- [ ] VoiceOver support present
- [ ] UI tests pass

**Estimated Effort**: 1.5 days

---

### Task 2B.3: Implement VoiceInputView
**Objective**: Create main voice input interface

**Deliverables**: `Features/VoiceInput/Views/VoiceInputView.swift`

**Requirements**:
- Display VoiceRecordingButton prominently
- Display TranscriptionDisplayView below button
- Show "Type instead" button for manual entry fallback
- Display error messages when applicable
- Show loading state during LLM processing
- Accessibility support for all elements
- Responsive layout for different screen sizes

**Acceptance Criteria**:
- [ ] VoiceRecordingButton displays prominently
- [ ] TranscriptionDisplayView shows below button
- [ ] "Type instead" button present and functional
- [ ] Error messages display correctly
- [ ] Loading state shows during processing
- [ ] Layout responsive on all screen sizes
- [ ] VoiceOver support complete
- [ ] UI tests pass for main flows

**Estimated Effort**: 1.5 days

---

## Phase 2C: Business Logic (5 days)

### Task 2C.1: Implement Recording Start/Stop Logic
**Objective**: Implement core recording functionality

**Deliverables**: Updates to `VoiceInputViewModel.swift`

**Requirements**:
- startRecording() initiates SpeechRecognitionService
- stopRecording() stops recording and processes transcription
- Automatic stop on silence (2 seconds)
- Update recordingState during recording
- Update transcribedText in real-time
- Handle recording errors gracefully

**Acceptance Criteria**:
- [ ] startRecording() starts recording within 500ms
- [ ] stopRecording() stops recording cleanly
- [ ] Auto-stop triggers within 2 seconds of silence
- [ ] recordingState updates correctly
- [ ] transcribedText updates in real-time
- [ ] Errors handled gracefully
- [ ] Unit tests pass with 80%+ coverage

**Estimated Effort**: 1.5 days

---

### Task 2C.2: Implement Permission Request Flow
**Objective**: Implement permission handling with pre-permission dialog

**Deliverables**: Updates to `VoiceInputViewModel.swift` and `VoiceInputView.swift`

**Requirements**:
- Check permission before recording
- Show pre-permission explanation dialog
- Request system permission
- Handle all permission states
- Provide Settings link for denied state
- Cache permission status appropriately

**Acceptance Criteria**:
- [ ] Permission checked before recording
- [ ] Pre-permission dialog shows with explanation
- [ ] System permission prompt appears
- [ ] All permission states handled
- [ ] Settings link works for denied state
- [ ] Permission flow completes in <30 seconds
- [ ] Unit tests pass with 80%+ coverage

**Estimated Effort**: 1.5 days

---

### Task 2C.3: Implement Error Handling and Recovery
**Objective**: Implement comprehensive error handling

**Deliverables**: Updates to `VoiceInputViewModel.swift` and `VoiceInputView.swift`

**Requirements**:
- Display user-friendly error messages
- Preserve partial transcription on error
- Offer retry option for transient errors
- Offer manual entry fallback
- Log errors for debugging
- Handle all error scenarios from spec

**Acceptance Criteria**:
- [ ] Error messages are specific and actionable
- [ ] Partial transcription preserved
- [ ] Retry option available for transient errors
- [ ] Manual entry fallback always available
- [ ] Errors logged without exposing details
- [ ] All error scenarios handled
- [ ] Unit tests pass with 80%+ coverage

**Estimated Effort**: 1.5 days

---

### Task 2C.4: Implement Haptic Feedback Integration
**Objective**: Integrate haptic feedback throughout feature

**Deliverables**: Updates to `VoiceInputViewModel.swift` and `VoiceRecordingButton.swift`

**Requirements**:
- Trigger medium-impact haptic on recording start
- Trigger medium-impact haptic on recording stop
- Trigger notification-style haptic on error
- Respect user's haptic feedback settings
- Provide haptic feedback within 50ms of action

**Acceptance Criteria**:
- [ ] Haptic triggers on recording start
- [ ] Haptic triggers on recording stop
- [ ] Haptic triggers on error
- [ ] System haptic settings respected
- [ ] Haptic feedback within 50ms
- [ ] Unit tests pass with 80%+ coverage

**Estimated Effort**: 0.5 days

---

## Phase 2D: Integration (3 days)

### Task 2D.1: Integrate SpeechRecognitionService
**Objective**: Connect ViewModel to SpeechRecognitionService

**Deliverables**: Updates to `VoiceInputViewModel.swift`

**Requirements**:
- Inject SpeechRecognitionService dependency
- Call startRecording() on service
- Subscribe to real-time transcription updates
- Handle service errors
- Coordinate recording state with service state

**Acceptance Criteria**:
- [ ] SpeechRecognitionService injected
- [ ] startRecording() calls service method
- [ ] Real-time updates received via Combine
- [ ] Service errors handled correctly
- [ ] Recording state synchronized
- [ ] Integration tests pass

**Estimated Effort**: 1 day

---

### Task 2D.2: Integrate LLMService
**Objective**: Connect transcription to LLM processing

**Deliverables**: Updates to `VoiceInputViewModel.swift`

**Requirements**:
- Pass transcribed text to LLMService
- Handle LLM processing state
- Display loading state during processing
- Handle LLM errors gracefully
- Navigate to results view on success

**Acceptance Criteria**:
- [ ] Transcription passed to LLMService
- [ ] Processing state displayed
- [ ] LLM errors handled
- [ ] Navigation to results works
- [ ] Integration tests pass

**Estimated Effort**: 1 day

---

### Task 2D.3: Test Integration Flows
**Objective**: Verify end-to-end integration

**Deliverables**: Integration test suite

**Test Scenarios**:
- Voice input → Transcription → LLM processing → Results
- Permission denied → Settings navigation
- Recording error → Manual entry fallback
- Network error → Retry logic
- Silence detection → Auto-stop

**Acceptance Criteria**:
- [ ] All integration scenarios tested
- [ ] End-to-end flow works
- [ ] Error scenarios handled
- [ ] Integration tests pass

**Estimated Effort**: 1 day

---

## Phase 2E: Testing (4 days)

### Task 2E.1: Write Unit Tests for ViewModel
**Objective**: Achieve 80%+ coverage for VoiceInputViewModel

**Deliverables**: `Tests/Features/VoiceInput/VoiceInputViewModelTests.swift`

**Test Coverage**:
- Recording state transitions
- Permission status checks
- Error handling
- Haptic feedback triggers
- Real-time transcription updates

**Acceptance Criteria**:
- [ ] 80%+ code coverage for ViewModel
- [ ] All state transitions tested
- [ ] All error paths tested
- [ ] All public methods tested
- [ ] Tests pass consistently

**Estimated Effort**: 1.5 days

---

### Task 2E.2: Write Unit Tests for Components
**Objective**: Achieve 80%+ coverage for UI components

**Deliverables**:
- `Tests/Features/VoiceInput/VoiceRecordingButtonTests.swift`
- `Tests/Features/VoiceInput/TranscriptionDisplayViewTests.swift`

**Test Coverage**:
- Button state rendering
- Animation triggers
- Accessibility labels
- Text display and updates
- Dynamic Type scaling

**Acceptance Criteria**:
- [ ] 80%+ code coverage for components
- [ ] All states tested
- [ ] Accessibility tested
- [ ] Dynamic Type tested
- [ ] Tests pass consistently

**Estimated Effort**: 1 day

---

### Task 2E.3: Write Integration Tests
**Objective**: Test component interactions and service integration

**Deliverables**: `Tests/Features/VoiceInput/VoiceInputIntegrationTests.swift`

**Test Scenarios**:
- ViewModel → SpeechRecognitionService
- ViewModel → LLMService
- Permission flow
- Error recovery
- State synchronization

**Acceptance Criteria**:
- [ ] 20% of total tests are integration tests
- [ ] All critical flows tested
- [ ] Service mocks working correctly
- [ ] Tests pass consistently

**Estimated Effort**: 1 day

---

### Task 2E.4: Write UI Tests
**Objective**: Test critical user flows

**Deliverables**: `Tests/Features/VoiceInput/VoiceInputUITests.swift`

**Test Scenarios**:
- Tap recording button → Recording starts
- Speak → Transcription appears
- Tap stop → Recording stops
- Permission denied → Settings link works
- Error → Manual entry available

**Acceptance Criteria**:
- [ ] 10% of total tests are UI tests
- [ ] All critical user flows tested
- [ ] Tests pass on simulator
- [ ] Tests pass on device

**Estimated Effort**: 0.5 days

---

## Phase 2F: Polish (3 days)

### Task 2F.1: Performance Optimization
**Objective**: Achieve 60fps animations and optimize latency

**Deliverables**: Performance-optimized components

**Optimizations**:
- Reduce animation frame drops
- Optimize transcription display updates
- Minimize ViewModel state changes
- Profile and optimize memory usage

**Acceptance Criteria**:
- [ ] 60fps animations on iPhone 14+
- [ ] Recording starts within 500ms
- [ ] Transcription updates within 500ms
- [ ] Memory usage < 100MB
- [ ] Performance tests pass

**Estimated Effort**: 1 day

---

### Task 2F.2: Animation Refinement
**Objective**: Polish animations and transitions

**Deliverables**: Refined animation implementations

**Refinements**:
- Smooth state transitions
- Pulsing animation for recording state
- Loading spinner animation
- Text highlight animation

**Acceptance Criteria**:
- [ ] All animations smooth and 60fps
- [ ] State transitions polished
- [ ] Animations respect Reduce Motion
- [ ] Visual feedback clear and responsive

**Estimated Effort**: 0.5 days

---

### Task 2F.3: Error Message UX
**Objective**: Improve error message clarity and actionability

**Deliverables**: Refined error messages and recovery flows

**Improvements**:
- Clear, specific error messages
- Actionable next steps
- Visual error indicators
- Recovery options prominent

**Acceptance Criteria**:
- [ ] All error messages specific and actionable
- [ ] Recovery options clear
- [ ] Error states visually distinct
- [ ] User testing confirms clarity

**Estimated Effort**: 0.5 days

---

### Task 2F.4: Accessibility Audit
**Objective**: Verify WCAG AA compliance

**Deliverables**: Accessibility audit report and fixes

**Audit Items**:
- VoiceOver functionality
- Dynamic Type scaling
- Color contrast (WCAG AA)
- Keyboard navigation
- Reduce Motion support

**Acceptance Criteria**:
- [ ] VoiceOver fully functional
- [ ] Dynamic Type works for all sizes
- [ ] Color contrast meets WCAG AA
- [ ] Keyboard navigation works
- [ ] Reduce Motion alternatives present
- [ ] Audit report completed

**Estimated Effort**: 1 day

---

## Summary

**Total Estimated Effort**: 25 business days (5 weeks)

| Phase | Duration | Tasks |
|-------|----------|-------|
| Phase 0 | 3 days | 6 research tasks |
| Phase 1 | 4 days | 4 design tasks |
| Phase 2A | 3 days | 4 foundation tasks |
| Phase 2B | 5 days | 3 UI component tasks |
| Phase 2C | 5 days | 4 business logic tasks |
| Phase 2D | 3 days | 3 integration tasks |
| Phase 2E | 4 days | 4 testing tasks |
| Phase 2F | 3 days | 4 polish tasks |

**Critical Path**: Phase 0 → Phase 1 → Phase 2A → Phase 2B/C (parallel) → Phase 2D → Phase 2E → Phase 2F

**Dependencies**:
- SpeechRecognitionService must be available before Phase 2D
- LLMService must be available before Phase 2D
- All Phase 0 research must complete before Phase 1

---

**Status**: ✅ Ready for Phase 0 Research  
**Last Updated**: 2025-11-18  
**Next Review**: After Phase 0 completion
