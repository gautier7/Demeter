# Implementation Tasks: SwiftData Models

**Feature**: 001-swiftdata-models
**Branch**: `001-swiftdata-models`
**Date**: 2025-11-03
**Spec**: [specs/001-swiftdata-models/spec.md](specs/001-swiftdata-models/spec.md)
**Plan**: [specs/001-swiftdata-models/plan.md](specs/001-swiftdata-models/plan.md)

## Overview

This document defines the concrete implementation tasks for the SwiftData Models feature. Tasks are organized by priority and dependency, with clear acceptance criteria and testing requirements.

## Task Organization

### Priority Levels
- **P1**: Core functionality, blocking dependencies
- **P2**: Supporting features, parallel development possible
- **P3**: Nice-to-have, can be deferred

### Dependencies
- Tasks are numbered sequentially within priority levels
- Higher priority tasks must be completed before lower priority ones
- Parallel tasks within the same priority level can be developed simultaneously

---

## P1 Tasks: Core Model Implementation

### Task P1-1: Implement FoodEntry Model
**Priority**: P1
**Estimated Effort**: 2-3 hours
**Dependencies**: None
**Assignee**: iOS Developer

**Description**:
Implement the FoodEntry SwiftData model with all required properties, relationships, and validation logic as defined in `data-model.md`.

**Acceptance Criteria**:
- [ ] FoodEntry model compiles without errors
- [ ] All properties defined with correct types and attributes
- [ ] @Relationship to DailyTotal implemented with correct inverse
- [ ] Validation logic implemented (quantity > 0, etc.)
- [ ] Unit tests pass for model creation and validation

**Implementation Steps**:
1. Create `Demeter/Models/FoodEntry.swift`
2. Implement @Model macro and all properties
3. Add relationship to DailyTotal
4. Implement validation computed property
5. Add unit tests

**Files to Create/Modify**:
- `Demeter/Models/FoodEntry.swift` (new)
- `Demeter/Tests/Models/FoodEntryTests.swift` (new)

### Task P1-2: Implement DailyTotal Model
**Priority**: P1
**Estimated Effort**: 2-3 hours
**Dependencies**: None
**Assignee**: iOS Developer

**Description**:
Implement the DailyTotal SwiftData model with aggregation logic and date normalization as defined in `data-model.md`.

**Acceptance Criteria**:
- [ ] DailyTotal model compiles without errors
- [ ] Date normalization logic implemented
- [ ] Aggregation methods work correctly
- [ ] Relationship to FoodEntry entries implemented
- [ ] Unit tests pass for aggregation logic

**Implementation Steps**:
1. Create `Demeter/Models/DailyTotal.swift`
2. Implement @Model macro and all properties
3. Add relationship to FoodEntry with cascade delete
4. Implement addEntry/removeEntry methods
5. Add automatic total recalculation
6. Add unit tests

**Files to Create/Modify**:
- `Demeter/Models/DailyTotal.swift` (new)
- `Demeter/Tests/Models/DailyTotalTests.swift` (new)

### Task P1-3: Implement Ingredient Model
**Priority**: P1
**Estimated Effort**: 2-3 hours
**Dependencies**: None
**Assignee**: iOS Developer

**Description**:
Implement the Ingredient SwiftData model with nutritional data and search capabilities as defined in `data-model.md`.

**Acceptance Criteria**:
- [ ] Ingredient model compiles without errors
- [ ] All nutritional properties implemented
- [ ] Supporting enums (IngredientCategory, DataSource, VerificationStatus) defined
- [ ] Search token logic implemented
- [ ] Unit tests pass for model creation and validation

**Implementation Steps**:
1. Create `Demeter/Models/Ingredient.swift`
2. Implement @Model macro and all properties
3. Define supporting enums
4. Implement computed properties (isVerified, displayName)
5. Add usage tracking methods
6. Add unit tests

**Files to Create/Modify**:
- `Demeter/Models/Ingredient.swift` (new)
- `Demeter/Tests/Models/IngredientTests.swift` (new)

### Task P1-4: Configure ModelContainer
**Priority**: P1
**Estimated Effort**: 1 hour
**Dependencies**: P1-1, P1-2, P1-3
**Assignee**: iOS Developer

**Description**:
Configure the SwiftData ModelContainer in the app delegate with all three models and CloudKit sync options.

**Acceptance Criteria**:
- [ ] ModelContainer configured in DemeterApp.swift
- [ ] All three models included in container
- [ ] CloudKit sync configured as optional
- [ ] App launches without SwiftData errors

