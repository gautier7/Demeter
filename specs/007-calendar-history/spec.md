# Feature Specification: Calendar History Interface

**Feature Branch**: `007-calendar-history`  
**Created**: 2025-11-18  
**Status**: Draft  
**Input**: User description: "Create a feature specification for the Calendar History interface of the Demeter iOS calorie tracking app. Build the historical data calendar view that allows users to browse and review their past nutritional data."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Current Month Calendar (Priority: P1)

As a user, I want to see a calendar view of the current month with visual indicators on days where I logged food so that I can quickly identify my tracking consistency.

**Why this priority**: This is the primary entry point for historical data access. Users need to see their tracking patterns at a glance to understand their consistency and identify gaps.

**Independent Test**: Can be fully tested by opening the calendar view and verifying that the current month displays with visual indicators (dots, colors, or badges) on days with food entries.

**Acceptance Scenarios**:

1. **Given** I open the calendar history view, **When** the calendar loads, **Then** the current month is displayed with today's date highlighted
2. **Given** I have logged food on 15 days this month, **When** viewing the calendar, **Then** those 15 days show visual indicators (colored dots or badges)
3. **Given** I have not logged food on certain days, **When** viewing the calendar, **Then** those days appear without indicators (empty state)

---

### User Story 2 - See Goal Achievement at a Glance (Priority: P1)

As a user, I want days in the calendar to be color-coded based on whether I met, exceeded, or fell short of my daily calorie goal so that I can quickly assess my progress patterns.

**Why this priority**: Visual color coding provides instant pattern recognition. Users can identify successful days versus challenging days without tapping into details.

**Independent Test**: Can be fully tested by viewing a month with mixed goal achievement and verifying that days use distinct colors: green for goal met, yellow for close, red for significantly over/under.

**Acceptance Scenarios**:

1. **Given** I met my calorie goal on a day, **When** viewing the calendar, **Then** that day displays with a green indicator
2. **Given** I exceeded my goal by >10% on a day, **When** viewing the calendar, **Then** that day displays with an orange/red indicator
3. **Given** I was within 5% of my goal, **When** viewing the calendar, **Then** that day displays with a yellow indicator
4. **Given** I have no goal set, **When** viewing the calendar, **Then** days with entries show a neutral blue indicator

---

### User Story 3 - Navigate Between Months (Priority: P1)

As a user, I want to swipe or tap to navigate between months so that I can review my historical data from previous weeks and months.

**Why this priority**: Historical review is the core purpose of this feature. Users need fluid navigation to explore their eating patterns over time.

**Independent Test**: Can be fully tested by swiping left/right or tapping navigation arrows and verifying that the calendar transitions smoothly to previous/next months.

**Acceptance Scenarios**:

1. **Given** I'm viewing the current month, **When** I swipe left, **Then** the calendar transitions to the previous month
2. **Given** I'm viewing a past month, **When** I swipe right, **Then** the calendar transitions to the next month
3. **Given** I'm viewing any month, **When** I tap the month/year header, **Then** a month picker appears for quick navigation
4. **Given** I navigate to a past month, **When** displayed, **Then** the month/year label clearly shows which month I'm viewing

---

### User Story 4 - View Day Details (Priority: P1)

As a user, I want to tap on any day with entries to see the detailed nutritional breakdown and food list for that day so that I can review what I ate.

**Why this priority**: Accessing detailed historical data is essential for understanding past eating patterns and making informed decisions.

**Independent Test**: Can be fully tested by tapping a day with entries and verifying that a detail view appears showing that day's total calories, macros, and complete food entry list.

**Acceptance Scenarios**:

1. **Given** I tap a day with food entries, **When** the detail view opens, **Then** I see that day's total calories prominently displayed
2. **Given** the day detail view is open, **When** displayed, **Then** I see macronutrient breakdown (protein, carbs, fat) with progress rings
3. **Given** the day detail view is open, **When** I scroll down, **Then** I see a chronological list of all food entries for that day
4. **Given** I'm viewing day details, **When** I tap the back button, **Then** I return to the calendar view

