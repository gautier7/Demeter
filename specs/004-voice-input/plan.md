# Implementation Plan: Voice Input Interface

**Branch**: `004-voice-input` | **Date**: 2025-11-18 | **Spec**: [specs/004-voice-input/spec.md](spec.md)

**Input**: Feature specification from `/specs/004-voice-input/spec.md` with validation against STRUCTURE_VALIDATION.md and technical constitution

**Note**: This plan is generated following the implementation planning workflow. See `.specify/templates/commands/plan.md` for execution details.

## Summary

Implement the Voice Input Interface feature for the Demeter iOS calorie tracking application. This feature enables users to tap a single button to start recording their food intake through voice, see real-time transcription feedback, and gracefully handle errors with fallback to manual entry. The voice input interface is the primary interaction method and core value proposition of the application.

**Key Deliverables**:
- VoiceInputView: Main SwiftUI interface with recording button and transcription display
- VoiceRecordingButton: Custom reusable button component with state animations
- TranscriptionDisplayView: Real-time transcription display with dynamic updates
- VoiceInputViewModel: Business logic managing recording state, permissions, and error handling
- Integration with SpeechRecognitionService (from spec 003)
- Comprehensive error handling and permission management
- Accessibility support (VoiceOver, Dynamic Type, Reduce Motion)
- Haptic feedback for user confirmation

## Technical Context

**Language/Version**: Swift 5.9 (iOS 18.0+)  
**Primary Dependencies**: SwiftUI, Speech Framework, AVFoundation, Combine  
**Architecture Pattern**: MVVM with reactive state management  
**Testing**: XCTest with SwiftTesting framework  
**Target Platform**: iOS 18.0+  
**Performance Goals**: Recording starts within 500ms, transcription updates within 500ms, 60fps animations  
**Constraints**: 
- Requires microphone permission (runtime request)
- Speech recognition service availability dependent
- Real-time transcription requires network connectivity (on-device fallback available)
- Haptic feedback respects system settings
- Accessibility compliance (WCAG AA minimum)

**Scale/Scope**: MVP feature with 7 user stories, 42 functional requirements, 12 success criteria

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Voice-First Interaction Model**: Feature implements single-tap voice activation, real-time transcription, haptic feedback as specified in constitution section I.1

✅ **MVVM Architecture**: VoiceInputView (presentation), VoiceInputViewModel (business logic), RecordingState enum (model) follow MVVM pattern

✅ **Service Layer Integration**: Integrates with SpeechRecognitionService (from spec 003) and will integrate with LLMService (from spec 003)

✅ **Permission Handling**: Implements pre-permission explanation dialog and system permission request as per constitution requirements

✅ **Accessibility Requirements**: Supports VoiceOver, Dynamic Type (Large to AX5), high contrast, Reduce Motion alternatives

✅ **Error Handling**: Graceful error handling with user-friendly messages and fallback to manual entry

✅ **iOS 18 Frameworks**: Uses SwiftUI, Speech Framework, AVFoundation, Combine as specified in constitution section III

✅ **Data Privacy**: Voice data processed transiently, never stored; no external data sharing

✅ **Haptic Feedback**: Implements haptic feedback for recording start/stop and errors as specified in constitution

**Post-Design Re-evaluation**: Design artifacts will verify all 42 functional requirements are addressed, all 7 user stories have acceptance criteria met, and all success criteria are measurable and achievable.

**Gates Status**: Ready for Phase 0 research.

## Project Structure

### Documentation (this feature)

```text
specs/004-voice-input/
├── plan.md                          # This file
├── research.md                      # Phase 0: Research findings (TBD)
├── data-model.md                    # Phase 1: Entity definitions (TBD)
├── quickstart.md                    # Phase 1: Developer quickstart (TBD)
├── contracts/                       # Phase 1: API contracts (TBD)
│   ├── voice-input-apis.md
│   ├── permission-contracts.md
│   └── state-machine.md
├── spec.md                          # Feature specification
└── checklists/
    └── requirements.md              # Requirements checklist
```

### Source Code (repository root)

