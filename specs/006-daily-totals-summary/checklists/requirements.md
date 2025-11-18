# Requirements Checklist: Daily Totals Summary Interface

**Feature**: Daily Totals Summary Interface  
**Spec**: [`specs/006-daily-totals-summary/spec.md`](../spec.md)  
**Status**: Draft

## Functional Requirements Checklist

### Display Components
- [ ] **FR-001**: System MUST display total calories for the current day prominently at the top of the screen with minimum 48pt font size
- [ ] **FR-002**: System MUST show current date clearly labeled as "Today" with the actual date (e.g., "Today • Nov 18")
- [ ] **FR-003**: System MUST display three macronutrient progress rings for protein, carbohydrates, and fat
- [ ] **FR-004**: System MUST show both consumed amounts and goal amounts for calories and each macronutrient
- [ ] **FR-005**: System MUST display remaining calories/macros until goal is reached
- [ ] **FR-006**: System MUST show a chronological list of all food entries logged today
- [ ] **FR-007**: Each food entry in the list MUST display food name, timestamp, and calorie count at minimum

### Progress Indicators
- [ ] **FR-008**: Calorie progress indicator MUST be a circular ring or linear progress bar showing percentage completion
- [ ] **FR-009**: Progress indicator MUST change color when goal is exceeded (e.g., green for on-track, orange/red for over)
- [ ] **FR-010**: Macronutrient rings MUST use distinct, accessible colors (meeting WCAG AA contrast requirements)
- [ ] **FR-011**: Each macro ring MUST display both gram amount and percentage of goal
- [ ] **FR-012**: Progress animations MUST complete within 500ms of data update
- [ ] **FR-013**: System MUST display "No goal set" state when user hasn't configured daily targets

### Real-Time Updates
- [ ] **FR-014**: System MUST update all totals within 100ms of new [`FoodEntry`](../../Demeter/Models/FoodEntry.swift) being saved
- [ ] **FR-015**: System MUST update progress indicators in real-time as entries are added or removed
- [ ] **FR-016**: System MUST refresh the entries list immediately when changes occur
- [ ] **FR-017**: System MUST recalculate all aggregated values from [`DailyTotal`](../../Demeter/Models/DailyTotal.swift) model
- [ ] **FR-018**: System MUST handle concurrent updates (multiple entries added rapidly) without data corruption

### Goal Management
- [ ] **FR-019**: System MUST provide interface to set daily calorie goal (range: 500-5000 calories)
- [ ] **FR-020**: System MUST allow setting individual macronutrient goals in grams
- [ ] **FR-021**: System MUST persist goal settings across app sessions
- [ ] **FR-022**: System MUST validate that macro goals are mathematically reasonable (protein + carbs × 4 + fat × 9 ≈ calorie goal)
- [ ] **FR-023**: System MUST allow users to edit goals at any time
- [ ] **FR-024**: System MUST support different goal types: deficit, maintenance, surplus (optional labels)

### Food Entries List
- [ ] **FR-025**: System MUST display entries in reverse chronological order (most recent first)
- [ ] **FR-026**: Each entry MUST be tappable to view full details or edit
- [ ] **FR-027**: System MUST support swipe-to-delete gesture for removing entries
- [ ] **FR-028**: System MUST show confirmation dialog before deleting an entry
- [ ] **FR-029**: System MUST display entry count (e.g., "5 entries today")
- [ ] **FR-030**: System MUST handle empty state with encouraging message to log first meal

### Quick Actions
- [ ] **FR-031**: System MUST provide prominent "Add Food" button accessible from summary view
- [ ] **FR-032**: Add button MUST launch voice input interface (from spec 004)
- [ ] **FR-033**: System MUST provide quick access to manual entry as alternative to voice
- [ ] **FR-034**: System MUST provide navigation to calendar/history view
- [ ] **FR-035**: System MUST provide access to settings/preferences

### Midnight Reset
- [ ] **FR-036**: System MUST automatically reset daily totals at midnight local time
- [ ] **FR-037**: System MUST archive previous day's data to [`DailyTotal`](../../Demeter/Models/DailyTotal.swift) before reset
- [ ] **FR-038**: System MUST handle timezone changes correctly for traveling users
- [ ] **FR-039**: System MUST display countdown or notice when reset is imminent (<15 minutes)
- [ ] **FR-040**: System MUST refresh UI automatically when midnight reset occurs

