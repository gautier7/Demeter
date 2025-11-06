# Feature Specification: Core Services Infrastructure

**Feature Branch**: `003-core-services-infrastructure`  
**Created**: 2025-11-03  
**Status**: Draft  
**Input**: User description: "Implement SpeechRecognitionService: Voice input with AVAudioEngine and SFSpeechRecognizer, Implement LLMService: OpenAI GPT-4o integration with URLSession, Implement IngredientDatabaseService: Database queries and fuzzy matching, Set Up NetworkService: Base networking layer with monitoring, Implement SecurityService: API key management in Keychain"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Voice Input Capture and Transcription (Priority: P1)

As a user, I want to speak my food intake into the app so that I can quickly log meals without typing.

**Why this priority**: Voice input is the primary interaction method for the app and the foundation for all food logging functionality. Without this, users cannot use the core feature.

**Independent Test**: Can be fully tested by tapping the record button, speaking a food description, and verifying accurate transcription appears on screen within 2 seconds.

**Acceptance Scenarios**:

1. **Given** the app has microphone permission, **When** user taps the voice input button and speaks "I ate a chicken breast", **Then** the transcribed text "I ate a chicken breast" appears on screen
2. **Given** the user is recording, **When** they finish speaking and release the button, **Then** recording stops and the complete transcription is displayed
3. **Given** the app lacks microphone permission, **When** user attempts voice input, **Then** a permission request dialog appears with clear explanation

---

### User Story 2 - Intelligent Food Recognition and Nutritional Analysis (Priority: P1)

As a user, I want my spoken food description automatically analyzed for nutritional content so that I don't have to manually look up calories and macros.

**Why this priority**: This is the core value proposition - transforming natural language into structured nutritional data. Without this, the app is just a voice recorder.

**Independent Test**: Can be fully tested by providing a transcribed food description and verifying that accurate nutritional data (calories, protein, carbs, fat) is returned within 3 seconds.

**Acceptance Scenarios**:

1. **Given** a transcribed food description "grilled chicken breast 150g", **When** the LLM service processes it, **Then** structured nutritional data is returned with calories, protein, carbs, and fat values
2. **Given** a vague description "some chicken", **When** processed by LLM, **Then** reasonable estimates are provided with a confidence score below 0.8
3. **Given** the ingredient database contains "chicken breast", **When** LLM processes "chicken breast", **Then** the matched ingredient ID is included in the response

---

### User Story 3 - Ingredient Database Lookup and Matching (Priority: P2)

As a system, I need to quickly find matching ingredients from the local database so that nutritional analysis is accurate and consistent.

**Why this priority**: Provides the context needed for accurate LLM responses and enables offline functionality. Critical for data quality but can work with generic estimates initially.

**Independent Test**: Can be fully tested by querying for "chicken" and verifying that relevant ingredients (chicken breast, chicken thigh, etc.) are returned ranked by relevance within 100ms.

**Acceptance Scenarios**:

1. **Given** a search query "chicken", **When** the database service searches, **Then** all chicken-related ingredients are returned ranked by usage frequency
2. **Given** a misspelled query "chiken", **When** fuzzy matching is applied, **Then** "chicken" ingredients are still found and returned
3. **Given** a query for a non-existent ingredient, **When** the search completes, **Then** an empty result set is returned without errors

---

### User Story 4 - Reliable Network Communication (Priority: P2)

As a system, I need a robust networking layer to communicate with external APIs so that LLM requests succeed reliably even under poor network conditions.

**Why this priority**: Essential for LLM functionality but can be implemented with basic retry logic initially. Advanced features like request queuing can come later.

**Independent Test**: Can be fully tested by making an API request, simulating network failure, and verifying automatic retry with exponential backoff occurs.

**Acceptance Scenarios**:

1. **Given** a network request to OpenAI API, **When** the request is sent, **Then** it completes successfully within 3 seconds under normal conditions
2. **Given** a network request fails with timeout, **When** retry logic executes, **Then** up to 3 retry attempts are made with exponential backoff
3. **Given** the device is offline, **When** a network request is attempted, **Then** the user is notified and the request is queued for later

---

### User Story 5 - Secure API Key Management (Priority: P1)