```text
Demeter/
├── Features/
│   └── VoiceInput/
│       ├── Views/
│       │   ├── VoiceInputView.swift
│       │   ├── VoiceRecordingButton.swift
│       │   └── TranscriptionDisplayView.swift
│       ├── ViewModels/
│       │   └── VoiceInputViewModel.swift
│       └── Models/
│           ├── RecordingState.swift
│           └── PermissionStatus.swift
├── Services/
│   └── Speech/
│       ├── SpeechRecognitionService.swift (from spec 003)
│       ├── SpeechPermissionManager.swift
│       └── AudioEngineManager.swift
├── Core/
│   └── Utilities/
│       └── HapticManager.swift
└── Tests/
    ├── Features/
    │   └── VoiceInput/
    │       ├── VoiceInputViewModelTests.swift
    │       ├── VoiceRecordingButtonTests.swift
    │       └── TranscriptionDisplayViewTests.swift
    └── Services/
        └── Speech/
            ├── SpeechRecognitionServiceTests.swift
            └── SpeechPermissionManagerTests.swift
```

**Structure Decision**: Feature-based organization following MVVM pattern. VoiceInput feature contains all presentation layer components (Views, ViewModels). Speech services in Services layer for reusability. Core utilities for cross-cutting concerns like haptics. Tests mirror source structure for clarity.

## Complexity Tracking

### Known Unknowns (NEEDS CLARIFICATION)

1. **Speech Recognition Service Implementation Status**
   - Is SpeechRecognitionService from spec 003 already implemented?
   - What is the exact API signature for startRecording() and stopRecording()?
   - Does it support real-time transcription updates via Combine publishers?
   - What error types does it throw?

2. **LLM Service Integration Timing**
   - When will LLMService be available (spec 003)?
   - Should VoiceInputView handle LLM processing or pass to parent?
   - What is the expected response format from LLMService?

3. **Haptic Feedback Implementation**
   - Is HapticManager already implemented in Core/Utilities?
   - What haptic patterns are available (light, medium, heavy, notification)?
   - Should haptics respect accessibility settings automatically?

4. **Permission Flow Design**
   - Should pre-permission dialog be reusable component or inline?
   - How to handle permission denied → Settings navigation?
   - Should we cache permission status or check each time?

5. **Error Recovery Strategy**
   - For transient errors (network timeout), should we auto-retry?
   - How many retry attempts before showing manual entry fallback?
   - Should partial transcription be preserved across retries?

6. **State Management Scope**
   - Should VoiceInputViewModel manage LLM processing state or just voice recording?
   - How to coordinate between voice recording and LLM processing states?
   - Should recording state be persisted across app backgrounding?

### Assumptions Validated

✅ SpeechRecognitionService exists and is functional (from spec 003)  
✅ iOS 18.0+ devices have Speech Framework support  
✅ Microphone hardware is functional (user responsibility)  
✅ Users understand basic voice input concepts  
✅ English language is sufficient for MVP  
✅ Network connectivity available for speech recognition  
✅ Users will grant microphone permission when properly explained  

### Dependencies & Prerequisites

**Hard Dependencies**:
- SpeechRecognitionService (spec 003) - MUST be implemented first
- SwiftUI framework (iOS 18.0+)
- Speech Framework (iOS 18.0+)
- AVFoundation (iOS 18.0+)
- Combine framework (iOS 18.0+)

**Soft Dependencies**:
- LLMService (spec 003) - needed for full integration but VoiceInputView can work standalone
- HapticManager (Core/Utilities) - optional but recommended for UX
- PermissionManager (Core/Utilities) - optional but recommended for reusability

**Blocking Issues**: None identified. SpeechRecognitionService from spec 003 is prerequisite.

## Phase 0: Research & Clarification

### Research Tasks

1. **Speech Framework Best Practices**
   - Real-time transcription patterns in iOS 18
   - Endpoint detection (silence detection) implementation
   - Error handling and recovery strategies
   - Performance optimization for continuous listening

2. **Permission Handling Patterns**
   - iOS 18 permission request best practices
   - Pre-permission explanation dialog patterns
   - Settings navigation from denied state
   - Permission caching strategies

3. **Haptic Feedback Implementation**
   - UIImpactFeedbackGenerator vs UINotificationFeedbackGenerator
   - Accessibility settings integration
   - Performance impact of haptic feedback
   - Haptic patterns for different states

4. **Accessibility Compliance**
   - VoiceOver announcements for state changes
   - Dynamic Type scaling for all text elements
   - Color contrast requirements (WCAG AA)
   - Reduce Motion alternatives for animations

5. **State Management Patterns**
   - Combine publishers for real-time updates
   - Error handling in async/await context
   - State machine implementation for recording states
   - Testing async state changes

