# SwiftData Models Quickstart Guide

**Feature**: 001-swiftdata-models
**Date**: 2025-11-03

## Overview

This guide provides a quick start for implementing the SwiftData models (FoodEntry, DailyTotal, Ingredient) in the Demeter iOS application. Follow these steps to integrate the data models into your SwiftUI MVVM architecture.

## Prerequisites

- iOS 18.0+ target
- Xcode 15.0+
- Swift 5.9+
- SwiftData framework imported

## Step 1: Model Implementation

### Create Models Directory

```bash
mkdir -p Demeter/Models
```

### Implement FoodEntry Model

Create `Demeter/Models/FoodEntry.swift`:

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

    init(
        timestamp: Date,
        rawDescription: String,
        foodName: String,
        quantity: Double,
        unit: String,
        calories: Double,
        protein: Double,
        carbohydrates: Double,
        fat: Double,
        confidence: Double,
        matchedIngredientID: String? = nil
    ) {
        self.id = UUID()
        self.timestamp = timestamp
        self.rawDescription = rawDescription
        self.foodName = foodName
        self.quantity = quantity
        self.unit = unit
        self.calories = calories
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.fat = fat
        self.confidence = confidence
        self.matchedIngredientID = matchedIngredientID
    }

    var isValid: Bool {
        quantity > 0 &&
        !foodName.isEmpty &&
        calories >= 0 &&
        protein >= 0 &&
        carbohydrates >= 0 &&
        fat >= 0
    }
}
```

### Implement DailyTotal Model

Create `Demeter/Models/DailyTotal.swift`:

```swift
import SwiftData

@Model
final class DailyTotal {
    @Attribute(.unique) var id: UUID
    var date: Date
    var totalCalories: Double
    var totalProtein: Double
    var totalCarbohydrates: Double
    var totalFat: Double
    var entryCount: Int

    @Relationship(deleteRule: .cascade)
    var entries: [FoodEntry]

    init(date: Date) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.totalCalories = 0
        self.totalProtein = 0
        self.totalCarbohydrates = 0
        self.totalFat = 0
        self.entryCount = 0
        self.entries = []
    }

    var hasEntries: Bool { !entries.isEmpty }

    func addEntry(_ entry: FoodEntry) {
        entries.append(entry)
        entry.dailyTotal = self
        updateTotals()
    }

    func removeEntry(_ entry: FoodEntry) {
        entries.removeAll { $0.id == entry.id }
        entry.dailyTotal = nil
        updateTotals()
    }

    private func updateTotals() {
        totalCalories = entries.reduce(0) { $0 + $1.calories }
        totalProtein = entries.reduce(0) { $0 + $1.protein }
        totalCarbohydrates = entries.reduce(0) { $0 + $1.carbohydrates }
        totalFat = entries.reduce(0) { $0 + $1.fat }
        entryCount = entries.count
    }
}
```

### Implement Ingredient Model

Create `Demeter/Models/Ingredient.swift`:

```swift
import SwiftData

@Model
final class Ingredient {
    @Attribute(.unique) var id: String
    var name: String
    var aliases: [String]
    var caloriesPer100g: Double
    var proteinPer100g: Double
    var carbsPer100g: Double
    var fatPer100g: Double
    var fiberPer100g: Double?
    var sugarPer100g: Double?
    var commonServingSize: Double
    var commonServingUnit: String
    var category: IngredientCategory
    var source: DataSource
    var verificationStatus: VerificationStatus
    var lastUpdated: Date
    var usageCount: Int
    var searchTokens: [String]

    init(
        id: String,
        name: String,
        caloriesPer100g: Double,
        proteinPer100g: Double,
        carbsPer100g: Double,
        fatPer100g: Double,
        commonServingSize: Double,
        commonServingUnit: String,
        category: IngredientCategory,
        source: DataSource
    ) {
        self.id = id
        self.name = name
        self.aliases = []
        self.caloriesPer100g = caloriesPer100g
        self.proteinPer100g = proteinPer100g
        self.carbsPer100g = carbsPer100g
        self.fatPer100g = fatPer100g
        self.commonServingSize = commonServingSize
        self.commonServingUnit = commonServingUnit
        self.category = category
        self.source = source
        self.verificationStatus = .pending
        self.lastUpdated = Date()
        self.usageCount = 0
        self.searchTokens = []
    }

