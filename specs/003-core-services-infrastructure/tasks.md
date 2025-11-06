# Implementation Tasks: Core Services Infrastructure

**Feature**: 003-core-services-infrastructure
**Branch**: `003-core-services-infrastructure`
**Date**: 2025-11-03
**Spec**: [specs/003-core-services-infrastructure/spec.md](specs/003-core-services-infrastructure/spec.md)
**Plan**: [specs/003-core-services-infrastructure/plan.md](specs/003-core-services-infrastructure/plan.md)

## Overview

This document defines the concrete implementation tasks for the Core Services Infrastructure feature. Tasks are organized by priority and dependency, with clear acceptance criteria and testing requirements. These five services form the foundation for voice-activated food logging with LLM-powered nutritional analysis.

## Task Organization

### Priority Levels
- **P1**: Core functionality, blocking dependencies (SecurityService, NetworkService, SpeechRecognitionService)
- **P2**: Supporting features, parallel development possible (LLMService, IngredientDatabaseService)
- **P3**: Integration and advanced features, can be deferred

### Dependencies
- Tasks are numbered sequentially within priority levels
- Higher priority tasks must be completed before lower priority ones
- Parallel tasks within the same priority level can be developed simultaneously

---

## P1 Tasks: Foundation Services

### Task P1-1: Implement SecurityService (Keychain Management)
**Priority**: P1
**Estimated Effort**: 3-4 hours
**Dependencies**: None
**Assignee**: iOS Developer (Security Focus)

**Description**:
Implement the SecurityService for secure API key storage in Keychain. This is the foundation for all external API communication and must be completed first.

**Acceptance Criteria**:
- [ ] SecurityService class compiles without errors
- [ ] API key storage in Keychain works correctly
- [ ] API key retrieval from Keychain works correctly
- [ ] API key deletion from Keychain works correctly
- [ ] Keychain access errors handled gracefully
- [ ] API keys never logged or exposed in console
- [ ] Unit tests pass with 100% coverage
- [ ] No API keys stored in UserDefaults or files

