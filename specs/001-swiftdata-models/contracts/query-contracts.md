# Query API Contracts

**Feature**: 001-swiftdata-models
**Date**: 2025-11-03

## Overview

This document defines the query contracts for efficient data retrieval from SwiftData models. These contracts specify query patterns, performance expectations, and optimization strategies for the Demeter application's data access layer.

## Query Categories

### 1. Real-time UI Queries

**Purpose**: Support live UI updates with minimal latency

#### Today's Food Entries Query

```swift
public protocol TodayEntriesQuery {
    var todayEntries: [FoodEntryProtocol] { get }

    func refreshTodayEntries() async throws
    func observeTodayEntries() -> AsyncStream<[FoodEntryProtocol]>
}
```

**Requirements**:
- Response time: < 100ms
- Update frequency: Real-time
- Ordering: By timestamp, descending
- Filter: Current day only

#### Current Daily Total Query

```swift
public protocol CurrentDailyTotalQuery {
    var currentTotal: DailyTotalProtocol? { get }

    func refreshCurrentTotal() async throws
    func observeCurrentTotal() -> AsyncStream<DailyTotalProtocol?>
}
```

**Requirements**:
- Response time: < 50ms
- Update frequency: Real-time
- Automatic aggregation recalculation

### 2. Calendar View Queries

**Purpose**: Support historical data display with lazy loading

#### Date Range Totals Query

```swift
public protocol DateRangeTotalsQuery {
    func fetchTotals(in range: ClosedRange<Date>) async throws -> [DailyTotalProtocol]
    func fetchTotals(for month: Date) async throws -> [DailyTotalProtocol]
    func fetchTotals(for year: Date) async throws -> [DailyTotalProtocol]
}
```

**Requirements**:
- Response time: < 500ms for 30 days
- Ordering: By date, descending
- Pagination: Support for large date ranges
- Memory efficient: Lazy loading of entries

#### Historical Entries Query

```swift
public protocol HistoricalEntriesQuery {
    func fetchEntries(for date: Date) async throws -> [FoodEntryProtocol]
    func fetchEntries(in range: ClosedRange<Date>) async throws -> [FoodEntryProtocol]
    func fetchRecentEntries(limit: Int) async throws -> [FoodEntryProtocol]
}
```

**Requirements**:
- Response time: < 200ms for single day
- Ordering: By timestamp, descending
- Optional: Include nutritional summaries

### 3. Ingredient Search Queries

**Purpose**: Support LLM context injection and user ingredient lookup

#### Fuzzy Search Query

```swift
public protocol IngredientSearchQuery {
    func searchIngredients(query: String) async throws -> [IngredientProtocol]
    func searchIngredients(query: String, category: IngredientCategory?) async throws -> [IngredientProtocol]
    func searchIngredients(query: String, limit: Int) async throws -> [IngredientProtocol]
}
```

**Requirements**:
- Response time: < 100ms
- Search fields: name, aliases
- Ranking: By usage count, then relevance
- Case insensitive fuzzy matching

#### Context Injection Query

```swift
public protocol LLMContextQuery {
    func fetchRelevantIngredients(for input: String) async throws -> [IngredientProtocol]
    func fetchIngredientsByIds(_ ids: [String]) async throws -> [IngredientProtocol]
    func fetchPopularIngredients(limit: Int) async throws -> [IngredientProtocol]
}
```

**Requirements**:
- Response time: < 50ms
- Max results: 20 ingredients
- Optimized for LLM prompt injection

### 4. Analytics Queries

**Purpose**: Support reporting and trend analysis

#### Nutritional Trends Query

```swift
public protocol NutritionalTrendsQuery {
    func averageDailyCalories(in range: ClosedRange<Date>) async throws -> Double
    func averageDailyMacros(in range: ClosedRange<Date>) async throws -> NutritionalSummary
    func mostConsumedIngredients(in range: ClosedRange<Date>, limit: Int) async throws -> [(IngredientProtocol, Int)]
}
```

**Requirements**:
- Response time: < 1s for 90 days
- Aggregation: Daily averages
- Memory efficient for large datasets

#### Usage Statistics Query

```swift
public protocol UsageStatsQuery {
    func totalEntries(in range: ClosedRange<Date>) async throws -> Int
    func averageConfidence(in range: ClosedRange<Date>) async throws -> Double
    func entriesByHourOfDay(in range: ClosedRange<Date>) async throws -> [Int: Int]
}
```