---

### User Story 5 - Quick Jump to Today (Priority: P2)

As a user, I want a "Today" button that instantly returns me to the current month and highlights today's date so that I can quickly navigate back from historical browsing.

**Why this priority**: Users exploring historical data need a quick way to return to the present. Prevents getting lost in past months.

**Independent Test**: Can be fully tested by navigating to a past month, tapping the "Today" button, and verifying that the calendar jumps to the current month with today highlighted.

**Acceptance Scenarios**:

1. **Given** I'm viewing a past month, **When** I tap the "Today" button, **Then** the calendar animates to the current month
2. **Given** the calendar returns to current month, **When** displayed, **Then** today's date is highlighted with a distinct visual indicator
3. **Given** I'm already viewing the current month, **When** I tap "Today", **Then** the view scrolls to ensure today is visible

---

### User Story 6 - See Entry Count on Calendar Days (Priority: P2)

As a user, I want to see the number of food entries I logged on each day directly on the calendar so that I can identify days with multiple meals versus single entries.

**Why this priority**: Entry count provides additional context about tracking completeness. Helps users identify days where they may have missed logging meals.

**Independent Test**: Can be fully tested by viewing the calendar and verifying that days display a small badge or number indicating entry count (e.g., "3" for three entries).

**Acceptance Scenarios**:

1. **Given** I logged 5 entries on a day, **When** viewing the calendar, **Then** that day shows "5" or a badge with the count
2. **Given** I logged only 1 entry on a day, **When** viewing the calendar, **Then** that day shows "1" or a single dot
3. **Given** days have varying entry counts, **When** viewing the calendar, **Then** I can quickly distinguish high-activity days from low-activity days

---

### User Story 7 - Edit Historical Entries (Priority: P2)

As a user, I want to edit or delete food entries from past days so that I can correct mistakes or update information I forgot to log.

**Why this priority**: Users discover errors or remember forgotten meals. Allowing historical edits maintains data accuracy and user trust.

**Independent Test**: Can be fully tested by opening a past day's details, tapping an entry, editing its values, and verifying the changes persist and update the day's totals.

**Acceptance Scenarios**:

1. **Given** I'm viewing a past day's details, **When** I tap on a food entry, **Then** I can edit the quantity and nutritional values
2. **Given** I edit an entry's quantity, **When** I save, **Then** the day's total calories and macros recalculate automatically
3. **Given** I want to remove an entry, **When** I swipe left on it, **Then** a delete button appears with confirmation dialog
4. **Given** I delete an entry, **When** confirmed, **Then** it's removed and the day's totals update immediately

---

### User Story 8 - Add Entries to Past Days (Priority: P3)

As a user, I want to add food entries to past days so that I can log meals I forgot to track at the time.

**Why this priority**: Users sometimes forget to log meals in real-time. Allowing retroactive logging maintains complete historical records.

**Independent Test**: Can be fully tested by opening a past day's details, tapping "Add Entry", logging a meal, and verifying it appears in that day's list with updated totals.

**Acceptance Scenarios**:

1. **Given** I'm viewing a past day's details, **When** I tap "Add Entry", **Then** the voice input or manual entry interface opens
2. **Given** I add an entry to a past day, **When** saved, **Then** it appears in that day's entry list with the correct date
3. **Given** I add an entry to a past day, **When** saved, **Then** that day's [`DailyTotal`](Demeter/Models/DailyTotal.swift) updates with the new values
4. **Given** I return to the calendar view, **When** displayed, **Then** the past day's indicator updates to reflect the new entry

---

### User Story 9 - View Weekly Summary (Priority: P3)

As a user, I want to see a weekly summary view showing average calories and goal achievement rate so that I can understand my weekly patterns.

