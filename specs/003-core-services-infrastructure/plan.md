# Implementation Plan: Core Services Infrastructure

**Branch**: `003-core-services-infrastructure` | **Date**: 2025-11-03 | **Spec**: [specs/003-core-services-infrastructure/spec.md](specs/003-core-services-infrastructure/spec.md)
**Input**: Feature specification from `/specs/003-core-services-infrastructure/spec.md`

**Note**: This plan is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Implement five core service infrastructure components (SpeechRecognitionService, LLMService, IngredientDatabaseService, NetworkService, SecurityService) that form the foundation for voice-activated food logging with LLM-powered nutritional analysis. These services integrate Speech Framework, OpenAI GPT-4o API, SwiftData queries, URLSession networking, and Keychain security as specified in the technical constitution.

## Technical Context

**Language/Version**: Swift 5.9 (iOS 18.0+)  
**Primary Dependencies**: Speech, AVFoundation, Foundation (URLSession), SwiftData, Security (Keychain), Network (NWPathMonitor)  
**External APIs**: OpenAI GPT-4o API (REST via URLSession)  
**Storage**: SwiftData for ingredient database, Keychain for API keys  
**Testing**: XCTest with SwiftTesting framework, mock services for API testing  
**Target Platform**: iOS 18.0+  
**Project Type**: Mobile iOS application  
**Performance Goals**: Voice transcription <2s, LLM response <3s, database queries <100ms, network retry with exponential backoff  
**Constraints**: On-device speech recognition, secure API key storage, offline-capable ingredient database, TLS 1.3 enforcement  
**Scale/Scope**: MVP with 50-100 ingredients, support for concurrent voice input and LLM requests, network monitoring and retry logic

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

✅ **Voice-First Interaction Model**: SpeechRecognitionService implements single-tap voice activation with real-time transcription and haptic feedback as required in constitution section I.1

✅ **LLM-Augmented Intelligence**: LLMService integrates OpenAI GPT-4o with structured prompts and ingredient database context injection as specified in constitution section I.2

✅ **Data Sovereignty & Privacy**: SecurityService manages API keys in Keychain with zero exposure; IngredientDatabaseService uses local SwiftData; no external data sharing

