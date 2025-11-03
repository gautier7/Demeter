# Data Model: SwiftData Models

**Feature**: 001-swiftdata-models
**Date**: 2025-11-03

## Overview

This document defines the SwiftData models for the Demeter iOS calorie tracking application. The models establish the core data entities for food entries, daily totals, and ingredient database, following the MVVM architecture pattern with Repository data access layer.

## Architecture Principles

- **SwiftData Framework**: Uses Apple's SwiftData for iOS 18+ persistence
- **Local-First**: Data stored locally with optional CloudKit sync
- **Relationships**: Proper entity relationships with cascade/inverse rules
- **Validation**: Input validation and data integrity constraints
- **Performance**: Optimized queries and aggregations for mobile app usage

## Entity Definitions

### FoodEntry Model

Represents an individual food consumption record with nutritional data.

```swift
import SwiftData

@Model
final class FoodEntry {
    // Identity
    @Attribute(.unique) var id: UUID

    // Temporal
    var timestamp: Date

    // Raw Input
    var rawDescription: String

    // Parsed Data
    var foodName: String
    var quantity: Double
    var unit: String

    // Nutritional Data
    var calories: Double
    var protein: Double
    var carbohydrates: Double
    var fat: Double

    // LLM Metadata
    var confidence: Double
    var matchedIngredientID: String?

    // Relationships
    @Relationship(deleteRule: .nullify, inverse: \DailyTotal.entries)
    var dailyTotal: DailyTotal?

    // Initialization
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

    // Validation
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

**Key Properties**:
- `id`: Unique identifier (UUID)
- `timestamp`: When the food was consumed
- `rawDescription`: Original voice input text
- `foodName`: Parsed food name from LLM
- `quantity`/`unit`: Parsed quantity and measurement unit
- `calories`/`protein`/`carbohydrates`/`fat`: Nutritional values
- `confidence`: LLM confidence score (0.0-1.0)
- `matchedIngredientID`: Reference to Ingredient database

**Relationships**:
- `dailyTotal`: Belongs to a DailyTotal (many-to-one)

### DailyTotal Model

Aggregates nutritional data for a specific date, supporting midnight reset functionality.

```swift
import SwiftData

@Model
final class DailyTotal {
    // Identity
    @Attribute(.unique) var id: UUID

    // Date (normalized to midnight)
    var date: Date

    // Aggregated Nutrition
    var totalCalories: Double
    var totalProtein: Double
    var totalCarbohydrates: Double
    var totalFat: Double

    // Metadata
    var entryCount: Int

    // Relationships
    @Relationship(deleteRule: .cascade)
    var entries: [FoodEntry]

    // Initialization
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

    // Computed Properties
    var averageConfidence: Double {
        guard !entries.isEmpty else { return 0 }
        return entries.reduce(0) { $0 + $1.confidence } / Double(entries.count)
    }

    var hasEntries: Bool {
        !entries.isEmpty
    }