As a system, I need to securely store and retrieve API keys so that sensitive credentials are never exposed or compromised.

**Why this priority**: Security is non-negotiable for production apps. API keys must be protected from the start to prevent unauthorized access and costs.

**Independent Test**: Can be fully tested by storing an API key in Keychain, retrieving it, and verifying it's never stored in UserDefaults or visible in logs.

**Acceptance Scenarios**:

1. **Given** an OpenAI API key, **When** it's stored via SecurityService, **Then** it's saved in Keychain with appropriate access controls
2. **Given** an API key stored in Keychain, **When** the app needs it for a request, **Then** it can be retrieved securely without exposing it in logs
3. **Given** the app is uninstalled, **When** reinstalled, **Then** the API key is no longer accessible (proper cleanup)

---

### Edge Cases

- What happens when the user speaks in a noisy environment and transcription is inaccurate?
- How does the system handle LLM API rate limiting or quota exhaustion?
- What happens when the ingredient database is empty or corrupted?
- How does the system handle network requests when switching between WiFi and cellular?
- What happens when Keychain access is denied or fails?
- How does the system handle extremely long voice inputs (>60 seconds)?
- What happens when the LLM returns malformed JSON or unexpected data?
- How does fuzzy matching perform with non-English food names or special characters?

## Requirements *(mandatory)*

### Functional Requirements

#### SpeechRecognitionService Requirements

