# Model API Contracts

**Feature**: 001-swiftdata-models
**Date**: 2025-11-03

## Overview

This document defines the API contracts for the SwiftData models in the Demeter application. These contracts specify the public interfaces, validation rules, and behavioral expectations for FoodEntry, DailyTotal, and Ingredient models.

## FoodEntry API Contract

### Interface Definition

```swift
public protocol FoodEntryProtocol {
    var id: UUID { get }
    var timestamp: Date { get }
    var rawDescription: String { get }
    var foodName: String { get }
    var quantity: Double { get }
    var unit: String { get }
    var calories: Double { get }
    var protein: Double { get }
    var carbohydrates: Double { get }
    var fat: Double { get }
    var confidence: Double { get }
    var matchedIngredientID: String? { get }

    var isValid: Bool { get }
    var nutritionalSummary: String { get }

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
        matchedIngredientID: String?
    ) throws
}
```

### Validation Rules

**Preconditions**:
- `quantity > 0`
- `!foodName.isEmpty`
- `calories >= 0`
- `protein >= 0`
- `carbohydrates >= 0`
- `fat >= 0`
- `confidence >= 0 && confidence <= 1`

**Postconditions**:
- `id` is unique UUID
- `timestamp` is valid Date
- All nutritional values are non-negative

### Error Handling

```swift
enum FoodEntryValidationError: Error {
    case invalidQuantity
    case emptyFoodName
    case negativeNutrition
    case invalidConfidence
}
```

## DailyTotal API Contract

### Interface Definition

```swift
public protocol DailyTotalProtocol {
    var id: UUID { get }
    var date: Date { get }
    var totalCalories: Double { get }
    var totalProtein: Double { get }
    var totalCarbohydrates: Double { get }
    var totalFat: Double { get }
    var entryCount: Int { get }
    var entries: [FoodEntryProtocol] { get }

    var averageConfidence: Double { get }
    var hasEntries: Bool { get }
    var dateString: String { get }

    init(date: Date)

    func addEntry(_ entry: FoodEntryProtocol) throws
    func removeEntry(_ entry: FoodEntryProtocol) throws
    func containsEntry(withId id: UUID) -> Bool
    func getEntry(withId id: UUID) -> FoodEntryProtocol?
}
```

### Validation Rules

**Preconditions**:
- `date` is valid Date (will be normalized to start of day)

**Postconditions**:
- `date` is normalized to midnight of the given date
- All totals are non-negative
- `entryCount` equals `entries.count`

### Business Rules

- Date normalization: `Calendar.current.startOfDay(for: date)`
- Automatic total recalculation on entry add/remove
- Cascade delete: removing DailyTotal removes all associated entries

## Ingredient API Contract

### Interface Definition

```swift
public protocol IngredientProtocol {
    var id: String { get }
    var name: String { get }
    var aliases: [String] { get }
    var caloriesPer100g: Double { get }
    var proteinPer100g: Double { get }
    var carbsPer100g: Double { get }
    var fatPer100g: Double { get }
    var fiberPer100g: Double? { get }
    var sugarPer100g: Double? { get }
    var commonServingSize: Double { get }
    var commonServingUnit: String { get }
    var category: IngredientCategory { get }
    var source: DataSource { get }
    var verificationStatus: VerificationStatus { get }
    var usageCount: Int { get }

    var isVerified: Bool { get }
    var displayName: String { get }
    var nutritionalInfoPer100g: NutritionalInfo { get }

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
    ) throws

    func incrementUsage()
    func addAlias(_ alias: String)
    func matches(searchTerm: String) -> Bool
}
```

### Supporting Types

```swift
public struct NutritionalInfo {
    public let calories: Double
    public let protein: Double
    public let carbs: Double
    public let fat: Double
    public let fiber: Double?
    public let sugar: Double?
}

public enum IngredientCategory: String, CaseIterable {
    case protein, vegetable, fruit, grain, dairy, fat, beverage, snack, condiment
}

public enum DataSource: String, CaseIterable {
    case usda, nutritionix, custom, userContributed
}

public enum VerificationStatus: String, CaseIterable {
    case verified, pending, unverified
}
```

### Validation Rules

**Preconditions**:
- `!id.isEmpty`
- `!name.isEmpty`
- All nutritional values >= 0
- `commonServingSize > 0`

**Postconditions**:
- `id` is unique across all ingredients
- `aliases` contains only lowercase strings
- `usageCount >= 0`

## Repository Contracts

### FoodEntryRepository Contract

```swift
public protocol FoodEntryRepositoryProtocol {
    func create(_ entry: FoodEntryProtocol) async throws -> FoodEntryProtocol
    func fetch(byId id: UUID) async throws -> FoodEntryProtocol?
    func fetch(forDate date: Date) async throws -> [FoodEntryProtocol]
    func fetchToday() async throws -> [FoodEntryProtocol]
    func update(_ entry: FoodEntryProtocol) async throws
    func delete(_ entry: FoodEntryProtocol) async throws
    func deleteAll(forDate date: Date) async throws
}
```

### DailyTotalRepository Contract