✅ **Speech Framework Integration**: SpeechRecognitionService uses [`AVAudioEngine`](https://developer.apple.com/documentation/avfaudio/avaudioengine) and [`SFSpeechRecognizer`](https://developer.apple.com/documentation/speech/sfspeechrecognizer) as specified in constitution section III.2

✅ **LLM Integration (OpenAI API)**: LLMService uses [`URLSession`](https://developer.apple.com/documentation/foundation/urlsession) for direct REST API integration as specified in constitution section III.3

✅ **Network Monitoring**: NetworkService uses [`NWPathMonitor`](https://developer.apple.com/documentation/network/nwpathmonitor) for connectivity monitoring as specified in constitution section IV.5

✅ **Security Architecture**: SecurityService implements Keychain storage with [`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`](https://developer.apple.com/documentation/security/ksecattraccessiblewhenunlockedthisdeviceonly) as specified in constitution section VI.1

✅ **iOS 18 Compatibility**: All frameworks (Speech, AVFoundation, SwiftData, Network) are iOS 18.0+ compatible

✅ **MVVM Pattern**: Services are designed as injectable dependencies for ViewModels, supporting MVVM architecture

**Post-Design Re-evaluation**: Design artifacts will establish service contracts, API specifications, error handling strategies, and integration points. All services implement required functionality as specified in constitution. No constitution violations anticipated.

**Gates Passed**: Implementation ready for Phase 0 research.

## Project Structure

### Documentation (this feature)

```text
specs/003-core-services-infrastructure/
├── plan.md                  # This file (/speckit.plan command output)
├── research.md              # Phase 0 output (/speckit.plan command)
├── service-architecture.md  # Phase 1 output (/speckit.plan command)
├── api-contracts.md         # Phase 1 output (/speckit.plan command)
├── integration-guide.md     # Phase 1 output (/speckit.plan command)
├── checklists/
│   └── requirements.md      # Specification quality validation
└── tasks.md                 # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
Demeter/
├── Services/
│   ├── Speech/
│   │   ├── SpeechRecognitionService.swift
│   │   ├── AudioEngineManager.swift
│   │   └── SpeechPermissionManager.swift
│   ├── LLM/
│   │   ├── LLMService.swift
│   │   ├── LLMContextBuilder.swift
│   │   ├── LLMResponseParser.swift
│   │   └── LLMRequestBuilder.swift
│   ├── Database/
│   │   ├── IngredientDatabaseService.swift
│   │   ├── DatabaseSeeder.swift
│   │   └── IngredientMatcher.swift
│   ├── Network/
│   │   ├── NetworkService.swift
│   │   ├── NetworkMonitor.swift
│   │   ├── RequestBuilder.swift
│   │   └── ResponseHandler.swift
│   └── Security/
│       ├── SecurityService.swift
│       ├── APIKeyManager.swift
│       └── CertificatePinner.swift
├── Data/
│   ├── Models/
│   │   ├── DTOs/
│   │   │   ├── OpenAIRequest.swift
│   │   │   └── OpenAIResponse.swift
│   │   └── Enums/
│   │       └── ErrorType.swift
│   └── DataSources/
│       └── RemoteDataSource.swift
└── Tests/
    ├── Services/
    │   ├── SpeechRecognitionServiceTests.swift
    │   ├── LLMServiceTests.swift
    │   ├── IngredientDatabaseServiceTests.swift
    │   ├── NetworkServiceTests.swift
    │   └── SecurityServiceTests.swift
    ├── Mocks/
    │   ├── MockSpeechRecognitionService.swift
    │   ├── MockLLMService.swift
    │   ├── MockNetworkService.swift
    │   └── MockSecurityService.swift
    └── Fixtures/
        ├── MockResponses/
        │   ├── openai_success_response.json
        │   └── openai_error_response.json
        └── TestData/
            └── test_ingredients.json
```

**Structure Decision**: Service-oriented architecture with clear separation of concerns. Each service (Speech, LLM, Database, Network, Security) is independently testable and injectable. DTOs for API communication, comprehensive mocks for testing, and fixtures for test data. Follows MVVM pattern with services as dependencies.

## Implementation Phases

### Phase 0: Research & Design (Week 1)
- Analyze Speech Framework capabilities and limitations
- Research OpenAI GPT-4o API specifications and pricing
- Design error handling and retry strategies
- Define service interfaces and contracts
- Plan integration points with existing data layer

### Phase 1: Core Service Implementation (Weeks 2-3)
- Implement SecurityService (Keychain management) - foundation for API key storage
- Implement NetworkService (base networking layer) - foundation for all API calls
- Implement SpeechRecognitionService (voice input) - primary user interaction
- Implement LLMService (OpenAI integration) - core intelligence layer
- Implement IngredientDatabaseService (local queries) - context for LLM

### Phase 2: Integration & Testing (Week 4)
- Integrate services with existing ViewModels
- Implement comprehensive unit tests (70% coverage minimum)
- Implement integration tests for critical flows
- Performance testing and optimization
- Error handling and edge case testing

### Phase 3: Polish & Documentation (Week 5)
- Add logging and monitoring
- Performance profiling and optimization
- Documentation and API contracts
- Code review and refactoring
- Prepare for beta testing

## Complexity Tracking

### Technical Complexity: HIGH

**Justification**:
1. **Multiple Framework Integration**: Requires expertise in Speech, AVFoundation, URLSession, SwiftData, Security, and Network frameworks
2. **Asynchronous Operations**: Heavy use of async/await for voice processing, API calls, and database queries
3. **Error Handling**: Complex error scenarios across network, API, and local operations
4. **Security Requirements**: Keychain management, API key protection, TLS enforcement
5. **Performance Constraints**: Sub-second response times for voice and database operations
6. **External API Integration**: OpenAI API with rate limiting, retry logic, and cost management

### Risk Assessment

**High Risk**:
- OpenAI API rate limiting or service outages affecting user experience
- Speech recognition accuracy in noisy environments
- Network connectivity issues during critical operations

**Medium Risk**:
- Keychain access failures or permission issues
- LLM response parsing failures with unexpected JSON formats
- Database query performance with large ingredient datasets

**Mitigation Strategies**:
- Implement comprehensive retry logic with exponential backoff
- Cache LLM responses to reduce API calls
- Provide fallback to generic nutritional estimates
- Implement offline mode with local ingredient database
- Extensive error handling and user-friendly error messages

## Dependencies & Prerequisites

### External Dependencies
- OpenAI API account with GPT-4o access
- Valid API key for authentication
- Network connectivity for LLM requests

### Internal Dependencies
- SwiftData models (FoodEntry, DailyTotal, Ingredient) from feature 001
- App infrastructure setup from feature 002
- ViewModels that will consume these services

### Framework Requirements
- iOS 18.0+ (Speech, AVFoundation, SwiftData, Network frameworks)
- Swift 5.9+
- Xcode 15.0+

## Success Metrics

- All 42 functional requirements implemented and tested
- 80%+ code coverage for all services
- Voice transcription latency <2 seconds
- LLM response latency <3 seconds
- Database query latency <100ms
- Network retry success rate >80%
- Zero API key exposure in logs or crash reports
- All edge cases handled gracefully

## Next Steps

1. **Phase 0 Research**: Create `research.md` with detailed analysis of each framework and API
2. **Phase 1 Design**: Create `service-architecture.md` with detailed service designs and contracts
3. **Phase 1 Design**: Create `api-contracts.md` with API specifications and error handling
4. **Phase 1 Design**: Create `integration-guide.md` with integration patterns and examples
5. **Phase 2 Tasks**: Use `/speckit.tasks` to generate detailed implementation tasks