**Why this priority**: Weekly patterns are more meaningful than daily fluctuations. Helps users identify trends and make adjustments.

**Independent Test**: Can be fully tested by switching to week view and verifying that a summary card shows average daily calories, total entries, and goal achievement percentage for the week.

**Acceptance Scenarios**:

1. **Given** I switch to week view, **When** displayed, **Then** I see 7 days in a row with visual indicators
2. **Given** the week view is shown, **When** displayed, **Then** a summary card shows "Avg: 1,850 cal/day" and "Goal met: 5/7 days"
3. **Given** I tap on a day in week view, **When** selected, **Then** the day detail view opens with full information

---

### User Story 10 - Search Historical Entries (Priority: P3)

As a user, I want to search my historical food entries by food name so that I can find when I last ate a specific item or review my consumption patterns.

**Why this priority**: Search enables users to answer questions like "When did I last eat pizza?" or "How often do I eat chicken?" Valuable for pattern analysis.

**Independent Test**: Can be fully tested by entering a food name in the search field and verifying that matching entries appear with their dates and nutritional information.

**Acceptance Scenarios**:

1. **Given** I tap the search icon, **When** a search field appears, **Then** I can type a food name
2. **Given** I search for "chicken", **When** results appear, **Then** I see all entries containing "chicken" with dates and calories
3. **Given** search results are shown, **When** I tap a result, **Then** I navigate to that day's detail view with the entry highlighted
4. **Given** no matches are found, **When** displayed, **Then** I see "No entries found for 'xyz'" with suggestion to try different terms

---

### Edge Cases

- What happens when viewing a month with no food entries (empty month)?
- How does system handle leap years and varying month lengths?
- What happens when user changes timezone while viewing historical data?
- How does system display days that span midnight (late-night entries)?
- What happens when user has hundreds of entries in a single day?
- How does system handle very old historical data (>1 year ago)?
- What happens when user deletes all entries for a day that previously had data?
- How does system display partial days (e.g., started tracking mid-day)?
- What happens when goal settings change mid-month (affects color coding)?
- How does system handle concurrent edits to the same historical day?
- What happens when calendar view is open during midnight reset?
- How does system display days with only deleted/archived entries?

## Requirements *(mandatory)*

### Functional Requirements

#### Calendar Display

- **FR-001**: System MUST display a monthly calendar grid showing all days of the current month
- **FR-002**: System MUST highlight today's date with a distinct visual indicator (border, background color)
- **FR-003**: System MUST show visual indicators (dots, badges, colors) on days with food entries
- **FR-004**: System MUST display month and year label prominently at the top of the calendar
- **FR-005**: System MUST show day-of-week labels (S M T W T F S) above the calendar grid
- **FR-006**: System MUST handle months with varying lengths (28-31 days) correctly
- **FR-007**: System MUST display days from previous/next month in muted colors to fill the grid

#### Visual Indicators

- **FR-008**: System MUST use color coding to indicate goal achievement status on calendar days
- **FR-009**: Green indicator MUST be used for days where calorie goal was met (within 5%)
- **FR-010**: Yellow indicator MUST be used for days within 5-10% of goal
- **FR-011**: Orange/red indicator MUST be used for days >10% over or under goal
- **FR-012**: Blue/neutral indicator MUST be used for days with entries but no goal set
- **FR-013**: System MUST display entry count badge on days with multiple entries
- **FR-014**: System MUST use distinct visual style for days without any entries (empty state)
- **FR-015**: System MUST meet WCAG AA contrast requirements for all color indicators

#### Navigation

- **FR-016**: System MUST support swipe gestures to navigate between months (left for previous, right for next)
- **FR-017**: System MUST provide arrow buttons for month navigation as alternative to swipe
- **FR-018**: System MUST animate month transitions smoothly (300-500ms)
- **FR-019**: System MUST provide "Today" button to jump to current month
- **FR-020**: System MUST allow tapping month/year header to open month/year picker
- **FR-021**: Month picker MUST allow quick selection of any month within past 2 years
- **FR-022**: System MUST preserve scroll position when returning from day detail view