**Implementation Steps**:
1. Create `Demeter/Services/Security/SecurityService.swift`
2. Implement Keychain storage with [`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`](https://developer.apple.com/documentation/security/ksecattraccessiblewhenunlockedthisdeviceonly)
3. Implement secure retrieval methods
4. Implement key deletion and rotation
5. Add comprehensive error handling
6. Create unit tests with 100% coverage

**Files to Create/Modify**:
- `Demeter/Services/Security/SecurityService.swift` (new)
- `Demeter/Services/Security/APIKeyManager.swift` (new)
- `Demeter/Tests/Services/SecurityServiceTests.swift` (new)

**Testing Requirements**:
- Test successful key storage and retrieval
- Test key deletion
- Test Keychain access denial scenarios
- Test key format validation
- Test concurrent access safety

---

### Task P1-2: Implement NetworkService (Base Networking Layer)
**Priority**: P1
**Estimated Effort**: 4-5 hours
**Dependencies**: P1-1
**Assignee**: iOS Developer (Networking Focus)

**Description**:
Implement the NetworkService as the base networking layer for all HTTP/HTTPS requests. This service provides retry logic, connectivity monitoring, and request/response handling.

**Acceptance Criteria**:
- [ ] NetworkService class compiles without errors
- [ ] HTTP requests work with proper headers and authentication
- [ ] Automatic retry logic with exponential backoff implemented (3 attempts max)
- [ ] Network connectivity monitoring via [`NWPathMonitor`](https://developer.apple.com/documentation/network/nwpathmonitor) works
- [ ] Offline request queuing implemented
- [ ] TLS 1.3 enforcement verified
- [ ] Request/response logging implemented (no sensitive data)
- [ ] HTTP status code handling correct (200, 401, 429, 500, etc.)
- [ ] Unit tests pass with >80% coverage
- [ ] Integration tests pass for retry scenarios

**Implementation Steps**:
1. Create `Demeter/Services/Network/NetworkService.swift`
2. Implement base HTTP request/response handling
3. Implement retry logic with exponential backoff
4. Create `Demeter/Services/Network/NetworkMonitor.swift` with [`NWPathMonitor`](https://developer.apple.com/documentation/network/nwpathmonitor)
5. Implement offline queue management
6. Add request/response logging
7. Create comprehensive unit and integration tests

**Files to Create/Modify**:
- `Demeter/Services/Network/NetworkService.swift` (new)
- `Demeter/Services/Network/NetworkMonitor.swift` (new)
- `Demeter/Services/Network/RequestBuilder.swift` (new)
- `Demeter/Services/Network/ResponseHandler.swift` (new)
- `Demeter/Tests/Services/NetworkServiceTests.swift` (new)

**Testing Requirements**:
- Test successful requests
- Test retry logic on transient failures
- Test network connectivity detection
- Test offline queue management
- Test HTTP status code handling
- Test request/response logging (verify no sensitive data)

---

### Task P1-3: Implement SpeechRecognitionService (Voice Input)
**Priority**: P1
**Estimated Effort**: 4-5 hours
**Dependencies**: None (parallel with P1-1, P1-2)
**Assignee**: iOS Developer (Audio/Speech Focus)

**Description**:
Implement the SpeechRecognitionService for voice input capture and transcription using [`AVAudioEngine`](https://developer.apple.com/documentation/avfaudio/avaudioengine) and [`SFSpeechRecognizer`](https://developer.apple.com/documentation/speech/sfspeechrecognizer).

**Acceptance Criteria**:
- [ ] SpeechRecognitionService class compiles without errors
- [ ] Microphone permission request works correctly
- [ ] Audio capture via [`AVAudioEngine`](https://developer.apple.com/documentation/avfaudio/avaudioengine) works
- [ ] Speech recognition via [`SFSpeechRecognizer`](https://developer.apple.com/documentation/speech/sfspeechrecognizer) works
- [ ] Real-time transcription updates provided
- [ ] Automatic endpoint detection (2 seconds silence) works
- [ ] Haptic feedback on recording start/stop works
- [ ] Error handling for speech recognition failures
- [ ] Unit tests pass with >80% coverage
- [ ] Integration tests pass with mock audio

**Implementation Steps**:
1. Create `Demeter/Services/Speech/SpeechRecognitionService.swift`
2. Create `Demeter/Services/Speech/AudioEngineManager.swift` for [`AVAudioEngine`](https://developer.apple.com/documentation/avfaudio/avaudioengine) management
3. Create `Demeter/Services/Speech/SpeechPermissionManager.swift` for permission handling
4. Implement audio capture and buffering
5. Implement speech recognition with real-time updates
6. Add endpoint detection logic
7. Integrate haptic feedback
8. Create comprehensive tests

**Files to Create/Modify**:
- `Demeter/Services/Speech/SpeechRecognitionService.swift` (new)
- `Demeter/Services/Speech/AudioEngineManager.swift` (new)
- `Demeter/Services/Speech/SpeechPermissionManager.swift` (new)
- `Demeter/Tests/Services/SpeechRecognitionServiceTests.swift` (new)
- `Demeter/Tests/Fixtures/MockAudioFiles/` (test audio files)

**Testing Requirements**:
- Test permission request flow
- Test audio capture and buffering
- Test speech recognition with mock audio
- Test real-time transcription updates
- Test endpoint detection
- Test error scenarios (permission denied, recognition failure)

---

## P2 Tasks: Intelligence & Data Services

### Task P2-1: Implement LLMService (OpenAI Integration)
**Priority**: P2
**Estimated Effort**: 5-6 hours
**Dependencies**: P1-1, P1-2
**Assignee**: iOS Developer (API Integration Focus)

**Description**:
Implement the LLMService for OpenAI GPT-4o integration. This service handles prompt construction, API communication, response parsing, and caching.

**Acceptance Criteria**:
- [ ] LLMService class compiles without errors
- [ ] OpenAI API requests work correctly via [`URLSession`](https://developer.apple.com/documentation/foundation/urlsession)
- [ ] System prompt construction with ingredient context works
- [ ] JSON response parsing works correctly
- [ ] Confidence scoring implemented
- [ ] Response caching implemented (24-hour TTL)
- [ ] Error handling for API failures (rate limits, timeouts, invalid responses)
- [ ] Request timeout set to 30 seconds
- [ ] Temperature set to 0.3 for deterministic responses
- [ ] Unit tests pass with >80% coverage
- [ ] Integration tests pass with mock API responses

**Implementation Steps**:
1. Create `Demeter/Services/LLM/LLMService.swift`
2. Create `Demeter/Services/LLM/LLMContextBuilder.swift` for prompt construction
3. Create `Demeter/Services/LLM/LLMResponseParser.swift` for JSON parsing
4. Create `Demeter/Services/LLM/LLMRequestBuilder.swift` for request construction
5. Implement OpenAI API communication via [`URLSession`](https://developer.apple.com/documentation/foundation/urlsession)
6. Implement response caching with TTL
7. Add comprehensive error handling
8. Create unit and integration tests

**Files to Create/Modify**:
- `Demeter/Services/LLM/LLMService.swift` (new)
- `Demeter/Services/LLM/LLMContextBuilder.swift` (new)
- `Demeter/Services/LLM/LLMResponseParser.swift` (new)
- `Demeter/Services/LLM/LLMRequestBuilder.swift` (new)
- `Demeter/Data/Models/DTOs/OpenAIRequest.swift` (new)
- `Demeter/Data/Models/DTOs/OpenAIResponse.swift` (new)
- `Demeter/Tests/Services/LLMServiceTests.swift` (new)
- `Demeter/Tests/Fixtures/MockResponses/` (test JSON responses)

**Testing Requirements**:
- Test successful API requests
- Test prompt construction with ingredient context
- Test JSON response parsing
- Test confidence scoring
- Test response caching
- Test error handling (rate limits, timeouts, invalid JSON)
- Test request timeout behavior

---

### Task P2-2: Implement IngredientDatabaseService (Database Queries & Fuzzy Matching)
**Priority**: P2
**Estimated Effort**: 4-5 hours
**Dependencies**: P1-1 (for ingredient model from feature 001)
**Assignee**: iOS Developer (Database/Search Focus)

**Description**:
Implement the IngredientDatabaseService for querying the local ingredient database and performing fuzzy matching for typo tolerance.

**Acceptance Criteria**:
- [ ] IngredientDatabaseService class compiles without errors
- [ ] SwiftData queries work correctly
- [ ] Fuzzy string matching algorithm implemented
- [ ] Search results ranked by relevance
- [ ] Usage frequency considered in ranking
- [ ] Query performance <100ms for typical searches
- [ ] Empty database handled gracefully
- [ ] Ingredient nutritional data per 100g standard
- [ ] Unit tests pass with >80% coverage
- [ ] Performance tests verify <100ms latency

**Implementation Steps**:
1. Create `Demeter/Services/Database/IngredientDatabaseService.swift`
2. Create `Demeter/Services/Database/IngredientMatcher.swift` for fuzzy matching
3. Implement SwiftData query methods
4. Implement fuzzy string matching algorithm
5. Implement relevance ranking logic
6. Add performance optimization (indexing, caching)
7. Create comprehensive tests

**Files to Create/Modify**:
- `Demeter/Services/Database/IngredientDatabaseService.swift` (new)
- `Demeter/Services/Database/IngredientMatcher.swift` (new)
- `Demeter/Tests/Services/IngredientDatabaseServiceTests.swift` (new)

**Testing Requirements**:
- Test exact match searches
- Test fuzzy matching with typos
- Test relevance ranking
- Test usage frequency consideration
- Test performance (<100ms)
- Test empty database scenarios
- Test large dataset performance

---

### Task P2-3: Implement DatabaseSeeder (Initial Ingredient Data)
**Priority**: P2
**Estimated Effort**: 3-4 hours
**Dependencies**: P2-2
**Assignee**: iOS Developer (Data Management Focus)

**Description**:
Implement the DatabaseSeeder to populate the ingredient database with 50-100 common food items on first app launch.

**Acceptance Criteria**:
- [ ] DatabaseSeeder class compiles without errors
- [ ] 50+ common ingredients seeded successfully
- [ ] Nutritional data accurate and complete
- [ ] Categories properly assigned
- [ ] Duplicate prevention implemented
- [ ] Seeding only occurs on first launch
- [ ] Seeding completes within 5 seconds
- [ ] Unit tests pass
- [ ] Seed data JSON file created

**Implementation Steps**:
1. Create `Demeter/Services/Database/DatabaseSeeder.swift`
2. Create `Resources/Data/InitialIngredients.json` with 50+ ingredients
3. Implement seeding logic with duplicate prevention
4. Implement first-launch detection
5. Add error handling
6. Create unit tests

**Files to Create/Modify**:
- `Demeter/Services/Database/DatabaseSeeder.swift` (new)
- `Resources/Data/InitialIngredients.json` (new)
- `Demeter/Tests/Services/DatabaseSeederTests.swift` (new)

**Testing Requirements**:
- Test successful seeding
- Test duplicate prevention
- Test first-launch detection
- Test error handling
- Test seeding performance

---

## P3 Tasks: Integration & Advanced Features

### Task P3-1: Implement Response Caching Service
**Priority**: P3
**Estimated Effort**: 2-3 hours
**Dependencies**: P2-1
**Assignee**: iOS Developer

**Description**:
Implement a comprehensive caching service for LLM responses and ingredient queries to reduce API costs and improve performance.

**Acceptance Criteria**:
- [ ] ResponseCache class compiles without errors
- [ ] LLM response caching works with 24-hour TTL
- [ ] Ingredient cache works with 1-hour TTL
- [ ] LRU eviction policy implemented
- [ ] Cache size limits enforced
- [ ] Unit tests pass with >80% coverage

**Implementation Steps**:
1. Create `Demeter/Services/Cache/ResponseCache.swift`
2. Create `Demeter/Services/Cache/IngredientCache.swift`
3. Create `Demeter/Services/Cache/CacheManager.swift`
4. Implement TTL and eviction logic
5. Add unit tests

**Files to Create/Modify**:
- `Demeter/Services/Cache/ResponseCache.swift` (new)
- `Demeter/Services/Cache/IngredientCache.swift` (new)
- `Demeter/Services/Cache/CacheManager.swift` (new)
- `Demeter/Tests/Services/CacheServiceTests.swift` (new)

---

### Task P3-2: Implement Certificate Pinning
**Priority**: P3
**Estimated Effort**: 2-3 hours
**Dependencies**: P1-2
**Assignee**: iOS Developer (Security Focus)

**Description**:
Implement certificate pinning for OpenAI API to prevent man-in-the-middle attacks.

**Acceptance Criteria**:
- [ ] CertificatePinner class compiles without errors
- [ ] Certificate pinning for OpenAI API implemented
- [ ] Pinned certificates validated on each request
- [ ] Fallback behavior on pin failure
- [ ] Unit tests pass

**Implementation Steps**:
1. Create `Demeter/Services/Security/CertificatePinner.swift`
2. Implement certificate pinning logic
3. Add fallback behavior
4. Create unit tests

**Files to Create/Modify**:
- `Demeter/Services/Security/CertificatePinner.swift` (new)
- `Demeter/Tests/Services/CertificatePinnerTests.swift` (new)

---

### Task P3-3: Implement Analytics & Monitoring
**Priority**: P3
**Estimated Effort**: 3-4 hours
**Dependencies**: P1-2, P2-1
**Assignee**: iOS Developer

**Description**:
Implement performance monitoring and analytics for tracking service health and user experience metrics.

**Acceptance Criteria**:
- [ ] PerformanceMonitor class compiles without errors
- [ ] Service latency tracking implemented
- [ ] Error rate tracking implemented
- [ ] API cost tracking implemented
- [ ] Unit tests pass

**Implementation Steps**:
1. Create `Demeter/Services/Analytics/PerformanceMonitor.swift`
2. Create `Demeter/Services/Analytics/EventLogger.swift`
3. Implement metrics collection
4. Add unit tests

**Files to Create/Modify**:
- `Demeter/Services/Analytics/PerformanceMonitor.swift` (new)
- `Demeter/Services/Analytics/EventLogger.swift` (new)
- `Demeter/Tests/Services/AnalyticsTests.swift` (new)

---

## Testing Strategy

### Unit Testing Requirements
- **Coverage**: Minimum 80% for all services
- **Critical Paths**: 100% coverage for security, error handling, and retry logic
- **Performance**: All tests complete within 30 seconds

### Integration Testing Requirements
- **Service Integration**: Test services working together (Speech → LLM → Database)
- **API Integration**: Test with mock OpenAI API responses
- **Network Resilience**: Test retry logic and offline scenarios
- **Performance**: Verify latency requirements met

### Test Files to Create
- `Demeter/Tests/Services/SecurityServiceTests.swift`
- `Demeter/Tests/Services/NetworkServiceTests.swift`
- `Demeter/Tests/Services/SpeechRecognitionServiceTests.swift`
- `Demeter/Tests/Services/LLMServiceTests.swift`
- `Demeter/Tests/Services/IngredientDatabaseServiceTests.swift`
- `Demeter/Tests/Services/DatabaseSeederTests.swift`
- `Demeter/Tests/Services/CacheServiceTests.swift`
- `Demeter/Tests/Mocks/MockSpeechRecognitionService.swift`
- `Demeter/Tests/Mocks/MockLLMService.swift`
- `Demeter/Tests/Mocks/MockNetworkService.swift`
- `Demeter/Tests/Mocks/MockSecurityService.swift`

---

## Success Criteria Verification

### Measurable Outcomes (from spec.md)
- [ ] **SC-001**: Users can successfully record and transcribe voice input with 95% accuracy
- [ ] **SC-002**: Voice transcription completes within 2 seconds
- [ ] **SC-003**: LLM successfully parses 90% of common food descriptions
- [ ] **SC-004**: LLM API requests complete within 3 seconds
- [ ] **SC-005**: Ingredient database searches return results within 100ms
- [ ] **SC-006**: Fuzzy matching successfully finds ingredients despite typos
- [ ] **SC-007**: Network requests automatically retry and succeed in 80% of cases
- [ ] **SC-008**: System handles offline scenarios gracefully
- [ ] **SC-009**: API keys remain secure with zero exposure
- [ ] **SC-010**: All five services integrate seamlessly with zero crashes
- [ ] **SC-011**: Voice-to-nutrition pipeline completes end-to-end in under 5 seconds
- [ ] **SC-012**: System maintains 99.9% uptime during active use

### Performance Benchmarks
- Voice transcription latency: < 2 seconds
- LLM response latency: < 3 seconds
- Database query latency: < 100ms
- Network request latency: < 5 seconds (with retries)
- Service initialization: < 500ms

---

## Risk Mitigation

### Technical Risks
- **OpenAI API Outages**: Implement fallback to generic nutritional estimates
- **Speech Recognition Accuracy**: Provide manual entry fallback
- **Network Failures**: Implement comprehensive retry logic and offline queuing
- **Keychain Access Issues**: Provide clear error messages and recovery options

### Timeline Risks
- **Dependency Management**: Complete P1 tasks before starting P2
- **Testing Overhead**: Allocate sufficient time for comprehensive testing
- **Integration Issues**: Test early and often with dependent features

---

## Definition of Done

A task is complete when:
- [ ] Code compiles without warnings or errors
- [ ] Unit tests pass with >80% coverage (100% for security/critical paths)
- [ ] Integration tests pass
- [ ] Code review completed and approved
- [ ] Documentation updated
- [ ] Acceptance criteria met
- [ ] Performance requirements satisfied
- [ ] No API keys or sensitive data in logs

## Next Steps

After completing all P1 tasks:
1. Run integration tests to verify services work together
2. Begin P2 service implementation
3. Update dependent features (ViewModels, UI components) to use services
4. Consider P3 tasks based on timeline and priorities

## Dependencies on Other Features

- **SwiftData Models (001)**: Uses Ingredient model for context injection
- **App Infrastructure (002)**: Integrates with app lifecycle and configuration
- **Voice Input Views**: Will use SpeechRecognitionService
- **LLM Processing Views**: Will use LLMService
- **Background Tasks**: Will use NetworkService for offline queuing

---

*This tasks document is generated from the implementation plan and feature specification. Updates should be made through the /speckit.tasks command.*