# Feature Specification: Daily Totals Summary Interface

**Feature Branch**: `006-daily-totals-summary`  
**Created**: 2025-11-18  
**Status**: Draft  
**Input**: User description: "Create a feature specification for the Daily Totals Summary interface of the Demeter iOS calorie tracking app. Build the daily summary view that displays aggregated nutritional totals for the current day with progress indicators toward user goals."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Current Day's Total Calories (Priority: P1)

As a user, I want to see my total calories consumed today displayed prominently when I open the app so that I can immediately understand my daily progress.

**Why this priority**: This is the primary value proposition of the app - showing users their daily calorie intake at a glance. Without this, the app has no core functionality.

**Independent Test**: Can be fully tested by opening the app and verifying that today's total calories appear prominently at the top of the screen, updating in real-time as new entries are added.

**Acceptance Scenarios**:

1. **Given** I have logged 3 meals today totaling 1,200 calories, **When** I open the app, **Then** "1,200 cal" is displayed prominently at the top of the screen
2. **Given** I have not logged any food today, **When** I open the app, **Then** "0 cal" is displayed with a message encouraging me to log my first meal
3. **Given** I add a new 400-calorie meal, **When** the entry is saved, **Then** the total updates to "1,600 cal" within 100ms

---

### User Story 2 - Track Progress Toward Daily Goal (Priority: P1)

As a user, I want to see my progress toward my daily calorie goal with a visual indicator so that I can understand how much I have left to consume.

**Why this priority**: Goal tracking is essential for users managing their calorie intake. Visual progress indicators provide instant understanding and motivation.

**Independent Test**: Can be fully tested by setting a daily goal of 2,000 calories, logging meals, and verifying that a progress indicator shows percentage completion and remaining calories.

**Acceptance Scenarios**:

1. **Given** my daily goal is 2,000 calories and I've consumed 1,200, **When** I view the summary, **Then** a progress indicator shows 60% completion with "800 cal remaining"
2. **Given** I've consumed 2,100 calories against a 2,000 goal, **When** I view the summary, **Then** the indicator shows 105% with "100 cal over goal" in a different color
3. **Given** I haven't set a daily goal, **When** I view the summary, **Then** only total calories are shown with a prompt to "Set your daily goal"

---

### User Story 3 - View Macronutrient Breakdown (Priority: P1)

As a user, I want to see my daily totals for protein, carbohydrates, and fat with visual progress rings so that I can track my macronutrient balance.

**Why this priority**: Many users track macros in addition to calories. Visual rings provide instant understanding of nutritional balance.

**Independent Test**: Can be fully tested by logging meals with known macros and verifying that three circular progress rings display protein, carbs, and fat with both gram amounts and goal percentages.

**Acceptance Scenarios**:

1. **Given** I've consumed 80g protein, 150g carbs, 50g fat, **When** I view the summary, **Then** three progress rings show these values with distinct colors
2. **Given** I have macro goals set (100g protein, 200g carbs, 60g fat), **When** I view the rings, **Then** each shows percentage completion (80%, 75%, 83%)
3. **Given** I exceed a macro goal, **When** displayed, **Then** that ring shows >100% with the excess amount clearly indicated

---

### User Story 4 - See Today's Food Entries List (Priority: P2)

As a user, I want to see a chronological list of all food entries I've logged today so that I can review what I've eaten and when.

**Why this priority**: Users need to verify their entries and understand their eating patterns throughout the day. Essential for accuracy and awareness.

**Independent Test**: Can be fully tested by logging multiple meals at different times and verifying they appear in reverse chronological order with timestamps and nutritional summaries.

**Acceptance Scenarios**:

1. **Given** I've logged breakfast, lunch, and a snack, **When** I view the entries list, **Then** they appear in reverse chronological order (most recent first)
2. **Given** an entry in the list, **When** displayed, **Then** it shows the food name, time logged, and calorie count
3. **Given** I tap on an entry, **When** selected, **Then** I can view full nutritional details or edit/delete the entry

---

### User Story 5 - Quick Add New Entry (Priority: P1)

As a user, I want a prominent button to quickly add a new food entry so that I can log meals with minimal friction.