**Implementation Steps**:
1. Update `Demeter/DemeterApp.swift`
2. Import SwiftData
3. Configure ModelContainer with all models
4. Add CloudKit configuration
5. Test app launch

**Files to Create/Modify**:
- `Demeter/DemeterApp.swift` (modify)

---

## P2 Tasks: Repository Pattern Implementation

### Task P2-1: Implement FoodEntryRepository
**Priority**: P2
**Estimated Effort**: 2-3 hours
**Dependencies**: P1-1, P1-4
**Assignee**: iOS Developer

**Description**:
Implement the FoodEntryRepository following the repository pattern for data access abstraction.

**Acceptance Criteria**:
- [ ] Repository protocol implemented
- [ ] CRUD operations implemented
- [ ] Query methods for today's entries work
- [ ] Error handling implemented
- [ ] Unit tests pass for all operations

**Implementation Steps**:
1. Create `Demeter/Services/Repository/FoodEntryRepository.swift`
2. Implement repository protocol
3. Add CRUD methods
4. Add query methods (fetchToday, etc.)
5. Add unit tests

**Files to Create/Modify**:
- `Demeter/Services/Repository/FoodEntryRepository.swift` (new)
- `Demeter/Tests/Services/Repository/FoodEntryRepositoryTests.swift` (new)

### Task P2-2: Implement DailyTotalRepository
**Priority**: P2
**Estimated Effort**: 2-3 hours
**Dependencies**: P1-2, P1-4
**Assignee**: iOS Developer

**Description**:
Implement the DailyTotalRepository for managing daily aggregations and historical data.

**Acceptance Criteria**:
- [ ] Repository protocol implemented
- [ ] Date-based query methods work
- [ ] getOrCreate pattern implemented
- [ ] Historical data queries work
- [ ] Unit tests pass for all operations

**Implementation Steps**:
1. Create `Demeter/Services/Repository/DailyTotalRepository.swift`
2. Implement repository protocol
3. Add date-based query methods
4. Implement getOrCreate pattern
5. Add unit tests

**Files to Create/Modify**:
- `Demeter/Services/Repository/DailyTotalRepository.swift` (new)
- `Demeter/Tests/Services/Repository/DailyTotalRepositoryTests.swift` (new)

### Task P2-3: Implement IngredientRepository
**Priority**: P2
**Estimated Effort**: 2-3 hours
**Dependencies**: P1-3, P1-4
**Assignee**: iOS Developer

**Description**:
Implement the IngredientRepository for ingredient database management and search.

**Acceptance Criteria**:
- [ ] Repository protocol implemented
- [ ] Fuzzy search functionality works
- [ ] Verification status filtering works
- [ ] Popular ingredients query works
- [ ] Unit tests pass for all operations

**Implementation Steps**:
1. Create `Demeter/Services/Repository/IngredientRepository.swift`
2. Implement repository protocol
3. Add search methods with fuzzy matching
4. Add filtering by verification status
5. Add unit tests

**Files to Create/Modify**:
- `Demeter/Services/Repository/IngredientRepository.swift` (new)
- `Demeter/Tests/Services/Repository/IngredientRepositoryTests.swift` (new)

---

## P3 Tasks: Advanced Features & Integration

### Task P3-1: Implement Query Property Wrappers
**Priority**: P3
**Estimated Effort**: 1-2 hours
**Dependencies**: P1-1, P1-2, P1-3, P1-4
**Assignee**: iOS Developer

**Description**:
Implement SwiftUI @Query property wrappers for reactive UI updates as defined in query contracts.

**Acceptance Criteria**:
- [ ] @Query for today's entries implemented
- [ ] @Query for current daily total implemented
- [ ] Reactive updates work in SwiftUI views
- [ ] Performance meets contract requirements (<100ms)

**Implementation Steps**:
1. Create view models with @Query properties
2. Implement reactive queries for UI
3. Test performance characteristics
4. Add integration tests

**Files to Create/Modify**:
- `Demeter/ViewModels/NutritionViewModel.swift` (new)
- `Demeter/Tests/ViewModels/NutritionViewModelTests.swift` (new)

### Task P3-2: Implement Data Migration Strategy
**Priority**: P3
**Estimated Effort**: 2-3 hours
**Dependencies**: P1-1, P1-2, P1-3
**Assignee**: iOS Developer