#### Day Detail View

- **FR-023**: System MUST open day detail view when user taps a day with entries
- **FR-024**: Day detail view MUST display the selected date prominently (e.g., "Monday, Nov 18, 2024")
- **FR-025**: Day detail view MUST show total calories for that day with large typography
- **FR-026**: Day detail view MUST display macronutrient breakdown with progress rings
- **FR-027**: Day detail view MUST show chronological list of all [`FoodEntry`](Demeter/Models/FoodEntry.swift) records for that day
- **FR-028**: Each entry in the list MUST display food name, timestamp, and calorie count
- **FR-029**: Day detail view MUST show goal achievement status if goal was set for that day
- **FR-030**: System MUST provide "Add Entry" button in day detail view for past days

#### Historical Data Loading

- **FR-031**: System MUST lazy load [`DailyTotal`](Demeter/Models/DailyTotal.swift) data only for visible months
- **FR-032**: System MUST query SwiftData for date range covering displayed month
- **FR-033**: System MUST cache loaded month data to avoid redundant queries
- **FR-034**: System MUST load calendar indicators within 500ms of month display
- **FR-035**: System MUST handle missing [`DailyTotal`](Demeter/Models/DailyTotal.swift) records gracefully (show empty state)
- **FR-036**: System MUST support pagination for months beyond 30-day MVP scope

#### Editing Historical Entries

- **FR-037**: System MUST allow editing [`FoodEntry`](Demeter/Models/FoodEntry.swift) records from past days
- **FR-038**: System MUST allow deleting [`FoodEntry`](Demeter/Models/FoodEntry.swift) records from past days
- **FR-039**: System MUST show confirmation dialog before deleting historical entries
- **FR-040**: System MUST recalculate [`DailyTotal`](Demeter/Models/DailyTotal.swift) when entries are edited or deleted
- **FR-041**: System MUST update calendar indicators immediately after edits
- **FR-042**: System MUST preserve edit history or audit trail (optional for MVP)

#### Adding to Historical Days

- **FR-043**: System MUST allow adding new [`FoodEntry`](Demeter/Models/FoodEntry.swift) records to past days
- **FR-044**: System MUST set entry timestamp to selected historical date, not current time
- **FR-045**: System MUST create [`DailyTotal`](Demeter/Models/DailyTotal.swift) record if none exists for selected date
- **FR-046**: System MUST update calendar view after adding entry to past day
- **FR-047**: System MUST prevent adding entries to future dates

#### Empty States

- **FR-048**: System MUST display encouraging message when viewing month with no entries
- **FR-049**: System MUST show "No entries for this day" when tapping empty calendar day
- **FR-050**: Empty day detail MUST provide "Add Entry" button to start logging
- **FR-051**: System MUST display "Start tracking" prompt for users with no historical data

#### Search and Filtering

- **FR-052**: System MUST provide search interface to find entries by food name
- **FR-053**: Search MUST query across all historical [`FoodEntry`](Demeter/Models/FoodEntry.swift) records
- **FR-054**: Search results MUST display entry date, food name, and calories
- **FR-055**: System MUST support filtering by date range (e.g., "Last 7 days", "This month")
- **FR-056**: System MUST support filtering by goal achievement (met, exceeded, under)
- **FR-057**: Filters MUST update calendar indicators in real-time

#### Weekly View

- **FR-058**: System MUST provide toggle to switch between month and week view
- **FR-059**: Week view MUST display 7 days in a horizontal row with indicators
- **FR-060**: Week view MUST show summary statistics (average calories, goal achievement rate)
- **FR-061**: System MUST allow swiping between weeks in week view
- **FR-062**: Week view MUST highlight current day if viewing current week

#### Timezone Handling