- **FR-001**: System MUST request and handle microphone permissions with clear user-facing explanations
- **FR-002**: System MUST use [`AVAudioEngine`](https://developer.apple.com/documentation/avfaudio/avaudioengine) for audio capture with appropriate buffer configuration
- **FR-003**: System MUST use [`SFSpeechRecognizer`](https://developer.apple.com/documentation/speech/sfspeechrecognizer) for on-device speech-to-text conversion
- **FR-004**: System MUST provide real-time transcription updates as the user speaks
- **FR-005**: System MUST detect speech endpoints automatically and stop recording after 2 seconds of silence
- **FR-006**: System MUST handle speech recognition errors gracefully with user-friendly error messages
- **FR-007**: System MUST support English language recognition at minimum (locale: en-US)
- **FR-008**: System MUST provide haptic feedback when recording starts and stops

#### LLMService Requirements

- **FR-009**: System MUST integrate with OpenAI GPT-4o API using [`URLSession`](https://developer.apple.com/documentation/foundation/urlsession)
- **FR-010**: System MUST construct structured prompts that include ingredient database context
- **FR-011**: System MUST request JSON-formatted responses from the LLM with specific schema
- **FR-012**: System MUST parse LLM responses into structured nutritional data objects
- **FR-013**: System MUST include confidence scores for each parsed food item
- **FR-014**: System MUST handle LLM API errors (rate limits, timeouts, invalid responses)
- **FR-015**: System MUST cache LLM responses for identical inputs to reduce API costs
- **FR-016**: System MUST set appropriate timeout values (30 seconds for LLM requests)
- **FR-017**: System MUST use temperature setting of 0.3 for deterministic nutritional analysis

#### IngredientDatabaseService Requirements

- **FR-018**: System MUST query SwiftData for ingredients matching user input keywords
- **FR-019**: System MUST implement fuzzy string matching to handle typos and variations
- **FR-020**: System MUST rank search results by relevance (exact match > alias match > partial match)
- **FR-021**: System MUST consider ingredient usage frequency in ranking algorithm
- **FR-022**: System MUST return search results within 100ms for responsive user experience
- **FR-023**: System MUST support searching by ingredient name, aliases, and category
- **FR-024**: System MUST handle empty database gracefully without crashing
- **FR-025**: System MUST provide ingredient nutritional data per 100g as standard unit

#### NetworkService Requirements

- **FR-026**: System MUST provide a base networking layer for all HTTP/HTTPS requests
- **FR-027**: System MUST implement automatic retry logic with exponential backoff (3 attempts max)
- **FR-028**: System MUST monitor network connectivity status using [`NWPathMonitor`](https://developer.apple.com/documentation/network/nwpathmonitor)
- **FR-029**: System MUST queue requests when offline and process when connectivity returns
- **FR-030**: System MUST enforce TLS 1.3 for all network communications
- **FR-031**: System MUST implement request/response logging for debugging (excluding sensitive data)
- **FR-032**: System MUST handle HTTP status codes appropriately (200, 401, 429, 500, etc.)
- **FR-033**: System MUST compress request payloads when size exceeds 1KB
- **FR-034**: System MUST provide network performance metrics (latency, success rate)

#### SecurityService Requirements

- **FR-035**: System MUST store API keys in iOS Keychain, never in UserDefaults or files
- **FR-036**: System MUST use [`kSecAttrAccessibleWhenUnlockedThisDeviceOnly`](https://developer.apple.com/documentation/security/ksecattraccessiblewhenunlockedthisdeviceonly) for Keychain items
- **FR-037**: System MUST provide methods to securely store, retrieve, and delete API keys
- **FR-038**: System MUST never log or expose API keys in console output or crash reports
- **FR-039**: System MUST validate API key format before storage
- **FR-040**: System MUST handle Keychain access errors gracefully
- **FR-041**: System MUST support key rotation by allowing updates to stored keys
- **FR-042**: System MUST clean up Keychain items when no longer needed

### Key Entities *(include if feature involves data)*

- **TranscriptionResult**: Represents the output of speech recognition. Key attributes: transcribedText, confidence, duration, locale
- **NutritionData**: Represents parsed nutritional information from LLM. Key attributes: foodItems (array), totalCalories, totalProtein, totalCarbs, totalFat, confidence
- **FoodItem**: Individual food component within NutritionData. Key attributes: name, quantity, unit, calories, protein, carbs, fat, matchedIngredientId, confidence
- **IngredientSearchResult**: Result from database query. Key attributes: ingredient (reference), relevanceScore, matchType (exact/alias/partial)
- **NetworkRequest**: Encapsulates HTTP request details. Key attributes: url, method, headers, body, timeout
- **NetworkResponse**: Encapsulates HTTP response. Key attributes: statusCode, data, headers, metrics (latency, size)
- **APICredential**: Secure credential storage. Key attributes: service (identifier), key (encrypted), createdAt, lastUsed

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can successfully record and transcribe voice input with 95% accuracy for clear speech in quiet environments
- **SC-002**: Voice transcription completes within 2 seconds of user finishing speech
- **SC-003**: LLM successfully parses 90% of common food descriptions into accurate nutritional data
- **SC-004**: LLM API requests complete within 3 seconds under normal network conditions
- **SC-005**: Ingredient database searches return relevant results within 100ms for 99% of queries
- **SC-006**: Fuzzy matching successfully finds ingredients despite common typos (1-2 character errors)
- **SC-007**: Network requests automatically retry and succeed after transient failures in 80% of cases
- **SC-008**: System handles offline scenarios gracefully, queuing requests for later processing
- **SC-009**: API keys remain secure with zero exposure in logs, crash reports, or backups
- **SC-010**: All five services integrate seamlessly with zero crashes during normal operation
- **SC-011**: Voice-to-nutrition pipeline (speech → LLM → data) completes end-to-end in under 5 seconds
- **SC-012**: System maintains 99.9% uptime for core service functionality during active use

## Assumptions

- Users will primarily use the app in relatively quiet environments suitable for voice input
- OpenAI API will maintain 99.9% uptime and reasonable response times (<3s)
- The initial ingredient database will contain 50-100 common food items
- Users will have iOS 18.0+ devices with Speech framework support
- Network connectivity will be available for LLM requests (offline mode is post-MVP)
- API keys will be provided through secure configuration, not hardcoded
- English language support is sufficient for MVP (internationalization is post-MVP)

## Dependencies

- iOS 18.0+ with Speech framework
- AVFoundation framework for audio capture
- SwiftData for ingredient database persistence
- OpenAI GPT-4o API access and valid API key
- Network connectivity for LLM requests
- Microphone hardware and permissions
- Keychain Services for secure storage

## Out of Scope (Post-MVP)

- Multi-language speech recognition
- Offline LLM processing
- Photo-based food recognition
- Barcode scanning
- Advanced audio processing (noise cancellation, voice enhancement)
- Custom wake word detection
- Voice command navigation
- Batch processing of multiple food items
- Real-time nutritional coaching
- Integration with third-party nutrition APIs beyond OpenAI