### Goal Achievement
- [ ] **FR-041**: System MUST display celebration animation when daily calorie goal is reached
- [ ] **FR-042**: System MUST show success indicator when all macro goals are met
- [ ] **FR-043**: Celebration MUST be brief (1-2 seconds) and non-intrusive
- [ ] **FR-044**: System MUST not repeat celebration if user exceeds goal multiple times in same day
- [ ] **FR-045**: System MUST provide positive feedback for goals within 5% of target

### Data Aggregation
- [ ] **FR-046**: System MUST aggregate all [`FoodEntry`](../../Demeter/Models/FoodEntry.swift) records for current day
- [ ] **FR-047**: System MUST calculate total calories by summing all entry calories
- [ ] **FR-048**: System MUST calculate total macros by summing protein, carbs, and fat separately
- [ ] **FR-049**: System MUST update [`DailyTotal`](../../Demeter/Models/DailyTotal.swift) model with aggregated values
- [ ] **FR-050**: System MUST handle floating-point precision correctly (round to 1 decimal place for display)

### Error Handling
- [ ] **FR-051**: System MUST handle missing [`DailyTotal`](../../Demeter/Models/DailyTotal.swift) record by creating one for current day
- [ ] **FR-052**: System MUST handle database query failures gracefully with error message
- [ ] **FR-053**: System MUST provide retry mechanism if data loading fails
- [ ] **FR-054**: System MUST handle invalid goal values (negative, zero, extreme) with validation messages
- [ ] **FR-055**: System MUST prevent division by zero when calculating percentages with zero goals

### Accessibility
- [ ] **FR-056**: All numerical values MUST have VoiceOver labels with units (e.g., "1,234 calories")
- [ ] **FR-057**: Progress indicators MUST announce percentage completion to VoiceOver users
- [ ] **FR-058**: System MUST support Dynamic Type scaling for all text (minimum Large, maximum AX5)
- [ ] **FR-059**: Color-coded progress states MUST have non-color alternatives (icons, text labels)
- [ ] **FR-060**: All interactive elements MUST meet minimum touch target size (44×44 points)
- [ ] **FR-061**: System MUST support Reduce Motion with alternative animations

### Performance
- [ ] **FR-062**: Initial view load MUST complete within 500ms on supported devices
- [ ] **FR-063**: Data aggregation MUST complete within 100ms for up to 100 entries per day
- [ ] **FR-064**: Progress ring animations MUST maintain 60fps on all supported devices
- [ ] **FR-065**: Memory footprint MUST remain under 50MB during normal operation
- [ ] **FR-066**: System MUST handle 1000+ historical [`DailyTotal`](../../Demeter/Models/DailyTotal.swift) records without performance degradation

## Success Criteria Checklist

- [ ] **SC-001**: Daily summary view loads and displays current totals within 500ms of app launch
- [ ] **SC-002**: Total calories are visible without scrolling on all supported device sizes (iPhone SE to Pro Max)
- [ ] **SC-003**: Users can understand their daily progress (calories and macros) within 3 seconds of viewing the summary
- [ ] **SC-004**: Progress indicators update within 100ms of new food entry being saved
- [ ] **SC-005**: Macronutrient ring animations complete smoothly at 60fps on all supported devices
- [ ] **SC-006**: 90% of users can successfully set their daily goals within 30 seconds
- [ ] **SC-007**: Users can add a new food entry within 2 taps from the daily summary view
- [ ] **SC-008**: Food entries list displays correctly with up to 50 entries without scrolling lag
- [ ] **SC-009**: Goal achievement celebration appears within 200ms of reaching target
- [ ] **SC-010**: VoiceOver users can navigate and understand all summary information with same comprehension as sighted users
- [ ] **SC-011**: All text remains readable at maximum Dynamic Type size (AX5) without truncation
- [ ] **SC-012**: Midnight reset completes within 1 second and updates UI automatically if app is open

## User Stories Validation