- **FR-063**: System MUST display historical data in the timezone where it was logged
- **FR-064**: System MUST handle timezone changes correctly for traveling users
- **FR-065**: System MUST normalize all dates to midnight in local timezone for [`DailyTotal`](Demeter/Models/DailyTotal.swift)
- **FR-066**: System MUST display timezone indicator if entry was logged in different timezone

#### Performance

- **FR-067**: Calendar view MUST load and display within 500ms
- **FR-068**: Month navigation MUST complete within 300ms
- **FR-069**: Day detail view MUST load within 300ms
- **FR-070**: System MUST handle 365+ days of historical data without performance degradation
- **FR-071**: Calendar scrolling MUST maintain 60fps on all supported devices
- **FR-072**: System MUST limit memory footprint to <75MB when viewing historical data

#### Accessibility

- **FR-073**: All calendar days MUST be accessible via VoiceOver with date and status announced
- **FR-074**: Color-coded indicators MUST have non-color alternatives (icons, patterns)
- **FR-075**: System MUST support Dynamic Type scaling for all text elements
- **FR-076**: Calendar navigation MUST be keyboard accessible (for external keyboards)
- **FR-077**: All interactive elements MUST meet minimum touch target size (44x44 points)
- **FR-078**: System MUST support Reduce Motion with alternative animations
- **FR-079**: VoiceOver MUST announce entry counts and goal status for each day

#### Error Handling

- **FR-080**: System MUST handle database query failures gracefully with error message
- **FR-081**: System MUST provide retry mechanism if data loading fails
- **FR-082**: System MUST handle corrupted [`DailyTotal`](Demeter/Models/DailyTotal.swift) records without crashing
- **FR-083**: System MUST validate date ranges to prevent invalid queries
- **FR-084**: System MUST handle concurrent edits to same day with conflict resolution

### Key Entities

- **CalendarHistoryView**: Main SwiftUI view displaying calendar grid. Key attributes: currentMonth, selectedDate, dailyTotals, viewMode (month/week)
- **CalendarDayCell**: Individual day cell component. Key attributes: date, hasEntries, entryCount, goalStatus, isToday, isSelected
- **DayDetailView**: Detail view for selected day. Key attributes: date, dailyTotal, entries, canEdit, showAddButton
- **HistoryViewModel**: ObservableObject managing business logic. Key attributes: visibleMonths, cachedTotals, selectedDate, searchQuery, filters
- **MonthData**: Data model for month display. Key attributes: month, year, days, dailyTotals, statistics
- **GoalStatus**: Enum for goal achievement. Values: met, close, over, under, noGoal, noEntries
- **CalendarViewMode**: Enum for view types. Values: month, week, list
- **HistoryFilter**: Data model for filtering. Key attributes: dateRange, goalStatus, minCalories, maxCalories

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Calendar view loads and displays current month within 500ms of navigation
- **SC-002**: Users can identify days with food entries within 2 seconds of viewing calendar
- **SC-003**: Goal achievement patterns are visually apparent within 3 seconds of viewing month
- **SC-004**: Users can navigate to any day within past 30 days in under 3 taps
- **SC-005**: Month transitions animate smoothly at 60fps on all supported devices
- **SC-006**: Day detail view loads within 300ms of tapping a calendar day
- **SC-007**: Users can edit a historical entry and see updated totals within 5 seconds
- **SC-008**: "Today" button returns to current month within 500ms from any past month
- **SC-009**: Calendar displays correctly for all months including February in leap years
- **SC-010**: VoiceOver users can navigate calendar and understand all information with same comprehension as sighted users
- **SC-011**: Search returns results within 1 second for queries across 365 days of data
- **SC-012**: System handles 1000+ historical [`DailyTotal`](Demeter/Models/DailyTotal.swift) records without performance degradation

## Assumptions