**Why this priority**: The primary user action is adding food entries. This must be immediately accessible and obvious.

**Independent Test**: Can be fully tested by tapping the add button and verifying it launches the voice input interface or manual entry screen.

**Acceptance Scenarios**:

1. **Given** I'm viewing the daily summary, **When** I tap the "Add Food" button, **Then** the voice input interface opens immediately
2. **Given** the add button is visible, **When** displayed, **Then** it's prominently positioned (bottom center or top right) and clearly labeled
3. **Given** I'm in the middle of the screen, **When** I need to add food, **Then** the button is reachable with one thumb on all device sizes

---

### User Story 6 - Set and Adjust Daily Goals (Priority: P2)

As a user, I want to set my daily calorie and macronutrient goals so that I can track progress toward my personal targets.

**Why this priority**: Goal setting enables personalized tracking. Users have different targets based on their health objectives.

**Independent Test**: Can be fully tested by tapping a "Set Goals" button, entering calorie and macro targets, and verifying they persist and display correctly.

**Acceptance Scenarios**:

1. **Given** I haven't set goals, **When** I tap "Set Goals", **Then** a form appears to enter daily calorie and macro targets
2. **Given** I enter a 2,000 calorie goal with 150g protein, 200g carbs, 65g fat, **When** I save, **Then** these goals appear in the summary view
3. **Given** I want to adjust my goals, **When** I tap the goals section, **Then** I can edit the values and save changes

---

### User Story 7 - View Real-Time Updates (Priority: P1)

As a user, I want the daily summary to update immediately when I add or delete food entries so that I always see accurate current totals.

**Why this priority**: Real-time updates build trust and provide instant feedback. Stale data would undermine the app's value.

**Independent Test**: Can be fully tested by adding a food entry and verifying that all totals, progress indicators, and the entries list update within 100ms.

**Acceptance Scenarios**:

1. **Given** I add a 500-calorie meal, **When** saved, **Then** total calories increase by 500 within 100ms
2. **Given** I delete an entry, **When** confirmed, **Then** totals decrease immediately and the entry disappears from the list
3. **Given** I edit an entry's quantity, **When** saved, **Then** all affected totals recalculate and update instantly

---

### User Story 8 - Understand Daily Reset Timing (Priority: P3)

As a user, I want to see when my daily totals will reset so that I understand the tracking period and can plan accordingly.

**Why this priority**: Users need to understand that totals reset at midnight. This prevents confusion about why yesterday's data isn't visible.

**Independent Test**: Can be fully tested by viewing the summary and verifying that a subtle indicator shows "Resets at midnight" or similar messaging.

**Acceptance Scenarios**:

1. **Given** I'm viewing the daily summary, **When** displayed, **Then** a small text indicator shows "Today • Resets at midnight"
2. **Given** it's 11:45 PM, **When** I view the summary, **Then** a countdown or notice indicates the reset is approaching
3. **Given** midnight passes while I'm using the app, **When** the reset occurs, **Then** totals reset to zero and yesterday's data is archived

---

### User Story 9 - Access Historical Data (Priority: P3)

As a user, I want to quickly navigate to previous days' summaries so that I can review my eating history and track trends.

**Why this priority**: Historical context helps users understand patterns and make better decisions. Supports long-term tracking goals.

**Independent Test**: Can be fully tested by tapping a calendar or history button and verifying that previous days' summaries are accessible.

**Acceptance Scenarios**:

1. **Given** I'm viewing today's summary, **When** I tap the calendar icon, **Then** a calendar view appears showing days with logged entries
2. **Given** I select yesterday's date, **When** tapped, **Then** that day's summary loads with all entries and totals
3. **Given** I'm viewing a past day, **When** displayed, **Then** it's clearly labeled with the date and marked as read-only

---

### User Story 10 - Celebrate Goal Achievement (Priority: P3)

As a user, I want visual feedback when I reach my daily calorie goal so that I feel motivated and rewarded for meeting my target.

**Why this priority**: Positive reinforcement increases engagement and helps users stay motivated. Gamification element enhances user experience.

**Independent Test**: Can be fully tested by reaching exactly the daily goal and verifying that a celebration animation or message appears.

