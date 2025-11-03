# Feature Specification: SwiftData Models

**Feature Branch**: `001-swiftdata-models`
**Created**: 2025-11-03
**Status**: Draft
**Input**: User description: "I want to add the SwiftData Models FoodEntry DailyTotal and Ingredient"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Define FoodEntry Model (Priority: P1)

As a developer, I want to define a FoodEntry model that represents individual food consumption records so that I can store and manage food intake data.

**Why this priority**: This is the core data model that other models will depend on, establishing the foundation for food tracking functionality.

**Independent Test**: Can be fully tested by creating a FoodEntry instance with valid data and verifying all properties are correctly set and persisted.

**Acceptance Scenarios**:

1. **Given** no existing FoodEntry, **When** creating a new FoodEntry with valid food name, quantity, and timestamp, **Then** the entry should be successfully created with all properties populated
2. **Given** a FoodEntry instance, **When** accessing its properties, **Then** all required attributes should be accessible and return expected values

---

### User Story 2 - Define DailyTotal Model (Priority: P2)

As a developer, I want to define a DailyTotal model that aggregates food entries for a specific date so that I can track daily nutritional summaries.

**Why this priority**: Provides the aggregation layer needed for daily reporting and analytics, building on the FoodEntry foundation.

**Independent Test**: Can be fully tested by creating a DailyTotal instance and associating it with multiple FoodEntry records, then verifying the total calculations are accurate.

**Acceptance Scenarios**:

1. **Given** multiple FoodEntry records for the same date, **When** creating a DailyTotal, **Then** it should correctly aggregate the total calories and other nutritional values
2. **Given** a DailyTotal instance, **When** adding or removing FoodEntry records, **Then** the totals should update automatically

---

### User Story 3 - Define Ingredient Model (Priority: P3)

As a developer, I want to define an Ingredient model that represents nutritional information for food components so that I can build a database of food nutritional data.

**Why this priority**: Enables the system to have a reference database of ingredients with their nutritional profiles, supporting food entry creation.

**Independent Test**: Can be fully tested by creating an Ingredient instance with nutritional data and verifying all nutritional properties are correctly stored and retrievable.

**Acceptance Scenarios**:

1. **Given** nutritional data for a food item, **When** creating an Ingredient, **Then** all nutritional properties should be stored and accessible
2. **Given** an Ingredient instance, **When** retrieving its nutritional information, **Then** accurate values should be returned for calories, macronutrients, and micronutrients

---

### Edge Cases

- What happens when FoodEntry quantity is zero or negative?
- How does system handle DailyTotal calculations when no FoodEntry records exist for a date?
- What happens when Ingredient nutritional data is incomplete or invalid?
- How does system handle very large quantities in FoodEntry that might cause overflow in DailyTotal aggregations?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST define a FoodEntry model with properties for food name, quantity, unit of measure, timestamp, and nutritional information
- **FR-002**: System MUST define a DailyTotal model that aggregates nutritional data from multiple FoodEntry records for a specific date
- **FR-003**: System MUST define an Ingredient model containing nutritional information including calories, macronutrients (protein, carbs, fat), and micronutrients
- **FR-004**: FoodEntry model MUST support relationship to Ingredient model for nutritional data lookup
- **FR-005**: DailyTotal model MUST automatically calculate total nutritional values from associated FoodEntry records
- **FR-006**: All models MUST be compatible with SwiftData persistence framework for data storage and retrieval
- **FR-007**: Models MUST include appropriate unique identifiers for database relationships and querying
- **FR-008**: System MUST validate that FoodEntry quantities are positive values
- **FR-009**: DailyTotal MUST handle date-based grouping of FoodEntry records accurately
- **FR-010**: Ingredient model MUST support optional micronutrient data (vitamins, minerals)

### Key Entities *(include if feature involves data)*

- **FoodEntry**: Represents an individual food consumption record with quantity, timestamp, and nutritional data. Key attributes: id, foodName, quantity, unit, timestamp, calories, protein, carbs, fat, ingredientId
- **DailyTotal**: Represents aggregated nutritional data for a specific date. Key attributes: id, date, totalCalories, totalProtein, totalCarbs, totalFat, foodEntries (relationship)
- **Ingredient**: Represents nutritional information for a food component. Key attributes: id, name, caloriesPerUnit, proteinPerUnit, carbsPerUnit, fatPerUnit, unit, micronutrients (optional)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All three SwiftData models (FoodEntry, DailyTotal, Ingredient) can be instantiated with valid data and persist correctly in the database
- **SC-002**: DailyTotal model accurately aggregates nutritional data from 100+ FoodEntry records within 1 second
- **SC-003**: Ingredient model supports complete nutritional profiles including macronutrients and micronutrients for 1000+ different food items
- **SC-004**: FoodEntry model validates input data and prevents creation of records with invalid quantities or missing required fields
- **SC-005**: Models maintain referential integrity when FoodEntry records are associated with Ingredient and DailyTotal records