**Requirements**:
- Response time: < 2s for large ranges
- Aggregation: Statistical calculations
- Background processing for heavy queries

## Query Implementation Patterns

### SwiftData Query Examples

```swift
// Today's entries with real-time updates
@Query(
    filter: #Predicate<FoodEntry> { entry in
        entry.timestamp >= Calendar.current.startOfDay(for: Date())
    },
    sort: \FoodEntry.timestamp,
    order: .reverse
)
private var todayEntries: [FoodEntry]

// Date range totals with lazy loading
func fetchTotals(in range: ClosedRange<Date>) async throws -> [DailyTotal] {
    let predicate = #Predicate<DailyTotal> { total in
        total.date >= range.lowerBound && total.date <= range.upperBound
    }

    let descriptor = FetchDescriptor<DailyTotal>(
        predicate: predicate,
        sortBy: [SortDescriptor(\.date, order: .reverse)]
    )

    return try modelContext.fetch(descriptor)
}

// Fuzzy ingredient search
func searchIngredients(query: String) async throws -> [Ingredient] {
    let searchTerm = query.lowercased()
    let predicate = #Predicate<Ingredient> { ingredient in
        ingredient.name.localizedCaseInsensitiveContains(searchTerm) ||
        ingredient.aliases.contains { $0.localizedCaseInsensitiveContains(searchTerm) }
    }

    let descriptor = FetchDescriptor<Ingredient>(
        predicate: predicate,
        sortBy: [SortDescriptor(\.usageCount, order: .reverse)]
    )

    return try modelContext.fetch(descriptor)
}
```

## Performance Contracts

### Response Time Guarantees

| Query Type | Max Response Time | Typical Use Case |
|------------|------------------|------------------|
| Real-time UI | < 100ms | Current day display |
| Calendar view | < 500ms | Monthly history |
| Ingredient search | < 100ms | LLM context loading |
| Analytics | < 2s | Report generation |

### Memory Usage Limits

- Real-time queries: < 10MB working set
- Calendar queries: < 50MB for 1 year data
- Search queries: < 5MB result set
- Analytics queries: Background processing allowed

### Concurrency Requirements

- All queries must be thread-safe
- Read operations can run concurrently
- Write operations serialize through model context
- Background queries don't block UI

## Caching Strategy

### Query Result Caching

```swift
public protocol QueryCache {
    func get<T: Codable>(key: String) -> T?
    func set<T: Codable>(_ value: T, key: String, ttl: TimeInterval)
    func invalidate(pattern: String)
    func clear()
}
```

**Cache Policies**:
- Today's data: 5 minute TTL
- Calendar data: 1 hour TTL
- Ingredient search: 30 minute TTL
- Analytics: No cache (real-time)

### Cache Invalidation Triggers

- Food entry added/removed: Invalidate today totals
- Daily rollover: Invalidate date-based caches
- Ingredient updated: Invalidate search caches
- App background/foreground: Clear expired entries

## Error Handling

### Query Error Types

```swift
public enum QueryError: Error {
    case timeout(String)
    case invalidParameters(String)
    case databaseCorruption(String)
    case insufficientPermissions(String)
    case networkUnavailable(String) // For CloudKit queries
}
```

### Error Recovery Strategies

- Timeout: Retry with exponential backoff
- Invalid parameters: Validate inputs before query
- Database corruption: Fallback to in-memory mode
- Permissions: Request user authorization
- Network unavailable: Queue for retry when online

## Testing Contracts

### Query Test Requirements

- All queries must have unit tests
- Performance tests for response time guarantees
- Memory leak tests for long-running queries
- Concurrency tests for thread safety
- Error handling tests for failure scenarios

### Mock Data Requirements

- Test databases with realistic data volumes
- Pre-populated ingredient databases
- Historical food entry data spanning months
- Edge cases: empty results, large datasets, corrupted data

## Monitoring Contracts

### Query Metrics

- Response time percentiles (p50, p95, p99)
- Query success/failure rates
- Cache hit/miss ratios
- Memory usage during queries
- Concurrent query counts

### Alerting Thresholds

- p95 response time > 2x target: Warning
- Query failure rate > 5%: Alert
- Memory usage > 100MB: Warning
- Cache miss rate > 80%: Investigate