**Acceptance Scenarios**:

1. **Given** my goal is 2,000 calories and I log an entry that brings me to exactly 2,000, **When** saved, **Then** a brief celebration animation plays (confetti, checkmark, etc.)
2. **Given** I've reached my goal, **When** displayed, **Then** the progress indicator shows 100% with a success color (green)
3. **Given** I exceed my goal by a small amount (<5%), **When** displayed, **Then** I still see positive feedback rather than a warning

---

### Edge Cases

- What happens when the user has no food entries for today (empty state)?
- How does system handle extremely high daily totals (>10,000 calories)?
- What happens when user changes their goal mid-day after already logging entries?
- How does system display progress when goals are set to zero or very low values?
- What happens when user deletes all entries for the day?
- How does system handle timezone changes (traveling users)?
- What happens when midnight reset occurs while user is actively viewing the summary?
- How does system display fractional calories (e.g., 1,234.5 calories)?
- What happens when macronutrient goals don't align with calorie goals mathematically?
- How does system handle very long food entry names in the list?
- What happens when user has hundreds of entries in a single day?
- How does system display negative remaining calories when significantly over goal?

## Requirements *(mandatory)*

### Functional Requirements

#### Display Components

- **FR-001**: System MUST display total calories for the current day prominently at the top of the screen with minimum 48pt font size
- **FR-002**: System MUST show current date clearly labeled as "Today" with the actual date (e.g., "Today • Nov 18")
- **FR-003**: System MUST display three macronutrient progress rings for protein, carbohydrates, and fat
- **FR-004**: System MUST show both consumed amounts and goal amounts for calories and each macronutrient
- **FR-005**: System MUST display remaining calories/macros until goal is reached
- **FR-006**: System MUST show a chronological list of all food entries logged today
- **FR-007**: Each food entry in the list MUST display food name, timestamp, and calorie count at minimum

#### Progress Indicators

- **FR-008**: Calorie progress indicator MUST be a circular ring or linear progress bar showing percentage completion
- **FR-009**: Progress indicator MUST change color when goal is exceeded (e.g., green for on-track, orange/red for over)
- **FR-010**: Macronutrient rings MUST use distinct, accessible colors (meeting WCAG AA contrast requirements)
- **FR-011**: Each macro ring MUST display both gram amount and percentage of goal
- **FR-012**: Progress animations MUST complete within 500ms of data update
- **FR-013**: System MUST display "No goal set" state when user hasn't configured daily targets

#### Real-Time Updates

- **FR-014**: System MUST update all totals within 100ms of new [`FoodEntry`](Demeter/Models/FoodEntry.swift) being saved
- **FR-015**: System MUST update progress indicators in real-time as entries are added or removed
- **FR-016**: System MUST refresh the entries list immediately when changes occur
- **FR-017**: System MUST recalculate all aggregated values from [`DailyTotal`](Demeter/Models/DailyTotal.swift) model
- **FR-018**: System MUST handle concurrent updates (multiple entries added rapidly) without data corruption

#### Goal Management

- **FR-019**: System MUST provide interface to set daily calorie goal (range: 500-5000 calories)
- **FR-020**: System MUST allow setting individual macronutrient goals in grams
- **FR-021**: System MUST persist goal settings across app sessions
- **FR-022**: System MUST validate that macro goals are mathematically reasonable (protein + carbs × 4 + fat × 9 ≈ calorie goal)
- **FR-023**: System MUST allow users to edit goals at any time
- **FR-024**: System MUST support different goal types: deficit, maintenance, surplus (optional labels)

#### Food Entries List

- **FR-025**: System MUST display entries in reverse chronological order (most recent first)
- **FR-026**: Each entry MUST be tappable to view full details or edit
- **FR-027**: System MUST support swipe-to-delete gesture for removing entries
- **FR-028**: System MUST show confirmation dialog before deleting an entry
- **FR-029**: System MUST display entry count (e.g., "5 entries today")
- **FR-030**: System MUST handle empty state with encouraging message to log first meal

#### Quick Actions