- [`DailyTotal`](Demeter/Models/DailyTotal.swift) model exists with date normalized to midnight
- [`FoodEntry`](Demeter/Models/FoodEntry.swift) records have accurate timestamps
- Users understand calendar navigation patterns (swipe, tap)
- Most users will review history within past 30 days (MVP scope)
- Users have set daily calorie goals (optional, affects color coding)
- Historical data is immutable except for explicit user edits
- Network connectivity is not required (all data is local)
- Users understand color coding conventions (green=good, red=warning)
- Calendar starts week on Sunday (configurable post-MVP)
- Users will not have more than 50 entries per day typically

## Dependencies

- [`DailyTotal`](Demeter/Models/DailyTotal.swift) model for aggregated daily data
- [`FoodEntry`](Demeter/Models/FoodEntry.swift) model for individual entries
- [`FoodEntryRepository`](Demeter/Repositories/FoodEntryRepository.swift) for data queries
- SwiftData for persistence and date-based queries
- SwiftUI for calendar UI implementation
- Combine framework for reactive state management
- Daily Totals Summary view (spec 006) for consistent day detail display
- Voice Input interface (spec 004) for adding entries to past days
- Background task service for midnight reset (from constitution)

## Out of Scope (Post-MVP)

- Monthly and yearly summary statistics
- Nutritional trends and analytics charts
- Streak tracking and gamification
- Comparison between different time periods
- Export historical data to CSV or PDF
- Sync historical data across devices (iCloud)
- Meal timing analysis and patterns
- Calorie burn tracking integration
- Net calorie calculations (consumed - burned)
- Social features (sharing progress, challenges)
- Nutritionist consultation based on history
- Meal planning based on historical preferences
- Recipe suggestions from past meals
- Barcode scanning from historical view
- Photo gallery of past meals
- Custom date range selection beyond 30 days
- Advanced filtering (by ingredient, meal type, etc.)
- Data visualization (graphs, charts, heatmaps)
- Predictive analytics and recommendations
- Integration with health tracking devices

## Technical Notes

### Data Flow

```
User opens Calendar History
    ↓
Query DailyTotal for current month
    ↓
Load calendar indicators
    ↓
CalendarHistoryView renders
    ↓
User taps a day
    ↓
Query FoodEntry for selected date
    ↓
DayDetailView displays
    ↓
User edits/adds entry
    ↓
Update DailyTotal
    ↓
Refresh calendar indicators
```

### View Hierarchy

```
CalendarHistoryView
├── NavigationBar
│   ├── MonthYearLabel (tappable)
│   ├── PreviousMonthButton
│   ├── NextMonthButton
│   └── TodayButton
├── ViewModeToggle (Month/Week)
├── CalendarGrid
│   ├── DayOfWeekHeader
│   └── CalendarDayCell (foreach day)
│       ├── DayNumber
│       ├── EntryIndicator (dot/badge)
│       └── GoalStatusColor
├── MonthStatistics (optional)
│   ├── TotalEntriesLabel
│   ├── AverageCaloriesLabel
│   └── GoalAchievementRate
└── SearchBar (optional)

DayDetailView (Sheet/Navigation)
├── DateHeader
├── TotalCaloriesCard
├── MacronutrientRings (x3)
├── EntriesList
│   └── FoodEntryRow (foreach)
├── AddEntryButton (for past days)
└── CloseButton
```

### Query Patterns

```swift
// Fetch DailyTotals for a month
@Query(
    filter: #Predicate<DailyTotal> { total in
        total.date >= startOfMonth && total.date <= endOfMonth
    },
    sort: \DailyTotal.date
)
var monthTotals: [DailyTotal]

// Fetch FoodEntries for a specific day
@Query(
    filter: #Predicate<FoodEntry> { entry in
        entry.timestamp >= startOfDay && entry.timestamp < startOfNextDay
    },
    sort: \FoodEntry.timestamp
)
var dayEntries: [FoodEntry]

// Search entries by food name
@Query(
    filter: #Predicate<FoodEntry> { entry in
        entry.foodName.localizedStandardContains(searchTerm)
    },
    sort: \FoodEntry.timestamp,
    order: .reverse
)
var searchResults: [FoodEntry]
```

