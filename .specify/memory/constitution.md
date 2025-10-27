# Demeter iOS Calorie Tracking Application - Technical Constitution

## Executive Summary

Demeter is an iOS 18+ voice-activated daily calorie tracking application that leverages LLM technology for intelligent food recognition and nutritional analysis. Users tap a button, describe consumed food verbally, and receive automated nutritional breakdowns with real-time daily total updates.

**Core Technology Stack**: SwiftUI, Speech Framework, OpenAI GPT-4o, SwiftData, HealthKit
**Target Platform**: iOS 18.0+
**Development Approach**: MVP-first with iterative enhancement
**Architecture Pattern**: MVVM with Repository pattern for data abstraction

---

## I. Core Architectural Principles

### 1. Voice-First Interaction Model

**Principle**: Voice input is the primary interaction method; all UI design decisions prioritize seamless voice capture and feedback.

**Implementation Requirements**:
- Single-tap voice activation with clear visual feedback
- Continuous listening mode with automatic endpoint detection
- Real-time transcription display for user confidence
- Graceful fallback to manual text entry when voice unavailable
- Haptic feedback for interaction confirmation

**Rationale**: Reduces friction in food logging, enabling hands-free operation during meals.

### 2. LLM-Augmented Intelligence

**Principle**: OpenAI GPT-4o serves as the intelligent parsing layer, transforming natural language food descriptions into structured nutritional data.

**Implementation Requirements**:
- Structured prompt engineering with JSON response format
- Custom ingredient database context injection via system prompts
- Confidence scoring for nutritional estimates
- Fallback to generic nutritional databases when custom data unavailable
- Response caching for repeated food items

**Rationale**: Enables natural language input while maintaining nutritional accuracy through custom database augmentation.

### 3. Data Sovereignty & Privacy

**Principle**: User nutritional data remains under user control with transparent data handling and minimal external dependencies.

**Implementation Requirements**:
- SwiftData for local-first persistence
- Optional iCloud sync via CloudKit (user-controlled)
- Voice data processed transiently, never stored
- Privacy manifest declaring all data collection
- HealthKit integration opt-in with explicit permissions

**Rationale**: Builds user trust and complies with App Store privacy requirements while enabling cross-device sync.

### 4. Midnight Reset Architecture

**Principle**: Daily nutritional totals automatically reset at midnight local time with complete historical archival.