6. **Integration with SpeechRecognitionService**
   - Verify API signatures and return types
   - Understand error types and handling
   - Confirm real-time transcription support
   - Test integration patterns

### Research Output

**Deliverable**: `research.md` with findings for each research task, including:
- Decision: What was chosen
- Rationale: Why chosen
- Alternatives considered: What else was evaluated
- Implementation notes: Key considerations

## Phase 1: Design & Contracts

### 1.1 Data Model Definition

**Entities to Define**:

1. **RecordingState** (Enum)
   - idle: Ready for recording
   - recording: Currently recording
   - processing: Analyzing transcription
   - success: Recording completed successfully
   - error(Error): Recording failed with error

2. **PermissionStatus** (Enum)
   - notDetermined: User hasn't been asked
   - authorized: User granted permission
   - denied: User denied permission
   - restricted: System restricted (parental controls)

3. **VoiceInputError** (Enum)
   - microphoneNotAvailable
   - permissionDenied
   - permissionRestricted
   - speechRecognitionUnavailable
   - recordingFailed(String)
   - transcriptionFailed(String)
   - networkError(String)
   - unknown(String)

**Deliverable**: `data-model.md` with entity definitions, relationships, validation rules, and state transitions

### 1.2 API Contracts

**VoiceInputView Contract**:
```swift
struct VoiceInputView: View {
    @StateObject var viewModel: VoiceInputViewModel
    var onTranscriptionComplete: (String) -> Void
    var onError: (VoiceInputError) -> Void
}
```

**VoiceRecordingButton Contract**:
```swift
struct VoiceRecordingButton: View {
    let state: RecordingState
    let isEnabled: Bool
    let action: () -> Void
    let hapticFeedback: Bool = true
}
```

**TranscriptionDisplayView Contract**:
```swift
struct TranscriptionDisplayView: View {
    let text: String
    let isAnimating: Bool
    let highlightedRange: NSRange?
}
```

**VoiceInputViewModel Contract**:
```swift
@MainActor
class VoiceInputViewModel: ObservableObject {
    @Published var recordingState: RecordingState
    @Published var transcribedText: String
    @Published var permissionStatus: PermissionStatus
    @Published var errorMessage: String?
    
    func startRecording() async
    func stopRecording() async
    func requestMicrophonePermission() async -> Bool
    func checkPermissionStatus() -> PermissionStatus
}
```

**Deliverable**: `contracts/voice-input-apis.md` with detailed API contracts, `contracts/permission-contracts.md` with permission flow, `contracts/state-machine.md` with state transitions

### 1.3 Quickstart Guide

**Deliverable**: `quickstart.md` with:
- Component usage examples
- Integration with SpeechRecognitionService
- Permission handling walkthrough
- Error handling patterns
- Testing examples

### 1.4 Agent Context Update

**Action**: Run `.specify/scripts/bash/update-agent-context.sh kilocode` to update agent-specific context file with:
- New Swift 5.9 (iOS 18.0+) components
- SwiftUI view patterns
- Speech Framework integration
- Combine reactive patterns
- Accessibility requirements

## Phase 2: Implementation Planning

### Implementation Phases

**Phase 2A: Foundation (Week 1)**
- [ ] Define RecordingState, PermissionStatus, VoiceInputError enums
- [ ] Implement SpeechPermissionManager
- [ ] Implement HapticManager (if not exists)
- [ ] Create VoiceInputViewModel skeleton with state management

**Phase 2B: UI Components (Week 2)**
- [ ] Implement VoiceRecordingButton with state animations
- [ ] Implement TranscriptionDisplayView with real-time updates
- [ ] Implement VoiceInputView main interface
- [ ] Add accessibility labels and announcements

**Phase 2C: Business Logic (Week 2-3)**
- [ ] Implement recording start/stop logic in ViewModel
- [ ] Implement permission request flow
- [ ] Implement error handling and recovery
- [ ] Implement haptic feedback integration

**Phase 2D: Integration (Week 3)**
- [ ] Integrate with SpeechRecognitionService
- [ ] Test real-time transcription updates
- [ ] Test permission flows
- [ ] Test error scenarios

**Phase 2E: Testing (Week 4)**
- [ ] Unit tests for ViewModel (70% of tests)
- [ ] Integration tests for service interaction (20% of tests)
- [ ] UI tests for critical flows (10% of tests)
- [ ] Accessibility testing