### Goal Status Calculation

```swift
enum GoalStatus {
    case met        // Within 5% of goal
    case close      // Within 5-10% of goal
    case over       // >10% over goal
    case under      // >10% under goal
    case noGoal     // No goal set
    case noEntries  // No entries for day
    
    static func calculate(calories: Double, goal: Double?) -> GoalStatus {
        guard let goal = goal, goal > 0 else { return .noGoal }
        guard calories > 0 else { return .noEntries }
        
        let percentage = calories / goal
        switch percentage {
        case 0.95...1.05: return .met
        case 0.90...0.95, 1.05...1.10: return .close
        case 1.10...: return .over
        default: return .under
        }
    }
}
```

### Color Palette

- Goal Met: Green (#34C759)
- Goal Close: Yellow (#FFCC00)
- Goal Over: Orange (#FF9500)
- Goal Under: Red (#FF3B30)
- No Goal: Blue (#007AFF)
- No Entries: Gray (#8E8E93)
- Today Highlight: Brand color or blue
- Selected Day: Secondary brand color
- Past Month Days: Gray (50% opacity)

### Animation Timing

- Month transition: 300ms ease-in-out
- Day cell tap: 200ms scale animation
- Indicator appearance: 400ms staggered (50ms delay per day)
- Day detail sheet: 300ms slide-up
- Goal status color change: 200ms cross-fade
- Loading skeleton: Continuous pulse
- Search results: 300ms fade-in

### Caching Strategy

```swift
actor HistoryCache {
    private var monthCache: [String: MonthData] = [:]
    private let maxCachedMonths = 6
    
    func getMonth(year: Int, month: Int) -> MonthData? {
        let key = "\(year)-\(month)"
        return monthCache[key]
    }
    
    func setMonth(year: Int, month: Int, data: MonthData) {
        let key = "\(year)-\(month)"
        if monthCache.count >= maxCachedMonths {
            // Remove oldest cached month
            let oldestKey = monthCache.keys.sorted().first
            monthCache.removeValue(forKey: oldestKey!)
        }
        monthCache[key] = data
    }
}
```

### Lazy Loading Implementation

```swift
class HistoryViewModel: ObservableObject {
    @Published var visibleMonths: [MonthData] = []
    private let cache = HistoryCache()
    
    func loadMonth(year: Int, month: Int) async {
        // Check cache first
        if let cached = await cache.getMonth(year: year, month: month) {
            await MainActor.run {
                self.visibleMonths.append(cached)
            }
            return
        }
        
        // Query database
        let startDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))!
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
        
        let descriptor = FetchDescriptor<DailyTotal>(
            predicate: #Predicate { $0.date >= startDate && $0.date < endDate },
            sortBy: [SortDescriptor(\.date)]
        )
        
        let totals = try? modelContext.fetch(descriptor)
        let monthData = MonthData(year: year, month: month, dailyTotals: totals ?? [])
        
        // Cache and update
        await cache.setMonth(year: year, month: month, data: monthData)
        await MainActor.run {
            self.visibleMonths.append(monthData)
        }
    }
}
```

## Related Specifications

- **spec-001**: SwiftData Models - Defines [`DailyTotal`](Demeter/Models/DailyTotal.swift) and [`FoodEntry`](Demeter/Models/FoodEntry.swift) models
- **spec-006**: Daily Totals Summary - Day detail view reuses similar components
- **spec-004**: Voice Input Interface - Used for adding entries to past days
- **spec-005**: Nutrition Display - Used when editing historical entries
- **spec-003**: Core Services Infrastructure - Background task service for midnight reset

## Open Questions

None - all critical aspects are specified with reasonable assumptions documented.