- **FR-031**: System MUST provide prominent "Add Food" button accessible from summary view
- **FR-032**: Add button MUST launch voice input interface (from spec 004)
- **FR-033**: System MUST provide quick access to manual entry as alternative to voice
- **FR-034**: System MUST provide navigation to calendar/history view
- **FR-035**: System MUST provide access to settings/preferences

#### Midnight Reset

- **FR-036**: System MUST automatically reset daily totals at midnight local time
- **FR-037**: System MUST archive previous day's data to [`DailyTotal`](Demeter/Models/DailyTotal.swift) before reset
- **FR-038**: System MUST handle timezone changes correctly for traveling users
- **FR-039**: System MUST display countdown or notice when reset is imminent (<15 minutes)
- **FR-040**: System MUST refresh UI automatically when midnight reset occurs

#### Goal Achievement

- **FR-041**: System MUST display celebration animation when daily calorie goal is reached
- **FR-042**: System MUST show success indicator when all macro goals are met
- **FR-043**: Celebration MUST be brief (1-2 seconds) and non-intrusive
- **FR-044**: System MUST not repeat celebration if user exceeds goal multiple times in same day
- **FR-045**: System MUST provide positive feedback for goals within 5% of target

#### Data Aggregation

- **FR-046**: System MUST aggregate all [`FoodEntry`](Demeter/Models/FoodEntry.swift) records for current day
- **FR-047**: System MUST calculate total calories by summing all entry calories
- **FR-048**: System MUST calculate total macros by summing protein, carbs, and fat separately
- **FR-049**: System MUST update [`DailyTotal`](Demeter/Models/DailyTotal.swift) model with aggregated values
- **FR-050**: System MUST handle floating-point precision correctly (round to 1 decimal place for display)

#### Error Handling

- **FR-051**: System MUST handle missing [`DailyTotal`](Demeter/Models/DailyTotal.swift) record by creating one for current day
- **FR-052**: System MUST handle database query failures gracefully with error message
- **FR-053**: System MUST provide retry mechanism if data loading fails
- **FR-054**: System MUST handle invalid goal values (negative, zero, extreme) with validation messages
- **FR-055**: System MUST prevent division by zero when calculating percentages with zero goals

#### Accessibility

- **FR-056**: All numerical values MUST have VoiceOver labels with units (e.g., "1,234 calories")
- **FR-057**: Progress indicators MUST announce percentage completion to VoiceOver users
- **FR-058**: System MUST support Dynamic Type scaling for all text (minimum Large, maximum AX5)
- **FR-059**: Color-coded progress states MUST have non-color alternatives (icons, text labels)
- **FR-060**: All interactive elements MUST meet minimum touch target size (44×44 points)
- **FR-061**: System MUST support Reduce Motion with alternative animations

#### Performance

- **FR-062**: Initial view load MUST complete within 500ms on supported devices
- **FR-063**: Data aggregation MUST complete within 100ms for up to 100 entries per day
- **FR-064**: Progress ring animations MUST maintain 60fps on all supported devices
- **FR-065**: Memory footprint MUST remain under 50MB during normal operation
- **FR-066**: System MUST handle 1000+ historical [`DailyTotal`](Demeter/Models/DailyTotal.swift) records without performance degradation

### Key Entities