```swift
public protocol DailyTotalRepositoryProtocol {
    func create(forDate date: Date) async throws -> DailyTotalProtocol
    func fetch(byId id: UUID) async throws -> DailyTotalProtocol?
    func fetch(forDate date: Date) async throws -> DailyTotalProtocol?
    func fetch(inRange range: ClosedRange<Date>) async throws -> [DailyTotalProtocol]
    func update(_ total: DailyTotalProtocol) async throws
    func delete(_ total: DailyTotalProtocol) async throws
    func getOrCreate(forDate date: Date) async throws -> DailyTotalProtocol
}
```

### IngredientRepository Contract

```swift
public protocol IngredientRepositoryProtocol {
    func create(_ ingredient: IngredientProtocol) async throws -> IngredientProtocol
    func fetch(byId id: String) async throws -> IngredientProtocol?
    func fetch(byName name: String) async throws -> [IngredientProtocol]
    func search(query: String, category: IngredientCategory?) async throws -> [IngredientProtocol]
    func fetchVerified() async throws -> [IngredientProtocol]
    func fetchPopular(limit: Int) async throws -> [IngredientProtocol]
    func update(_ ingredient: IngredientProtocol) async throws
    func delete(_ ingredient: IngredientProtocol) async throws
}
```

## Data Transfer Objects (DTOs)

### FoodEntryDTO

```swift
public struct FoodEntryDTO: Codable {
    public let id: UUID
    public let timestamp: Date
    public let rawDescription: String
    public let foodName: String
    public let quantity: Double
    public let unit: String
    public let calories: Double
    public let protein: Double
    public let carbohydrates: Double
    public let fat: Double
    public let confidence: Double
    public let matchedIngredientID: String?

    public init(from entry: FoodEntryProtocol) {
        self.id = entry.id
        self.timestamp = entry.timestamp
        self.rawDescription = entry.rawDescription
        self.foodName = entry.foodName
        self.quantity = entry.quantity
        self.unit = entry.unit
        self.calories = entry.calories
        self.protein = entry.protein
        self.carbohydrates = entry.carbohydrates
        self.fat = entry.fat
        self.confidence = entry.confidence
        self.matchedIngredientID = entry.matchedIngredientID
    }
}
```

### DailyTotalDTO

```swift
public struct DailyTotalDTO: Codable {
    public let id: UUID
    public let date: Date
    public let totalCalories: Double
    public let totalProtein: Double
    public let totalCarbohydrates: Double
    public let totalFat: Double
    public let entryCount: Int
    public let averageConfidence: Double

    public init(from total: DailyTotalProtocol) {
        self.id = total.id
        self.date = total.date
        self.totalCalories = total.totalCalories
        self.totalProtein = total.totalProtein
        self.totalCarbohydrates = total.totalCarbohydrates
        self.totalFat = total.totalFat
        self.entryCount = total.entryCount
        self.averageConfidence = total.averageConfidence
    }
}
```

### IngredientDTO

```swift
public struct IngredientDTO: Codable {
    public let id: String
    public let name: String
    public let aliases: [String]
    public let caloriesPer100g: Double
    public let proteinPer100g: Double
    public let carbsPer100g: Double
    public let fatPer100g: Double
    public let fiberPer100g: Double?
    public let sugarPer100g: Double?
    public let commonServingSize: Double
    public let commonServingUnit: String
    public let category: IngredientCategory
    public let source: DataSource
    public let verificationStatus: VerificationStatus
    public let usageCount: Int

    public init(from ingredient: IngredientProtocol) {
        self.id = ingredient.id
        self.name = ingredient.name
        self.aliases = ingredient.aliases
        self.caloriesPer100g = ingredient.caloriesPer100g
        self.proteinPer100g = ingredient.proteinPer100g
        self.carbsPer100g = ingredient.carbsPer100g
        self.fatPer100g = ingredient.fatPer100g
        self.fiberPer100g = ingredient.fiberPer100g
        self.sugarPer100g = ingredient.sugarPer100g
        self.commonServingSize = ingredient.commonServingSize
        self.commonServingUnit = ingredient.commonServingUnit
        self.category = ingredient.category
        self.source = ingredient.source
        self.verificationStatus = ingredient.verificationStatus
        self.usageCount = ingredient.usageCount
    }
}
```

## Error Contracts

```swift
public enum ModelError: Error {
    case validationError(String)
    case notFound(String)
    case duplicateEntry(String)
    case relationshipError(String)
    case persistenceError(String)
}
```

## Testing Contracts

### Unit Test Requirements

- All models must pass validation with valid data
- Invalid data must throw appropriate validation errors
- Relationships must maintain referential integrity
- Computed properties must return correct values
- Business logic methods must behave as specified

### Integration Test Requirements

- Repository operations must persist data correctly
- Queries must return expected results
- Concurrent operations must be thread-safe
- Memory management must prevent leaks

## Performance Contracts

- Model instantiation: < 1ms
- Validation: < 100μs
- Repository queries: < 10ms for typical datasets
- Aggregation calculations: < 1ms for 100 entries
- Memory footprint: < 1KB per model instance