**Phase 2F: Polish (Week 4-5)**
- [ ] Performance optimization
- [ ] Animation refinement
- [ ] Error message UX
- [ ] Accessibility audit

### Success Criteria Verification

Each implementation phase will verify corresponding success criteria:

- **SC-001**: Recording starts within 500ms ← Phase 2C
- **SC-002**: Transcription appears within 500ms ← Phase 2C
- **SC-003**: 95% success rate in normal conditions ← Phase 2E
- **SC-004**: Auto-stop within 2 seconds of silence ← Phase 2C
- **SC-005**: State transitions within 100ms ← Phase 2B
- **SC-006**: Haptic feedback within 50ms ← Phase 2C
- **SC-007**: Permission flow under 30 seconds ← Phase 2C
- **SC-008**: Error messages within 1 second ← Phase 2C
- **SC-009**: Manual entry within 2 taps ← Phase 2B
- **SC-010**: 60fps animation performance ← Phase 2B/F
- **SC-011**: VoiceOver success rate parity ← Phase 2E
- **SC-012**: Dynamic Type adaptation ← Phase 2B/E

## Functional Requirements Mapping

### Voice Input UI Components (FR-001 to FR-006)

| Requirement | Component | Implementation Phase |
|-------------|-----------|----------------------|
| FR-001: Prominent recording button (44x44 min) | VoiceRecordingButton | Phase 2B |
| FR-002: Real-time transcription display | TranscriptionDisplayView | Phase 2B |
| FR-003: Visual feedback for states | VoiceRecordingButton | Phase 2B |
| FR-004: "Type instead" button | VoiceInputView | Phase 2B |
| FR-005: Recording duration timer | TranscriptionDisplayView | Phase 2C |
| FR-006: Waveform/audio level indicator | VoiceRecordingButton | Phase 2B |

### Recording Button States (FR-007 to FR-010)

| Requirement | Component | Implementation Phase |
|-------------|-----------|----------------------|
| FR-007: Distinct visual states | VoiceRecordingButton | Phase 2B |
| FR-008: Color coding by state | VoiceRecordingButton | Phase 2B |
| FR-009: State-specific icons | VoiceRecordingButton | Phase 2B |
| FR-010: Smooth state animations | VoiceRecordingButton | Phase 2B |

### Transcription Display (FR-011 to FR-015)

| Requirement | Component | Implementation Phase |
|-------------|-----------|----------------------|
| FR-011: Real-time updates within 500ms | TranscriptionDisplayView | Phase 2C |
| FR-012: Dynamic Type support | TranscriptionDisplayView | Phase 2B |
| FR-013: Placeholder text | TranscriptionDisplayView | Phase 2B |
| FR-014: Highlight new words | TranscriptionDisplayView | Phase 2C |
| FR-015: Scrollable if needed | TranscriptionDisplayView | Phase 2B |

### Permission Handling (FR-016 to FR-021)

| Requirement | Component | Implementation Phase |
|-------------|-----------|----------------------|
| FR-016: Check permission before recording | VoiceInputViewModel | Phase 2C |
| FR-017: Pre-permission explanation dialog | VoiceInputView | Phase 2C |
| FR-018: Clear explanation text | VoiceInputView | Phase 2C |
| FR-019: Handle all permission states | SpeechPermissionManager | Phase 2A |
| FR-020: Direct link to Settings | VoiceInputView | Phase 2C |
| FR-021: Check speech recognition separately | SpeechPermissionManager | Phase 2A |

### Haptic Feedback (FR-022 to FR-025)

| Requirement | Component | Implementation Phase |
|-------------|-----------|----------------------|
| FR-022: Medium-impact on recording start | HapticManager | Phase 2C |
| FR-023: Medium-impact on recording stop | HapticManager | Phase 2C |
| FR-024: Notification-style on error | HapticManager | Phase 2C |
| FR-025: Respect user settings | HapticManager | Phase 2A |

### Error Handling (FR-026 to FR-031)

| Requirement | Component | Implementation Phase |
|-------------|-----------|----------------------|
| FR-026: User-friendly error messages | VoiceInputView | Phase 2C |
| FR-027: Specific, actionable messages | VoiceInputView | Phase 2C |
| FR-028: Preserve partial transcription | VoiceInputViewModel | Phase 2C |
| FR-029: Retry option for transient errors | VoiceInputView | Phase 2C |
| FR-030: Manual entry fallback | VoiceInputView | Phase 2B |
| FR-031: Log errors without exposing details | VoiceInputViewModel | Phase 2C |