    // Methods
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

**Key Properties**:
- `id`: Unique identifier (UUID)
- `date`: Normalized date (start of day)
- `totalCalories`/`totalProtein`/`totalCarbohydrates`/`totalFat`: Aggregated nutritional values
- `entryCount`: Number of food entries for the day

**Relationships**:
- `entries`: Has many FoodEntry records (one-to-many)

**Business Logic**:
- Automatic total recalculation when entries are added/removed
- Date normalization for consistent daily grouping
- Computed properties for analytics

### Ingredient Model

Reference database for food nutritional information, supporting LLM context injection.

```swift
import SwiftData

@Model
final class Ingredient {
    // Identity
    @Attribute(.unique) var id: String

    // Basic Info
    var name: String
    var aliases: [String]

    // Nutritional Data (per 100g)
    var caloriesPer100g: Double
    var proteinPer100g: Double
    var carbsPer100g: Double
    var fatPer100g: Double
    var fiberPer100g: Double?
    var sugarPer100g: Double?

    // Serving Information
    var commonServingSize: Double
    var commonServingUnit: String
    var servingSizeVariations: [ServingVariation]

    // Metadata
    var category: IngredientCategory
    var subcategory: String?
    var tags: [String]
    var source: DataSource
    var verificationStatus: VerificationStatus
    var lastUpdated: Date
    var usageCount: Int

    // Search Optimization
    var searchTokens: [String]

    // Initialization
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
        self.servingSizeVariations = []
        self.category = category
        self.tags = []
        self.source = source
        self.verificationStatus = .pending
        self.lastUpdated = Date()
        self.usageCount = 0
        self.searchTokens = []
    }

    // Computed Properties
    var isVerified: Bool {
        verificationStatus == .verified
    }

    var displayName: String {
        name.capitalized
    }

    // Methods
    func incrementUsage() {
        usageCount += 1
    }

    func addAlias(_ alias: String) {
        if !aliases.contains(alias.lowercased()) {
            aliases.append(alias.lowercased())
        }
    }
}

// Supporting Types
struct ServingVariation: Codable {
    var amount: Double
    var unit: String
    var description: String
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

**Key Properties**:
- `id`: Unique string identifier
- `name`/`aliases`: Primary name and alternative names
- Nutritional data per 100g (calories, macros, micros)
- Serving information for quantity conversion
- Category and metadata for organization
- Usage tracking for popularity-based matching

## ModelContainer Configuration

```swift
import SwiftData

let container = try ModelContainer(
    for: FoodEntry.self, DailyTotal.self, Ingredient.self,
    configurations: ModelConfiguration(
        isStoredInMemoryOnly: false,
        cloudKitDatabase: .automatic // Optional iCloud sync
    )
)
```

## Query Patterns

### FoodEntry Queries

```swift
// Today's entries
@Query(
    filter: #Predicate<FoodEntry> { entry in
        entry.timestamp >= Calendar.current.startOfDay(for: Date())
    },
    sort: \FoodEntry.timestamp,
    order: .reverse
)
var todayEntries: [FoodEntry]

// High-confidence entries
@Query(
    filter: #Predicate<FoodEntry> { entry in
        entry.confidence >= 0.8
    }
)
var highConfidenceEntries: [FoodEntry]
```

### DailyTotal Queries

```swift
// All daily totals for calendar view
@Query(
    sort: \DailyTotal.date,
    order: .reverse
)
var dailyTotals: [DailyTotal]

// Current week totals
@Query(
    filter: #Predicate<DailyTotal> { total in
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return total.date >= weekAgo
    },
    sort: \DailyTotal.date,
    order: .reverse
)
var thisWeekTotals: [DailyTotal]
```

### Ingredient Queries

```swift
// Search by name or alias
@Query(
    filter: #Predicate<Ingredient> { ingredient in
        let searchTerm = searchTerm.lowercased()
        return ingredient.name.localizedCaseInsensitiveContains(searchTerm) ||
               ingredient.aliases.contains { $0.localizedCaseInsensitiveContains(searchTerm) }
    },
    sort: \Ingredient.usageCount,
    order: .reverse
)
var searchResults: [Ingredient]

// Verified ingredients only
@Query(
    filter: #Predicate<Ingredient> { ingredient in
        ingredient.verificationStatus == .verified
    }
)
var verifiedIngredients: [Ingredient]
```

## Data Relationships Diagram

```
DailyTotal (1) ──── (many) FoodEntry
                     │
                     └─── (optional) Ingredient (lookup)
```

## Validation Rules

- **FoodEntry**: `quantity > 0`, all nutritional values ≥ 0, non-empty foodName
- **DailyTotal**: Date normalized to start of day, automatic total calculations
- **Ingredient**: Unique ID, valid category enum, positive nutritional values

## Performance Considerations

- **Indexing**: Automatic on `@Attribute(.unique)` properties
- **Relationships**: Lazy loading by default, explicit eager loading when needed
- **Queries**: Use predicates for filtering, sort descriptors for ordering
- **Aggregation**: Computed properties for real-time totals, background updates for heavy calculations

## Migration Strategy

For future model changes, use SwiftData's migration capabilities:

```swift
enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [FoodEntry.self, DailyTotal.self, Ingredient.self]
    }
}
```

## Testing Strategy

- **Unit Tests**: Model validation, computed properties, relationship integrity
- **Integration Tests**: Repository operations, query performance, data persistence
- **Edge Cases**: Invalid data handling, relationship cascades, date boundary conditions