    var isVerified: Bool { verificationStatus == .verified }
    var displayName: String { name.capitalized }
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

## Step 2: Configure ModelContainer

Update `DemeterApp.swift`:

```swift
import SwiftUI
import SwiftData

@main
struct DemeterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [FoodEntry.self, DailyTotal.self, Ingredient.self])
    }
}
```

For more control, use custom configuration:

```swift
let container = try ModelContainer(
    for: FoodEntry.self, DailyTotal.self, Ingredient.self,
    configurations: ModelConfiguration(
        isStoredInMemoryOnly: false,
        cloudKitDatabase: .automatic
    )
)

@main
struct DemeterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
}
```

## Step 3: Basic Usage Examples

### Creating and Saving a FoodEntry

```swift
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Button("Add Food Entry") {
            let entry = FoodEntry(
                timestamp: Date(),
                rawDescription: "ate a chicken breast",
                foodName: "Grilled Chicken Breast",
                quantity: 150,
                unit: "g",
                calories: 165,
                protein: 31,
                carbohydrates: 0,
                fat: 3.6,
                confidence: 0.95,
                matchedIngredientID: "chicken_breast_001"
            )

            modelContext.insert(entry)

            // Associate with today's total
            let today = Calendar.current.startOfDay(for: Date())
            let descriptor = FetchDescriptor<DailyTotal>(
                predicate: #Predicate { $0.date == today }
            )

            if let dailyTotal = try? modelContext.fetch(descriptor).first {
                dailyTotal.addEntry(entry)
            } else {
                let newTotal = DailyTotal(date: today)
                newTotal.addEntry(entry)
                modelContext.insert(newTotal)
            }
        }
    }
}
```

### Querying Today's Entries

```swift
struct TodayView: View {
    @Query(
        filter: #Predicate<FoodEntry> { entry in
            entry.timestamp >= Calendar.current.startOfDay(for: Date())
        },
        sort: \FoodEntry.timestamp,
        order: .reverse
    )
    private var todayEntries: [FoodEntry]

    var body: some View {
        List(todayEntries) { entry in
            VStack(alignment: .leading) {
                Text(entry.foodName)
                Text("\(entry.calories, specifier: "%.0f") cal")
                    .font(.caption)
            }
        }
    }
}
```

### Searching Ingredients

```swift
struct IngredientSearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [Ingredient] = []

    var body: some View {
        VStack {
            TextField("Search ingredients", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()

            List(searchResults) { ingredient in
                VStack(alignment: .leading) {
                    Text(ingredient.displayName)
                    Text("\(ingredient.caloriesPer100g, specifier: "%.0f") cal/100g")
                        .font(.caption)
                }
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            performSearch(newValue)
        }
    }

    private func performSearch(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        let descriptor = FetchDescriptor<Ingredient>(
            predicate: #Predicate<Ingredient> { ingredient in
                ingredient.name.localizedCaseInsensitiveContains(query) ||
                ingredient.aliases.contains { $0.localizedCaseInsensitiveContains(query) }
            },
            sortBy: [SortDescriptor(\.usageCount, order: .reverse)]
        )

        searchResults = (try? modelContext.fetch(descriptor)) ?? []
    }
}
```

## Step 4: Repository Pattern (Recommended)

Create repositories for better separation of concerns:

### FoodEntryRepository

```swift
import SwiftData

class FoodEntryRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func create(_ entry: FoodEntry) throws {
        modelContext.insert(entry)
        try modelContext.save()
    }

    func fetchToday() throws -> [FoodEntry] {
        let descriptor = FetchDescriptor<FoodEntry>(
            predicate: #Predicate { entry in
                entry.timestamp >= Calendar.current.startOfDay(for: Date())
            },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
}
```

### Usage in ViewModel

```swift
class NutritionViewModel: ObservableObject {
    @Published var todayEntries: [FoodEntry] = []
    private let repository: FoodEntryRepository

    init(modelContext: ModelContext) {
        self.repository = FoodEntryRepository(modelContext: modelContext)
        loadTodayEntries()
    }

    func loadTodayEntries() {
        do {
            todayEntries = try repository.fetchToday()
        } catch {
            print("Error loading entries: \(error)")
        }
    }

    func addEntry(_ entry: FoodEntry) {
        do {
            try repository.create(entry)
            loadTodayEntries() // Refresh UI
        } catch {
            print("Error adding entry: \(error)")
        }
    }
}
```

## Step 5: Testing Setup

Create unit tests for your models:

```swift
import XCTest
import SwiftData
@testable import Demeter

final class FoodEntryTests: XCTestCase {
    var modelContext: ModelContext!

    override func setUp() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: FoodEntry.self, configurations: config)
        modelContext = ModelContext(container)
    }

    func testFoodEntryCreation() throws {
        // Given
        let timestamp = Date()
        let entry = FoodEntry(
            timestamp: timestamp,
            rawDescription: "ate an apple",
            foodName: "Apple",
            quantity: 1,
            unit: "medium",
            calories: 95,
            protein: 0.5,
            carbohydrates: 25,
            fat: 0.3,
            confidence: 0.9
        )

        // When
        modelContext.insert(entry)

        // Then
        XCTAssertTrue(entry.isValid)
        XCTAssertEqual(entry.foodName, "Apple")
        XCTAssertEqual(entry.calories, 95)
    }
}
```

## Step 6: Common Patterns

### Date Handling

```swift
// Normalize date to start of day
let normalizedDate = Calendar.current.startOfDay(for: someDate)

// Check if date is today
let isToday = Calendar.current.isDateInToday(someDate)

// Get date range for a week
let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
let dateRange = weekAgo...Date()
```

### Error Handling

```swift
do {
    try modelContext.save()
} catch {
    // Handle save errors
    print("Save failed: \(error.localizedDescription)")
}
```

### Background Processing

```swift
Task {
    await modelContext.perform {
        // Perform heavy operations here
        let entries = try? modelContext.fetch(descriptor)
        // Process entries...
    }
}
```

## Step 7: Performance Tips

1. **Use Queries Wisely**: Prefer `@Query` property wrappers for reactive UI updates
2. **Batch Operations**: Group multiple inserts/updates when possible
3. **Lazy Loading**: Use relationships judiciously to avoid loading unnecessary data
4. **Indexing**: SwiftData automatically indexes `@Attribute(.unique)` properties
5. **Background Tasks**: Move heavy queries to background threads

## Next Steps

1. Implement ViewModels using the repository pattern
2. Add SwiftUI views for displaying food entries and daily totals
3. Integrate with speech recognition for voice input
4. Add LLM service for nutritional analysis
5. Implement background tasks for midnight reset

## Troubleshooting

**Common Issues:**

1. **"Cannot find type 'Model' in scope"**
   - Ensure `import SwiftData` is added

2. **ModelContainer errors**
   - Check that all models are included in the container configuration

3. **Query compilation errors**
   - Verify predicate syntax and property names

4. **Relationship issues**
   - Ensure inverse relationships are correctly defined

For more detailed documentation, refer to:
- [Apple SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- `specs/001-swiftdata-models/data-model.md`
- `specs/001-swiftdata-models/contracts/model-apis.md`