- [ ] **US-001**: View Current Day's Total Calories (P1) - Implemented and tested
- [ ] **US-002**: Track Progress Toward Daily Goal (P1) - Implemented and tested
- [ ] **US-003**: View Macronutrient Breakdown (P1) - Implemented and tested
- [ ] **US-004**: See Today's Food Entries List (P2) - Implemented and tested
- [ ] **US-005**: Quick Add New Entry (P1) - Implemented and tested
- [ ] **US-006**: Set and Adjust Daily Goals (P2) - Implemented and tested
- [ ] **US-007**: View Real-Time Updates (P1) - Implemented and tested
- [ ] **US-008**: Understand Daily Reset Timing (P3) - Implemented and tested
- [ ] **US-009**: Access Historical Data (P3) - Implemented and tested
- [ ] **US-010**: Celebrate Goal Achievement (P3) - Implemented and tested

## Edge Cases Validation

- [ ] Empty state (no food entries for today) handled correctly
- [ ] Extremely high daily totals (>10,000 calories) display properly
- [ ] Goal changes mid-day recalculate progress correctly
- [ ] Zero or very low goal values handled without errors
- [ ] Deleting all entries resets to empty state properly
- [ ] Timezone changes handled correctly for traveling users
- [ ] Midnight reset during active use updates UI automatically
- [ ] Fractional calories display correctly (rounded appropriately)
- [ ] Misaligned macro/calorie goals show validation warnings
- [ ] Long food entry names truncate or wrap appropriately
- [ ] Hundreds of entries in single day perform acceptably
- [ ] Negative remaining calories display clearly when over goal

## Dependencies Verification

- [ ] [`DailyTotal`](../../Demeter/Models/DailyTotal.swift) model available and functional
- [ ] [`FoodEntry`](../../Demeter/Models/FoodEntry.swift) model available and functional
- [ ] [`FoodEntryRepository`](../../Demeter/Repositories/FoodEntryRepository.swift) provides required query methods
- [ ] SwiftData persistence layer operational
- [ ] Voice Input interface (spec 004) accessible for adding entries
- [ ] Nutrition Display interface (spec 005) accessible for viewing details
- [ ] Background task service available for midnight reset
- [ ] Goal persistence mechanism (UserDefaults or SwiftData) implemented

## Testing Checklist

### Unit Tests
- [ ] DailyTotalsViewModel aggregation logic
- [ ] Progress percentage calculations
- [ ] Goal validation logic
- [ ] Remaining calories/macros calculations
- [ ] Midnight reset date handling
- [ ] Timezone conversion logic

### Integration Tests
- [ ] Loading today's DailyTotal from database
- [ ] Querying today's FoodEntry records
- [ ] Creating new DailyTotal when missing
- [ ] Updating DailyTotal when entries change
- [ ] Goal persistence and retrieval
- [ ] Real-time updates from database changes

### UI Tests
- [ ] Daily summary displays on app launch
- [ ] Add Food button launches voice input
- [ ] Progress rings animate correctly
- [ ] Food entries list scrolls smoothly
- [ ] Swipe-to-delete removes entries
- [ ] Goal setting flow completes successfully
- [ ] Celebration animation plays on goal achievement
- [ ] VoiceOver navigation works correctly
- [ ] Dynamic Type scaling works at all sizes

### Performance Tests
- [ ] View loads within 500ms
- [ ] Aggregation completes within 100ms for 100 entries
- [ ] Animations maintain 60fps
- [ ] Memory stays under 50MB
- [ ] No performance degradation with 1000+ historical records

## Documentation Checklist

- [ ] User-facing documentation for daily summary view
- [ ] Goal setting instructions
- [ ] Explanation of progress indicators
- [ ] Midnight reset behavior documented
- [ ] Accessibility features documented
- [ ] API documentation for DailyTotalsViewModel
- [ ] Code comments for complex calculations

## Review Checklist

- [ ] Specification reviewed by product owner
- [ ] Technical approach reviewed by development team
- [ ] Accessibility requirements reviewed by accessibility expert
- [ ] Performance targets validated as achievable
- [ ] Dependencies confirmed available
- [ ] Edge cases comprehensively covered
- [ ] Success criteria measurable and realistic

---

**Completion Status**: 0/66 Functional Requirements, 0/12 Success Criteria

**Last Updated**: 2025-11-18