- **DailyTotalsView**: Main SwiftUI view displaying daily summary. Key attributes: dailyTotal, userGoals, entries, isLoading, selectedDate
- **DailyTotalsViewModel**: ObservableObject managing business logic. Key attributes: currentDayTotal, calorieGoal, macroGoals, foodEntries, progressPercentages
- **CalorieProgressView**: Circular or linear progress indicator for calories. Key attributes: current, goal, percentage, color, animationProgress
- **MacronutrientRingView**: Circular progress ring for individual macros. Key attributes: nutrient, current, goal, color, percentage
- **FoodEntryRowView**: List row component for food entries. Key attributes: entry, timestamp, calories, onTap, onDelete
- **GoalSettingsView**: Modal or sheet for setting daily goals. Key attributes: calorieGoal, proteinGoal, carbsGoal, fatGoal, onSave
- **EmptyStateView**: Placeholder when no entries exist. Key attributes: message, actionButton
- **UserGoals**: Data model for goal persistence. Key attributes: dailyCalories, dailyProtein, dailyCarbs, dailyFat, goalType

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Daily summary view loads and displays current totals within 500ms of app launch
- **SC-002**: Total calories are visible without scrolling on all supported device sizes (iPhone SE to Pro Max)
- **SC-003**: Users can understand their daily progress (calories and macros) within 3 seconds of viewing the summary
- **SC-004**: Progress indicators update within 100ms of new food entry being saved
- **SC-005**: Macronutrient ring animations complete smoothly at 60fps on all supported devices
- **SC-006**: 90% of users can successfully set their daily goals within 30 seconds
- **SC-007**: Users can add a new food entry within 2 taps from the daily summary view
- **SC-008**: Food entries list displays correctly with up to 50 entries without scrolling lag
- **SC-009**: Goal achievement celebration appears within 200ms of reaching target
- **SC-010**: VoiceOver users can navigate and understand all summary information with same comprehension as sighted users
- **SC-011**: All text remains readable at maximum Dynamic Type size (AX5) without truncation
- **SC-012**: Midnight reset completes within 1 second and updates UI automatically if app is open

## Assumptions

- [`DailyTotal`](Demeter/Models/DailyTotal.swift) model exists and correctly aggregates [`FoodEntry`](Demeter/Models/FoodEntry.swift) data
- [`FoodEntryRepository`](Demeter/Repositories/FoodEntryRepository.swift) provides query methods for today's entries
- Voice input interface (spec 004) is functional and accessible from this view
- Users understand basic nutritional concepts (calories, protein, carbs, fat)
- Users will set reasonable daily goals (not extreme values)
- Most users will log 3-10 entries per day (not hundreds)
- Users expect daily totals to reset at midnight local time
- Network connectivity is not required for viewing daily summary (local data only)
- Users have basic familiarity with circular progress indicators
- Goal settings are optional (app works without them, just shows totals)

## Dependencies

- [`DailyTotal`](Demeter/Models/DailyTotal.swift) model for aggregated daily data
- [`FoodEntry`](Demeter/Models/FoodEntry.swift) model for individual entries
- [`FoodEntryRepository`](Demeter/Repositories/FoodEntryRepository.swift) for data queries and persistence
- SwiftData for local persistence and queries
- SwiftUI for UI implementation
- Combine framework for reactive state management
- Voice Input interface (spec 004) for adding new entries
- Nutrition Display interface (spec 005) for viewing entry details
- Background task service for midnight reset (from constitution)
- UserDefaults or similar for goal persistence

## Out of Scope (Post-MVP)

- Weekly or monthly summary views
- Nutritional trends and analytics charts
- Comparison with previous days/weeks
- Meal timing analysis (breakfast, lunch, dinner categorization)
- Calorie burn tracking from exercise
- Net calorie calculations (consumed - burned)
- Integration with HealthKit for activity data
- Social features (sharing progress, challenges)
- Nutritionist recommendations based on patterns
- Meal planning and suggestions
- Recipe integration and meal prep tracking
- Barcode scanning from summary view
- Photo gallery of logged meals
- Export data to CSV or PDF
- Custom macro ratio presets (keto, paleo, etc.)
- Micronutrient tracking (vitamins, minerals, fiber)
- Water intake tracking
- Intermittent fasting timer integration

## Technical Notes

### Data Flow

```
App Launch
    ↓
Query Today's DailyTotal
    ↓
Load FoodEntry records for today
    ↓
Calculate aggregated totals
    ↓
Load user goals from preferences
    ↓
DailyTotalsView renders
    ↓
User adds new entry (spec 004)
    ↓
Entry saved to database
    ↓
DailyTotal updates automatically
    ↓
UI refreshes with new totals
```

### View Hierarchy

```
DailyTotalsView
├── NavigationBar
│   ├── DateLabel ("Today • Nov 18")
│   └── CalendarButton
├── ScrollView
│   ├── CaloriesSummaryCard
│   │   ├── TotalCaloriesLabel (48pt)
│   │   ├── CalorieProgressRing
│   │   └── RemainingCaloriesLabel
│   ├── MacronutrientSection
│   │   ├── ProteinRingView
│   │   ├── CarbsRingView
│   │   └── FatRingView
│   ├── GoalsSummaryCard (if goals set)
│   │   └── EditGoalsButton
│   ├── EntriesListHeader
│   │   └── EntryCountLabel
│   └── FoodEntriesList
│       └── FoodEntryRowView (foreach)
├── EmptyStateView (conditional)
└── FloatingActionButton ("Add Food")
```