**Implementation Requirements**:
- Background task scheduling via [`BGTaskScheduler`](https://developer.apple.com/documentation/backgroundtasks/bgtaskscheduler)
- Atomic transaction for daily rollover
- Calendar view with lazy loading for historical data
- Timezone-aware calculations for travelers
- Notification option for daily summary before reset

**Rationale**: Aligns with natural daily eating patterns while preserving long-term tracking data.

### 5. MVP-First Development

**Principle**: Deliver core functionality rapidly, then iterate based on user feedback.

**MVP Scope**:
- Voice input → LLM processing → nutritional display → daily totals
- Basic custom ingredient database (50-100 common items)
- 30-day historical calendar view
- Manual entry fallback

**Post-MVP Features**:
- Photo-based food recognition
- Meal planning and suggestions
- Social sharing and challenges
- Advanced analytics and trends
- Barcode scanning

**Rationale**: Validates core value proposition quickly while maintaining architectural flexibility for future enhancements.

---

## II. Technical Architecture

### System Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        iOS Application                       │
├─────────────────────────────────────────────────────────────┤
│  Presentation Layer (SwiftUI)                               │
│  ├─ VoiceInputView                                          │
│  ├─ NutritionDisplayView                                    │
│  ├─ DailyTotalsView                                         │
│  └─ CalendarHistoryView                                     │
├─────────────────────────────────────────────────────────────┤
│  Business Logic Layer (ViewModels)                          │
│  ├─ VoiceInputViewModel                                     │
│  ├─ NutritionAnalysisViewModel                              │
│  └─ HistoryViewModel                                        │
├─────────────────────────────────────────────────────────────┤
│  Service Layer                                              │
│  ├─ SpeechRecognitionService (Speech Framework)             │
│  ├─ LLMService (OpenAI API)                                 │
│  ├─ IngredientDatabaseService                               │
│  └─ BackgroundTaskService (BGTaskScheduler)                 │
├─────────────────────────────────────────────────────────────┤
│  Data Layer                                                 │
│  ├─ SwiftData Models                                        │
│  ├─ Repository Pattern                                      │
│  └─ HealthKit Integration (Optional)                        │
└─────────────────────────────────────────────────────────────┘
          │                    │                    │
          ▼                    ▼                    ▼
    Speech Framework    OpenAI API         Local SwiftData
    (On-device STT)    (GPT-4o Turbo)      + CloudKit Sync
```

### Data Flow Architecture

```
User Voice Input
       │
       ▼
 Speech Framework (AVAudioEngine + SFSpeechRecognizer)
       │
       ▼
 Transcribed Text
       │
       ▼
 LLM Service (OpenAI GPT-4o)
       │
       ├─ System Prompt: Custom Ingredient Database Context
       ├─ User Prompt: Transcribed food description
       └─ Response Format: Structured JSON
       │
       ▼
 Parsed Nutritional Data
       │
       ├─ Calories (kcal)
       ├─ Protein (g)
       ├─ Carbohydrates (g)
       └─ Fat (g)
       │
       ▼
 SwiftData Persistence
       │
       ├─ FoodEntry Model (timestamp, nutrition, raw_text)
       └─ DailyTotal Model (date, aggregated_nutrition)
       │
       ▼
 UI Update (Real-time)
       │
       ├─ Display parsed nutrition
       ├─ Update daily totals
       └─ Add to calendar history
```

---

## III. iOS 18 Framework Requirements

### 3.1 SwiftUI Interface Components

**Required Frameworks**:
- `SwiftUI` (iOS 18.0+)
- `SwiftUICore` for advanced animations

**Key Components**:
- [`Button`](https://developer.apple.com/documentation/swiftui/button) with custom styling for voice activation
- [`Text`](https://developer.apple.com/documentation/swiftui/text) with dynamic type support
- [`List`](https://developer.apple.com/documentation/swiftui/list) for calendar history with lazy loading
- [`ProgressView`](https://developer.apple.com/documentation/swiftui/progressview) for daily calorie goals
- [`NavigationStack`](https://developer.apple.com/documentation/swiftui/navigationstack) for navigation hierarchy

**Accessibility Requirements**:
- VoiceOver support for all interactive elements
- Dynamic Type scaling (minimum Large, maximum AX5)
- High contrast mode support
- Reduced motion alternatives

### 3.2 Speech Framework Integration

**Required Frameworks**:
- `Speech` (iOS 18.0+)
- `AVFoundation` for audio capture

**Implementation Pattern**:
```swift
import Speech

class SpeechRecognitionService: ObservableObject {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    func requestAuthorization() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
    func startRecording() throws {
        // Implementation with AVAudioEngine
    }
}
```

**Privacy Requirements**:
- `NSSpeechRecognitionUsageDescription` in Info.plist
- `NSMicrophoneUsageDescription` in Info.plist
- Runtime permission requests with clear explanations
- Privacy manifest declaring speech recognition usage

### 3.3 LLM Integration (OpenAI API)

**Integration Approach**: Direct REST API integration via URLSession

**Required Frameworks**:
- `Foundation` (URLSession)
- No third-party SDKs for MVP (reduces dependencies)

**API Configuration**:
- Endpoint: `https://api.openai.com/v1/chat/completions`
- Model: `gpt-4o-turbo` (faster, cost-effective)
- Max tokens: 500 (sufficient for nutritional JSON)
- Temperature: 0.3 (deterministic responses)

**Implementation Pattern**:
```swift
struct LLMService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    func analyzeFood(_ description: String, context: [Ingredient]) async throws -> NutritionData {
        let systemPrompt = buildSystemPrompt(with: context)
        let request = ChatCompletionRequest(
            model: "gpt-4o-turbo",
            messages: [
                Message(role: "system", content: systemPrompt),
                Message(role: "user", content: description)
            ],
            temperature: 0.3,
            responseFormat: .jsonObject
        )
        // URLSession implementation
    }
}
```

**Response Format**:
```json
{
  "food_items": [
    {
      "name": "Grilled Chicken Breast",
      "quantity": 150,
      "unit": "g",
      "calories": 165,
      "protein": 31,
      "carbohydrates": 0,
      "fat": 3.6,
      "confidence": 0.95,
      "matched_ingredient_id": "chicken_breast_001"
    }
  ],
  "total_nutrition": {
    "calories": 165,
    "protein": 31,
    "carbohydrates": 0,
    "fat": 3.6
  }
}
```

**Error Handling**:
- Network timeout: 30 seconds
- Retry logic: 3 attempts with exponential backoff
- Fallback: Manual entry prompt
- Rate limiting: Client-side throttling (10 requests/minute)

### 3.4 SwiftData Persistence

**Required Frameworks**:
- `SwiftData` (iOS 17.0+, enhanced in iOS 18)

**Data Models**:

```swift
import SwiftData

@Model
final class FoodEntry {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var rawDescription: String
    var foodName: String
    var quantity: Double
    var unit: String
    var calories: Double
    var protein: Double
    var carbohydrates: Double
    var fat: Double
    var confidence: Double
    var matchedIngredientID: String?
    
    @Relationship(deleteRule: .nullify, inverse: \DailyTotal.entries)
    var dailyTotal: DailyTotal?
    
    init(timestamp: Date, rawDescription: String, nutrition: NutritionData) {
        self.id = UUID()
        self.timestamp = timestamp
        self.rawDescription = rawDescription
        // ... initialize other properties
    }
}

@Model
final class DailyTotal {
    @Attribute(.unique) var date: Date // Normalized to midnight
    var totalCalories: Double
    var totalProtein: Double
    var totalCarbohydrates: Double
    var totalFat: Double
    var entryCount: Int
    
    @Relationship(deleteRule: .cascade)
    var entries: [FoodEntry]
    
    init(date: Date) {
        self.date = Calendar.current.startOfDay(for: date)
        self.totalCalories = 0
        self.totalProtein = 0
        self.totalCarbohydrates = 0
        self.totalFat = 0
        self.entryCount = 0
        self.entries = []
    }
}

@Model
final class Ingredient {
    @Attribute(.unique) var id: String
    var name: String
    var aliases: [String] // For matching variations
    var servingSize: Double
    var servingUnit: String
    var caloriesPer100g: Double
    var proteinPer100g: Double
    var carbsPer100g: Double
    var fatPer100g: Double
    var category: String // e.g., "protein", "vegetable", "grain"
    var lastUpdated: Date
    
    init(id: String, name: String, nutrition: NutritionPer100g) {
        self.id = id
        self.name = name
        self.aliases = []
        // ... initialize other properties
    }
}
```

**ModelContainer Configuration**:
```swift
let container = try ModelContainer(
    for: FoodEntry.self, DailyTotal.self, Ingredient.self,
    configurations: ModelConfiguration(
        isStoredInMemoryOnly: false,
        cloudKitDatabase: .automatic // Optional iCloud sync
    )
)
```

**Query Patterns**:
```swift
// Fetch today's entries
@Query(
    filter: #Predicate<FoodEntry> { entry in
        entry.timestamp >= Calendar.current.startOfDay(for: Date())
    },
    sort: \FoodEntry.timestamp,
    order: .reverse
)
var todayEntries: [FoodEntry]

// Fetch daily totals for calendar view
@Query(
    sort: \DailyTotal.date,
    order: .reverse
)
var dailyTotals: [DailyTotal]
```

### 3.5 Background Task Scheduling

**Required Frameworks**:
- `BackgroundTasks` (iOS 18.0+)

**Implementation**:
```swift
import BackgroundTasks

class BackgroundTaskService {
    static let midnightResetTaskID = "com.demeter.midnightReset"
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Self.midnightResetTaskID,
            using: nil
        ) { task in
            self.handleMidnightReset(task: task as! BGProcessingTask)
        }
    }
    
    func scheduleMidnightReset() {
        let request = BGProcessingTaskRequest(identifier: Self.midnightResetTaskID)
        request.earliestBeginDate = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTime
        )
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false
        
        try? BGTaskScheduler.shared.submit(request)
    }
    
    private func handleMidnightReset(task: BGProcessingTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        Task {
            await performDailyRollover()
            task.setTaskCompleted(success: true)
            scheduleMidnightReset() // Schedule next day
        }
    }
    
    private func performDailyRollover() async {
        // Atomic transaction to archive yesterday's data
        // and reset daily totals
    }
}
```

**Info.plist Configuration**:
```xml
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
    <string>com.demeter.midnightReset</string>
</array>
```

### 3.6 HealthKit Integration (Optional)

**Required Frameworks**:
- `HealthKit` (iOS 18.0+)

**Capabilities**:
- Export daily nutritional data to Health app
- Read user's active energy burned for net calorie calculations
- Write dietary energy, protein, carbs, fat

**Implementation**:
```swift
import HealthKit

class HealthKitService {
    private let healthStore = HKHealthStore()
    
    func requestAuthorization() async throws {
        let typesToWrite: Set<HKSampleType> = [
            HKQuantityType(.dietaryEnergyConsumed),
            HKQuantityType(.dietaryProtein),
            HKQuantityType(.dietaryCarbohydrates),
            HKQuantityType(.dietaryFatTotal)
        ]
        
        let typesToRead: Set<HKObjectType> = [
            HKQuantityType(.activeEnergyBurned)
        ]
        
        try await healthStore.requestAuthorization(
            toShare: typesToWrite,
            read: typesToRead
        )
    }
    
    func exportDailyNutrition(_ dailyTotal: DailyTotal) async throws {
        // Create HKQuantitySample objects and save to HealthKit
    }
}
```

**Privacy Requirements**:
- `NSHealthShareUsageDescription` in Info.plist
- `NSHealthUpdateUsageDescription` in Info.plist
- Explicit opt-in UI with clear benefits explanation

### 3.7 Privacy Manifest Requirements

**Required File**: `PrivacyInfo.xcprivacy`

**Declarations**:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeAudioData</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <false/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeHealthData</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <true/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
    </array>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

### 3.8 App Store Submission Prerequisites

**Required Assets**:
- App Icon (1024x1024px)
- Screenshots (6.7", 6.5", 5.5" iPhone)
- Privacy Policy URL
- Support URL

**App Store Connect Configuration**:
- Age Rating: 4+ (no objectionable content)
- Category: Health & Fitness
- Pricing: Free (with optional IAP for premium features post-MVP)

**Review Guidelines Compliance**:
- 2.1: App Completeness (fully functional MVP)
- 2.3.8: Metadata accuracy (no misleading claims about nutritional accuracy)
- 5.1.1: Data Collection and Storage (privacy manifest)
- 5.1.2: Data Use and Sharing (no third-party sharing)

---

## IV. Database Architecture & Data Management

### 4.1 Custom Ingredients Database Schema

**Design Philosophy**: Start with a curated set of 50-100 common ingredients, expandable through user contributions and admin curation.

**Ingredient Model** (detailed):
```swift
@Model
final class Ingredient {
    // Identity
    @Attribute(.unique) var id: String // e.g., "chicken_breast_grilled_001"
    var name: String // Primary name
    var aliases: [String] // ["chicken", "grilled chicken", "chicken breast"]
    
    // Nutritional Data (per 100g standard)
    var caloriesPer100g: Double
    var proteinPer100g: Double
    var carbsPer100g: Double
    var fatPer100g: Double
    var fiberPer100g: Double?
    var sugarPer100g: Double?
    
    // Serving Information
    var commonServingSize: Double // e.g., 150
    var commonServingUnit: String // e.g., "g", "cup", "piece"
    var servingSizeVariations: [ServingVariation] // Multiple serving options
    
    // Metadata
    var category: IngredientCategory // enum: protein, vegetable, grain, etc.
    var subcategory: String? // e.g., "poultry", "leafy greens"
    var tags: [String] // ["high-protein", "low-carb", "keto-friendly"]
    var source: DataSource // enum: usda, custom, user_contributed
    var verificationStatus: VerificationStatus // enum: verified, pending, unverified
    var lastUpdated: Date
    var usageCount: Int // Track popularity for better matching
    
    // Matching Optimization
    var searchTokens: [String] // Preprocessed for fuzzy matching
    var embeddings: [Float]? // Optional: Vector embeddings for semantic search
}

struct ServingVariation: Codable {
    var amount: Double
    var unit: String
    var description: String // e.g., "1 medium breast", "1 cup diced"
    var gramsEquivalent: Double
}

enum IngredientCategory: String, Codable {
    case protein, vegetable, fruit, grain, dairy, fat, beverage, snack, condiment
}

enum DataSource: String, Codable {
    case usda, nutritionix, custom, userContributed
}

enum VerificationStatus: String, Codable {
    case verified, pending, unverified
}
```

**Initial Database Seeding Strategy**:

1. **Core 50 Ingredients** (MVP Launch):
    - 15 Proteins: chicken breast, salmon, eggs, tofu, ground beef, etc.
    - 15 Vegetables: broccoli, spinach, carrots, tomatoes, etc.
    - 10 Grains: rice, pasta, bread, oats, quinoa, etc.
    - 5 Fruits: banana, apple, berries, orange, etc.
    - 5 Dairy: milk, yogurt, cheese, etc.

2. **Data Sources**:
    - USDA FoodData Central API (free, comprehensive)
    - Manual curation for common branded items
    - User contribution system (post-MVP)

3. **Database Population Script**:
```swift
struct DatabaseSeeder {
    func seedInitialIngredients() async throws {
        let ingredients = [
            Ingredient(
                id: "chicken_breast_grilled_001",
                name: "Grilled Chicken Breast",
                aliases: ["chicken breast", "grilled chicken", "chicken"],
                caloriesPer100g: 165,
                proteinPer100g: 31,
                carbsPer100g: 0,
                fatPer100g: 3.6,
                commonServingSize: 150,
                commonServingUnit: "g",
                category: .protein,
                source: .usda
            ),
            // ... more ingredients
        ]
        
        for ingredient in ingredients {
            modelContext.insert(ingredient)
        }
        try modelContext.save()
    }
}
```

### 4.2 LLM Context Injection Strategy

**Approach**: Dynamic system prompt construction with relevant ingredient context

**Context Selection Algorithm**:
1. Extract keywords from user's voice input
2. Query ingredient database for fuzzy matches
3. Rank by relevance (usage count, category match, alias overlap)
4. Select top 10-20 most relevant ingredients
5. Format as structured JSON for system prompt

**System Prompt Template**:
```
You are a nutritional analysis assistant for the Demeter calorie tracking app. 
Your task is to parse natural language food descriptions and return structured 
nutritional data in JSON format.

CUSTOM INGREDIENT DATABASE:
{ingredient_context_json}

USER INPUT RULES:
1. Match user descriptions to custom ingredients when possible
2. Use "matched_ingredient_id" field when match found
3. Estimate quantities if not specified (use common serving sizes)
4. Provide confidence score (0.0-1.0) for each food item
5. If no custom ingredient matches, use general nutritional knowledge
6. Always return valid JSON in the specified format

RESPONSE FORMAT:
{
  "food_items": [
    {
      "name": "string",
      "quantity": number,
      "unit": "string",
      "calories": number,
      "protein": number,
      "carbohydrates": number,
      "fat": number,
      "confidence": number,
      "matched_ingredient_id": "string or null"
    }
  ],
  "total_nutrition": {
    "calories": number,
    "protein": number,
    "carbohydrates": number,
    "fat": number
  }
}
```

**Implementation**:
```swift
struct LLMContextBuilder {
    func buildSystemPrompt(for userInput: String, database: [Ingredient]) -> String {
        let keywords = extractKeywords(from: userInput)
        let relevantIngredients = findRelevantIngredients(keywords: keywords, in: database)
        let ingredientJSON = encodeIngredients(relevantIngredients)
        
        return systemPromptTemplate.replacingOccurrences(
            of: "{ingredient_context_json}",
            with: ingredientJSON
        )
    }
    
    private func findRelevantIngredients(keywords: [String], in database: [Ingredient]) -> [Ingredient] {
        return database
            .map { ingredient in
                let score = calculateRelevanceScore(ingredient: ingredient, keywords: keywords)
                return (ingredient, score)
            }
            .sorted { $0.1 > $1.1 }
            .prefix(20)
            .map { $0.0 }
    }
    
    private func calculateRelevanceScore(ingredient: Ingredient, keywords: [String]) -> Double {
        var score = 0.0
        
        // Exact name match
        if keywords.contains(where: { ingredient.name.lowercased().contains($0.lowercased()) }) {
            score += 10.0
        }
        
        // Alias match
        for alias in ingredient.aliases {
            if keywords.contains(where: { alias.lowercased().contains($0.lowercased()) }) {
                score += 5.0
            }
        }
        
        // Usage count (popularity)
        score += Double(ingredient.usageCount) * 0.1
        
        return score
    }
}
```

### 4.3 Caching Strategy

**Multi-Level Caching**:

1. **LLM Response Cache** (In-Memory):
    - Cache parsed nutritional data for identical voice inputs
    - TTL: 24 hours
    - Max size: 100 entries
    - Eviction: LRU (Least Recently Used)

2. **Ingredient Query Cache** (In-Memory):
    - Cache frequently accessed ingredients
    - TTL: 1 hour
    - Max size: 50 ingredients

3. **Daily Totals Cache** (SwiftData + In-Memory):
    - Current day's totals kept in memory
    - Persisted to SwiftData on each update
    - Invalidated at midnight

**Implementation**:
```swift
actor ResponseCache {
    private var cache: [String: CachedResponse] = [:]
    private let maxSize = 100
    
    struct CachedResponse {
        let data: NutritionData
        let timestamp: Date
        let ttl: TimeInterval = 86400 // 24 hours
        
        var isExpired: Bool {
            Date().timeIntervalSince(timestamp) > ttl
        }
    }
    
    func get(key: String) -> NutritionData? {
        guard let cached = cache[key], !cached.isExpired else {
            cache.removeValue(forKey: key)
            return nil
        }
        return cached.data
    }
    
    func set(key: String, value: NutritionData) {
        if cache.count >= maxSize {
            // Remove oldest entry
            let oldestKey = cache.min(by: { $0.value.timestamp < $1.value.timestamp })?.key
            if let key = oldestKey {
                cache.removeValue(forKey: key)
            }
        }
        cache[key] = CachedResponse(data: value, timestamp: Date())
    }
}
```

### 4.4 Data Retention & Archival

**Retention Policy**:
- **Active Data**: Current day + 30 days (hot storage)
- **Historical Data**: 31-365 days (warm storage, lazy loaded)
- **Long-term Archive**: 365+ days (cold storage, on-demand)

**Implementation**:
```swift
struct DataRetentionService {
    func archiveOldData() async throws {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        
        // Query old daily totals
        let descriptor = FetchDescriptor<DailyTotal>(
            predicate: #Predicate { $0.date < thirtyDaysAgo },
            sortBy: [SortDescriptor(\.date)]
        )
        
        let oldTotals = try modelContext.fetch(descriptor)
        
        // Export to JSON for long-term storage
        let archiveData = try JSONEncoder().encode(oldTotals)
        try archiveData.write(to: getArchiveURL())
        
        // Optionally delete from SwiftData to reduce database size
        // (Keep for MVP, implement deletion post-MVP)
    }
}
```

### 4.5 Synchronization Strategy

**iCloud Sync via CloudKit**:
- Automatic sync when enabled
- Conflict resolution: Last-write-wins for daily totals
- Merge strategy for concurrent food entries (append both)

**Offline Capability**:
- All core features work offline (voice → LLM requires network)
- Queue LLM requests when offline, process when online
- Local ingredient database always available
- Fallback to generic nutritional estimates when LLM unavailable

**Implementation**:
```swift
class SyncService {
    func handleOfflineEntry(_ entry: FoodEntry) async {
        // Save locally immediately
        modelContext.insert(entry)
        try? modelContext.save()
        
        // Queue for LLM processing when online
        await offlineQueue.enqueue(entry)
    }
    
    func processOfflineQueue() async {
        guard NetworkMonitor.shared.isConnected else { return }
        
        while let entry = await offlineQueue.dequeue() {
            do {
                let enhancedData = try await llmService.analyzeFood(entry.rawDescription)
                entry.updateNutrition(from: enhancedData)
                try? modelContext.save()
            } catch {
                // Re-queue or mark as failed
            }
        }
    }
}
```

---

## V. Architecture Decision: MCP vs Alternative Connectors

### 5.1 Evaluation Criteria

| Criterion | Weight | MCP | REST API | GraphQL | Embedded Vector DB |
|-----------|--------|-----|----------|---------|-------------------|
| **Latency** | 25% | 3/5 | 5/5 | 4/5 | 5/5 |
| **Accuracy** | 30% | 4/5 | 3/5 | 3/5 | 5/5 |
| **Cost** | 20% | 2/5 | 4/5 | 4/5 | 5/5 |
| **Maintainability** | 15% | 3/5 | 5/5 | 3/5 | 2/5 |
| **Scalability** | 10% | 4/5 | 5/5 | 5/5 | 3/5 |
| **Weighted Score** | - | **3.35** | **4.15** | **3.65** | **4.25** |

### 5.2 Detailed Analysis

#### Option 1: Model Context Protocol (MCP)

**Description**: MCP is a standardized protocol for connecting LLMs to external data sources, enabling context-aware responses.

**Pros**:
- Standardized interface for LLM-database integration
- Built-in context management and caching
- Supports multiple LLM providers
- Reduces prompt engineering complexity

**Cons**:
- Additional abstraction layer increases latency (50-100ms overhead)
- Requires MCP server deployment and maintenance
- Limited iOS-native implementations (mostly server-side)
- Overkill for simple ingredient database queries
- Higher operational complexity for MVP

**Cost Implications**:
- MCP server hosting: $20-50/month
- LLM API costs: Same as direct integration
- Development time: +2-3 weeks for MCP setup

**Recommendation for Demeter**: ❌ **Not Recommended for MVP**
- MCP adds unnecessary complexity for a simple ingredient database
- Better suited for complex, multi-source data integration
- Consider post-MVP if expanding to multiple data sources

#### Option 2: Direct REST API Integration (OpenAI)

**Description**: Direct URLSession-based integration with OpenAI API, injecting ingredient context via system prompts.

**Pros**:
- Simplest implementation (native URLSession)
- Lowest latency (direct API calls)
- No additional infrastructure required
- Easy to debug and maintain
- Full control over request/response handling

**Cons**:
- Manual prompt engineering required
- No built-in context management
- Requires custom caching implementation
- Limited to single LLM provider (vendor lock-in)

**Cost Implications**:
- LLM API costs: ~$0.01-0.03 per request (GPT-4o Turbo)
- Estimated monthly cost (100 users, 10 entries/day): $30-90
- No additional infrastructure costs

**Recommendation for Demeter**: ✅ **Recommended for MVP**
- Fastest time-to-market
- Lowest operational complexity
- Sufficient for MVP scale (< 1000 users)
- Easy to migrate to alternatives later

#### Option 3: GraphQL Endpoint

**Description**: Custom GraphQL API serving ingredient data, with LLM making structured queries.

**Pros**:
- Flexible data fetching (request only needed fields)
- Strong typing and schema validation
- Efficient for complex queries
- Good for future API expansion

**Cons**:
- Requires custom GraphQL server deployment
- Overkill for simple ingredient lookups
- Higher development and maintenance overhead
- LLMs not optimized for GraphQL query generation

**Cost Implications**:
- GraphQL server hosting: $20-40/month
- Development time: +3-4 weeks
- Ongoing maintenance: Medium

**Recommendation for Demeter**: ❌ **Not Recommended**
- Unnecessary complexity for ingredient database
- Better suited for complex, relational data queries
- No significant advantage over REST for this use case

#### Option 4: Embedded Vector Database (Semantic Search)

**Description**: Store ingredient embeddings locally, use semantic search to match user input, then query nutritional data.

**Pros**:
- Highest accuracy for ingredient matching
- Works fully offline
- No per-request LLM costs for matching
- Fast lookups (< 10ms)
- Handles typos and variations well

**Cons**:
- Requires initial embedding generation (one-time LLM cost)
- Larger app size (embeddings storage)
- Complex implementation (vector search library)
- Still needs LLM for quantity/nutrition calculation
- Higher development complexity

**Cost Implications**:
- One-time embedding generation: $5-10 (for 100 ingredients)
- Vector search library: Free (e.g., FAISS, Hnswlib)
- Ongoing LLM costs: Reduced by 30-50%
- Development time: +4-5 weeks

**Recommendation for Demeter**: ⚠️ **Consider Post-MVP**
- Excellent for accuracy and offline capability
- Significant development investment
- Best implemented after validating MVP with users
- Ideal for scaling to 1000+ ingredients

### 5.3 Hybrid Approach (Recommended Long-term)

**Phase 1 (MVP)**: Direct REST API with system prompt injection
**Phase 2 (Post-MVP)**: Add embedded vector search for ingredient matching
**Phase 3 (Scale)**: Evaluate MCP if integrating multiple data sources

**Migration Path**:
```
MVP (Weeks 1-8):
└─ Direct OpenAI API + System Prompt Injection

Post-MVP (Months 3-6):
└─ Add Vector Search Layer
   ├─ Generate embeddings for all ingredients
   ├─ Implement semantic search for matching
   └─ Use LLM only for quantity/nutrition calculation

Scale (Months 6-12):
└─ Evaluate MCP if needed
   ├─ Multiple data sources (USDA, Nutritionix, etc.)
   ├─ Real-time nutritional updates
   └─ Advanced context management
```

### 5.4 Final Recommendation

**For Demeter MVP**: **Direct REST API Integration (Option 2)**

**Justification**:
1. **Speed to Market**: 2-3 weeks faster than alternatives
2. **Cost-Effective**: No additional infrastructure costs
3. **Sufficient Accuracy**: System prompt injection provides 85-90% accuracy
4. **Maintainability**: Simple, debuggable, well-documented
5. **Flexibility**: Easy to migrate to hybrid approach later

**Implementation Priority**:
```
1. Direct OpenAI API integration (Week 1-2)
2. System prompt optimization (Week 3)
3. Response caching (Week 4)
4. Error handling & fallbacks (Week 5)
5. Performance monitoring (Week 6)
```

---

## VI. Security & Privacy Architecture

### 6.1 Data Security Principles

**Principle**: Defense in depth with multiple security layers

**Implementation**:
1. **API Key Management**:
    - Store OpenAI API key in Keychain (never in UserDefaults)
    - Use environment-specific keys (dev, staging, prod)
    - Rotate keys quarterly

2. **Network Security**:
    - TLS 1.3 for all API communications
    - Certificate pinning for OpenAI API
    - Request signing for integrity verification

3. **Local Data Encryption**:
    - SwiftData encryption at rest (iOS default)
    - Keychain for sensitive credentials
    - Secure enclave for biometric authentication (future)

**Implementation**:
```swift
class SecurityService {
    func storeAPIKey(_ key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "openai_api_key",
            kSecValueData as String: key.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw SecurityError.keychainStorageFailed
        }
    }
    
    func retrieveAPIKey() throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "openai_api_key",
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let key = String(data: data, encoding: .utf8) else {
            throw SecurityError.keychainRetrievalFailed
        }
        
        return key
    }
}
```

### 6.2 Privacy Compliance

**GDPR/CCPA Compliance**:
- User data export functionality
- Account deletion with complete data removal
- Transparent data usage policies
- No third-party data sharing

**App Tracking Transparency**:
- No tracking implemented (ATT not required)
- No third-party analytics in MVP
- First-party analytics only (anonymous usage metrics)

---

## VII. Testing Strategy

### 7.1 Testing Pyramid

```
        /\
       /  \
      / UI \
     /------\
    /        \
   /Integration\
  /------------\
 /              \
/  Unit Tests    \
------------------
```

**Distribution**:
- Unit Tests: 70% (fast, isolated)
- Integration Tests: 20% (component interaction)
- UI Tests: 10% (critical user flows)

### 7.2 Test Coverage Requirements

**Minimum Coverage**: 80% for MVP

**Critical Paths** (100% coverage required):
1. Voice input → LLM processing → Data persistence
2. Daily total calculations
3. Midnight reset logic
4. Ingredient database queries

**Test Implementation**:
```swift
@Test("Voice input processes correctly")
func testVoiceInputProcessing() async throws {
    let service = SpeechRecognitionService()
    let mockAudio = loadMockAudioFile("chicken_breast.wav")
    
    let transcription = try await service.transcribe(mockAudio)
    #expect(transcription.contains("chicken"))
}

@Test("LLM returns valid nutrition data")
func testLLMNutritionParsing() async throws {
    let service = LLMService(apiKey: "test_key")
    let mockResponse = """
    {
      "food_items": [{
        "name": "Chicken Breast",
        "calories": 165,
        "protein": 31,
        "carbohydrates": 0,
        "fat": 3.6
      }]
    }
    """
    
    let nutrition = try service.parseResponse(mockResponse)
    #expect(nutrition.calories == 165)
}

@Test("Daily totals calculate correctly")
func testDailyTotalCalculation() throws {
    let entry1 = FoodEntry(calories: 200, protein: 20, carbs: 10, fat: 5)
    let entry2 = FoodEntry(calories: 300, protein: 15, carbs: 30, fat: 10)
    
    let total = DailyTotal(entries: [entry1, entry2])
    #expect(total.totalCalories == 500)
    #expect(total.totalProtein == 35)
}
```

---

## VIII. Performance Requirements

### 8.1 Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Voice input latency | < 500ms | Time to start recording |
| Speech-to-text latency | < 2s | Transcription completion |
| LLM response time | < 3s | API round-trip |
| UI update latency | < 100ms | Data → UI render |
| App launch time | < 2s | Cold start to interactive |
| Memory footprint | < 100MB | Typical usage |
| Battery impact | < 5% | Per hour of active use |

### 8.2 Optimization Strategies

**Network Optimization**:
- Request compression (gzip)
- Response streaming for large payloads
- Connection pooling for API requests

**UI Optimization**:
- Lazy loading for calendar history
- Image caching for food photos (post-MVP)
- SwiftUI view diffing optimization

**Database Optimization**:
- Indexed queries on timestamp and date fields
- Batch inserts for multiple food entries
- Pagination for historical data

---

## IX. Monitoring & Analytics

### 9.1 Key Metrics

**User Engagement**:
- Daily active users (DAU)
- Average entries per day
- Voice input success rate
- Manual entry fallback rate

**Technical Metrics**:
- LLM API latency (p50, p95, p99)
- Speech recognition accuracy
- Ingredient matching accuracy
- App crash rate
- Network error rate

**Business Metrics**:
- User retention (D1, D7, D30)
- Feature adoption rate
- API cost per user
- User satisfaction (in-app surveys)

### 9.2 Implementation

**Analytics Service**:
```swift
class AnalyticsService {
    func trackEvent(_ event: AnalyticsEvent) {
        // First-party analytics only (no third-party)
        // Store locally, aggregate, send anonymized data
    }
    
    func trackPerformance(_ metric: PerformanceMetric) {
        // Track latency, errors, resource usage
    }
}

enum AnalyticsEvent {
    case voiceInputStarted
    case voiceInputCompleted(duration: TimeInterval)
    case llmRequestSent
    case llmResponseReceived(latency: TimeInterval)
    case foodEntryAdded(source: EntrySource)
    case dailyGoalReached
}
```

---

## X. Deployment & Release Strategy

### 10.1 MVP Release Checklist

**Pre-Launch**:
- [ ] All unit tests passing (80%+ coverage)
- [ ] Integration tests passing
- [ ] UI tests for critical flows passing
- [ ] Performance benchmarks met
- [ ] Privacy manifest complete
- [ ] App Store assets prepared
- [ ] Beta testing completed (TestFlight, 20+ users)

**Launch**:
- [ ] Submit to App Store Review
- [ ] Monitor crash reports
- [ ] Track key metrics
- [ ] Gather user feedback

**Post-Launch**:
- [ ] Weekly bug fix releases (if needed)
- [ ] Monthly feature updates
- [ ] Quarterly major releases

### 10.2 Version Numbering

**Format**: MAJOR.MINOR.PATCH

- **MAJOR**: Breaking changes, major feature additions
- **MINOR**: New features, non-breaking changes
- **PATCH**: Bug fixes, performance improvements

**Example**:
- 1.0.0: MVP launch
- 1.1.0: Add photo recognition
- 1.1.1: Fix voice input bug
- 2.0.0: Complete UI redesign

---

## XI. Future Enhancements (Post-MVP)

### 11.1 Planned Features

**Phase 2** (Months 3-6):
1. Photo-based food recognition (Vision framework + LLM)
2. Meal planning and suggestions
3. Recipe import and nutritional breakdown
4. Social features (share meals, challenges)
5. Advanced analytics and trends

**Phase 3** (Months 6-12):
1. Barcode scanning for packaged foods
2. Restaurant menu integration
3. Wearable device integration (Apple Watch)
4. AI-powered meal recommendations
5. Nutritionist consultation marketplace

### 11.2 Technical Debt Management

**Refactoring Priorities**:
1. Extract networking layer into separate module
2. Implement comprehensive error handling
3. Add comprehensive logging
4. Optimize database queries
5. Implement A/B testing framework

---

## XII. Governance & Amendment Process

### 12.1 Constitution Authority

This technical constitution serves as the authoritative source for all architectural decisions, technical standards, and development practices for the Demeter iOS application.

**Precedence**:
1. Technical Constitution (this document)
2. iOS Human Interface Guidelines
3. Apple App Store Review Guidelines
4. Team coding standards

### 12.2 Amendment Process

**Proposal**:
1. Document proposed change with rationale
2. Assess impact on existing architecture
3. Estimate implementation effort
4. Present to technical review committee

**Approval**:
1. Technical lead approval required
2. Document amendment in version history
3. Update affected documentation
4. Communicate to development team

**Implementation**:
1. Create migration plan if needed
2. Update codebase incrementally
3. Verify no regressions
4. Update this constitution document

### 12.3 Review Cadence

**Quarterly Reviews**:
- Assess architecture decisions against actual usage
- Evaluate new iOS framework capabilities
- Review performance metrics
- Update technical debt priorities

**Annual Reviews**:
- Major architecture reassessment
- Technology stack evaluation
- Security audit
- Compliance review

---

## XIII. Appendices

### Appendix A: Glossary

- **LLM**: Large Language Model (e.g., GPT-4o)
- **MCP**: Model Context Protocol
- **SwiftData**: Apple's modern data persistence framework
- **BGTaskScheduler**: iOS background task scheduling framework
- **HealthKit**: Apple's health data framework
- **MVP**: Minimum Viable Product

### Appendix B: Reference Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     Demeter iOS App                          │
│                                                              │
│  ┌