### Accessibility (FR-032 to FR-037)

| Requirement | Component | Implementation Phase |
|-------------|-----------|----------------------|
| FR-032: VoiceOver support | All components | Phase 2B |
| FR-033: State change announcements | VoiceRecordingButton | Phase 2B |
| FR-034: Dynamic Type scaling | All components | Phase 2B |
| FR-035: Color contrast (WCAG AA) | All components | Phase 2B |
| FR-036: Reduce Motion support | VoiceRecordingButton | Phase 2B |
| FR-037: Switch Control support | All components | Phase 2B |

### Service Integration (FR-038 to FR-042)

| Requirement | Component | Implementation Phase |
|-------------|-----------|----------------------|
| FR-038: Integrate SpeechRecognitionService | VoiceInputViewModel | Phase 2D |
| FR-039: Pass text to LLM service | VoiceInputViewModel | Phase 2D |
| FR-040: Handle service errors gracefully | VoiceInputViewModel | Phase 2C |
| FR-041: Display loading state | VoiceInputView | Phase 2B |
| FR-042: Navigate to results view | VoiceInputView | Phase 2D |

## Risk Assessment

### High-Risk Items

1. **Real-time Transcription Latency** (Risk: HIGH)
   - Mitigation: Implement streaming transcription, optimize UI updates
   - Fallback: Cache partial results, show best-effort updates

2. **Permission Flow Complexity** (Risk: MEDIUM)
   - Mitigation: Implement state machine, comprehensive testing
   - Fallback: Provide clear error messages and Settings link

3. **Accessibility Compliance** (Risk: MEDIUM)
   - Mitigation: Early accessibility testing, follow WCAG AA guidelines
   - Fallback: Provide alternative interaction methods

### Medium-Risk Items

1. **Speech Recognition Service Availability** (Risk: MEDIUM)
   - Mitigation: Implement graceful degradation, fallback to manual entry
   - Fallback: Show helpful error message with manual entry option

2. **Haptic Feedback Performance** (Risk: LOW)
   - Mitigation: Implement haptic feedback efficiently, respect settings
   - Fallback: Disable haptics if performance impact detected

3. **State Management Complexity** (Risk: MEDIUM)
   - Mitigation: Use clear state machine, comprehensive testing
   - Fallback: Simplify state transitions if needed

## Timeline Estimate

**Total Duration**: 5 weeks (25 business days)

- **Phase 0 (Research)**: 3 days
- **Phase 1 (Design)**: 4 days
- **Phase 2A (Foundation)**: 3 days
- **Phase 2B (UI Components)**: 5 days
- **Phase 2C (Business Logic)**: 5 days
- **Phase 2D (Integration)**: 3 days
- **Phase 2E (Testing)**: 4 days
- **Phase 2F (Polish)**: 3 days

**Critical Path**: SpeechRecognitionService availability → Phase 2D integration

## Success Metrics

### Quantitative Metrics

- ✅ All 42 functional requirements implemented
- ✅ All 7 user stories have passing acceptance criteria
- ✅ All 12 success criteria measurable and achieved
- ✅ 80%+ code coverage for ViewModel and Services
- ✅ 60fps animation performance on iPhone 14+
- ✅ Recording starts within 500ms
- ✅ Transcription updates within 500ms
- ✅ 95% success rate in normal conditions

### Qualitative Metrics

- ✅ Accessibility audit passes (WCAG AA)
- ✅ VoiceOver users can complete flow independently
- ✅ Error messages are clear and actionable
- ✅ UI animations are smooth and responsive
- ✅ Permission flow is intuitive and non-intrusive

## Next Steps

1. **Immediate**: Confirm SpeechRecognitionService implementation status and API
2. **Phase 0**: Execute research tasks and resolve NEEDS CLARIFICATION items
3. **Phase 1**: Generate design artifacts (data-model.md, contracts, quickstart.md)
4. **Phase 1**: Run agent context update script
5. **Phase 2**: Begin implementation following phased approach
6. **Ongoing**: Update this plan as new information emerges

---

**Plan Status**: ✅ Ready for Phase 0 Research  
**Last Updated**: 2025-11-18  
**Next Review**: After Phase 0 research completion