### State Management

```swift
@Observable
class DailyTotalsViewModel {
    var dailyTotal: DailyTotal?
    var foodEntries: [FoodEntry] = []
    var calorieGoal: Double?
    var macroGoals: MacroGoals?
    var isLoading: Bool = false
    var errorMessage: String?
    
    // Computed properties
    var totalCalories: Double { dailyTotal?.totalCalories ?? 0 }
    var totalProtein: Double { dailyTotal?.totalProtein ?? 0 }
    var totalCarbs: Double { dailyTotal?.totalCarbohydrates ?? 0 }
    var totalFat: Double { dailyTotal?.totalFat ?? 0 }
    
    var calorieProgress: Double {
        guard let goal = calorieGoal, goal > 0 else { return 0 }
        return totalCalories / goal
    }
    
    var remainingCalories: Double {
        guard let goal = calorieGoal else { return 0 }
        return max(0, goal - totalCalories)
    }
}
```

### Animation Timing

- Ring fill animations: 500ms ease-in-out
- Celebration animation: 1500ms (500ms appear, 500ms hold, 500ms fade)
- Entry list updates: 300ms staggered (50ms delay between items)
- Goal achievement: 200ms scale-up, 1000ms hold, 300ms fade-out
- Midnight reset: 500ms cross-fade to new day
- Loading states: Continuous pulse animation

### Color Palette (Suggested)

- Primary (Calories): Brand color or blue (#007AFF)
- Protein: Blue (#007AFF)
- Carbohydrates: Orange (#FF9500)
- Fat: Yellow (#FFCC00)
- On Track: Green (#34C759)
- Over Goal: Orange (#FF9500)
- Significantly Over: Red (#FF3B30)
- Background: System background (adaptive)
- Card Background: Secondary system background

### Query Patterns

```swift
// Fetch today's DailyTotal
@Query(
    filter: #Predicate<DailyTotal> { total in
        total.date == Calendar.current.startOfDay(for: Date())
    }
)
var todayTotal: [DailyTotal]

// Fetch today's FoodEntry records
@Query(
    filter: #Predicate<FoodEntry> { entry in
        entry.timestamp >= Calendar.current.startOfDay(for: Date())
    },
    sort: \FoodEntry.timestamp,
    order: .reverse
)
var todayEntries: [FoodEntry]
```

### Goal Persistence

```swift
struct UserGoals: Codable {
    var dailyCalories: Double
    var dailyProtein: Double
    var dailyCarbs: Double
    var dailyFat: Double
    var goalType: GoalType // deficit, maintenance, surplus
    
    enum GoalType: String, Codable {
        case deficit, maintenance, surplus
    }
}

// Store in UserDefaults or SwiftData
@AppStorage("userGoals") private var goalsData: Data?
```

### Midnight Reset Implementation

```swift
// Background task scheduled via BGTaskScheduler
func performMidnightReset() async {
    // 1. Archive yesterday's DailyTotal (already exists)
    // 2. Create new DailyTotal for today
    let today = Calendar.current.startOfDay(for: Date())
    let newTotal = DailyTotal(date: today)
    modelContext.insert(newTotal)
    
    // 3. Notify UI to refresh
    await MainActor.run {
        NotificationCenter.default.post(name: .midnightReset, object: nil)
    }
}
```

## Related Specifications

- **spec-001**: SwiftData Models - Defines [`DailyTotal`](Demeter/Models/DailyTotal.swift) and [`FoodEntry`](Demeter/Models/FoodEntry.swift) models
- **spec-004**: Voice Input Interface - Primary method for adding new entries
- **spec-005**: Nutrition Display Interface - Shows detailed nutrition after voice input
- **spec-003**: Core Services Infrastructure - Background task service for midnight reset

## Open Questions

None - all critical aspects are specified with reasonable assumptions documented.