**Description**:
Implement SwiftData migration strategy for future model changes.

**Acceptance Criteria**:
- [ ] Versioned schema defined
- [ ] Migration logic implemented
- [ ] Backward compatibility maintained
- [ ] Migration tests pass

**Implementation Steps**:
1. Define SchemaV1 with current models
2. Implement migration logic if needed
3. Add migration tests
4. Document migration strategy

**Files to Create/Modify**:
- `Demeter/Models/Schema.swift` (new)
- `Demeter/Tests/Models/MigrationTests.swift` (new)

### Task P3-3: Implement Ingredient Database Seeding
**Priority**: P3
**Estimated Effort**: 2-3 hours
**Dependencies**: P1-3, P2-3
**Assignee**: iOS Developer

**Description**:
Implement initial seeding of the ingredient database with common foods as outlined in constitution.

**Acceptance Criteria**:
- [ ] 50+ common ingredients seeded
- [ ] Nutritional data accurate
- [ ] Categories properly assigned
- [ ] Seeding script runnable
- [ ] Duplicate prevention implemented

**Implementation Steps**:
1. Create `Demeter/Services/DatabaseSeeder.swift`
2. Define initial ingredient data
3. Implement seeding logic
4. Add duplicate prevention
5. Create seeding tests

**Files to Create/Modify**:
- `Demeter/Services/DatabaseSeeder.swift` (new)
- `Demeter/Tests/Services/DatabaseSeederTests.swift` (new)

---

## Testing Strategy

### Unit Testing Requirements
- **Coverage**: Minimum 80% for all model classes
- **Critical Paths**: 100% coverage for validation logic and aggregation methods
- **Performance**: All tests complete within 10 seconds

### Integration Testing Requirements
- **Repository Tests**: Full CRUD operations with in-memory store
- **Query Performance**: Meet response time contracts
- **Concurrency**: Test thread safety for repository operations

### Test Files to Create
- `Demeter/Tests/Models/FoodEntryTests.swift`
- `Demeter/Tests/Models/DailyTotalTests.swift`
- `Demeter/Tests/Models/IngredientTests.swift`
- `Demeter/Tests/Services/Repository/FoodEntryRepositoryTests.swift`
- `Demeter/Tests/Services/Repository/DailyTotalRepositoryTests.swift`
- `Demeter/Tests/Services/Repository/IngredientRepositoryTests.swift`

---

## Success Criteria Verification

### Measurable Outcomes (from spec.md)
- [ ] **SC-001**: All three SwiftData models can be instantiated with valid data and persist correctly
- [ ] **SC-002**: DailyTotal model accurately aggregates nutritional data from 100+ FoodEntry records within 1 second
- [ ] **SC-003**: Ingredient model supports complete nutritional profiles for 1000+ different food items
- [ ] **SC-004**: FoodEntry model validates input data and prevents invalid records
- [ ] **SC-005**: Models maintain referential integrity across relationships

### Performance Benchmarks
- Model instantiation: < 1ms
- Validation: < 100μs
- Repository queries: < 10ms for typical datasets
- Aggregation: < 1ms for 100 entries

---

## Risk Mitigation

### Technical Risks
- **SwiftData Compatibility**: Test on iOS 18.0+ devices/simulators
- **Migration Complexity**: Plan for schema changes early
- **Performance Degradation**: Monitor query performance during development

### Timeline Risks
- **Dependency Management**: Complete P1 tasks before starting P2
- **Testing Overhead**: Allocate sufficient time for comprehensive testing
- **Integration Issues**: Test early and often with dependent features

---

## Definition of Done

A task is complete when:
- [ ] Code compiles without warnings or errors
- [ ] Unit tests pass with >80% coverage
- [ ] Integration tests pass
- [ ] Code review completed and approved
- [ ] Documentation updated
- [ ] Acceptance criteria met
- [ ] Performance requirements satisfied

## Next Steps

After completing all P1 tasks:
1. Run integration tests to verify model relationships work correctly
2. Begin P2 repository implementation
3. Update dependent features (LLM service, UI components) to use new models
4. Consider P3 tasks based on timeline and priorities

## Dependencies on Other Features

- **LLM Service**: Will use Ingredient model for context injection
- **Speech Recognition**: Will create FoodEntry records
- **UI Components**: Will query models for display
- **Background Tasks**: Will use DailyTotal for midnight reset

---

*This tasks document is generated from the implementation plan and feature specification. Updates should be made through the /speckit.tasks command.*