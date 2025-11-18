# Requirements Checklist: Nutrition Display Interface

**Feature**: 005-nutrition-display  
**Status**: Draft  
**Last Updated**: 2025-11-18

## User Stories

### Priority 1 (Critical - MVP Blockers)

- [ ] **US-001**: View Parsed Nutrition Breakdown
  - [ ] Total calories displayed prominently at top
  - [ ] Macronutrients shown with grams and percentages
  - [ ] Multiple food items listed separately
  
- [ ] **US-002**: Understand Individual Food Items
  - [ ] Each food item shown as separate card
  - [ ] Food name, quantity, and unit displayed
  - [ ] Individual nutritional values per item
  
- [ ] **US-005**: See Processing States
  - [ ] Loading indicator appears immediately
  - [ ] Animated spinner during processing
  - [ ] Extended wait messaging after 3 seconds
  
- [ ] **US-007**: Confirm and Save Entry
  - [ ] Prominent "Add to Log" button
  - [ ] Success confirmation after save
  - [ ] Navigation back to main view

### Priority 2 (Important - Enhanced UX)

- [ ] **US-003**: See Confidence Indicators
  - [ ] Visual confidence indicators for each item
  - [ ] Color coding: green (high), yellow (medium), orange/red (low)
  - [ ] Tooltip explaining confidence scores
  
- [ ] **US-004**: View Macronutrient Visualization
  - [ ] Circular progress rings for protein, carbs, fat
  - [ ] Distinct colors for each macronutrient
  - [ ] Both gram amounts and percentages shown
  
- [ ] **US-006**: Edit Before Saving
  - [ ] Edit button enables modification
  - [ ] Quantity fields become editable
  - [ ] Real-time recalculation on changes

### Priority 3 (Nice to Have - Future Enhancement)

- [ ] **US-008**: Preview Daily Total Impact
  - [ ] Before/after comparison shown
  - [ ] Percentage of daily goal calculated
  - [ ] Warning if exceeding daily goal

## Functional Requirements

### Display Components (FR-001 to FR-006)

- [ ] **FR-001**: Total calories displayed prominently with large, bold typography
- [ ] **FR-002**: Macronutrient breakdown shows grams and percentages
- [ ] **FR-003**: Multiple food items listed separately
- [ ] **FR-004**: Food item name, quantity, and unit displayed
- [ ] **FR-005**: Individual nutritional values per food item
- [ ] **FR-006**: Confidence scores/indicators displayed

### Visual Hierarchy (FR-007 to FR-011)

- [ ] **FR-007**: Total calories use largest font size (minimum 32pt)
- [ ] **FR-008**: Macronutrient summary visible without scrolling
- [ ] **FR-009**: Food items displayed in card format with separation
- [ ] **FR-010**: Color coding for confidence levels implemented
- [ ] **FR-011**: Consistent spacing and alignment maintained

### Macronutrient Visualization (FR-012 to FR-016)

- [ ] **FR-012**: Circular progress rings for protein, carbs, fat
- [ ] **FR-013**: Distinct, accessible colors for each ring (WCAG AA)
- [ ] **FR-014**: Rings show percentage fill and numeric values
- [ ] **FR-015**: Ring animations complete within 500ms
- [ ] **FR-016**: Percentages calculated based on caloric contribution

### Loading and Processing States (FR-017 to FR-021)

- [ ] **FR-017**: Loading indicator appears immediately
- [ ] **FR-018**: Descriptive text: "Analyzing your meal..."
- [ ] **FR-019**: Animated spinner or progress indicator shown
- [ ] **FR-020**: Additional context after 3 seconds
- [ ] **FR-021**: Timeout handling (>10 seconds) with retry option

### Confidence Indicators (FR-022 to FR-027)

- [ ] **FR-022**: Confidence score displayed for each food item
- [ ] **FR-023**: Visual indicators (icons, colors) not just numeric
- [ ] **FR-024**: High confidence (>0.9) shows green checkmark
- [ ] **FR-025**: Medium confidence (0.7-0.9) shows yellow indicator
- [ ] **FR-026**: Low confidence (<0.7) shows warning indicator
- [ ] **FR-027**: Tooltip or info button explains confidence scores

### Editing Capabilities (FR-028 to FR-033)

- [ ] **FR-028**: "Edit" button enables modification
- [ ] **FR-029**: Quantity fields editable with numeric keyboard
- [ ] **FR-030**: Real-time recalculation when quantities change
- [ ] **FR-031**: Validation of edited values (no negatives, reasonable ranges)
- [ ] **FR-032**: Individual food item names editable
- [ ] **FR-033**: "Cancel" option discards edits

### Confirmation and Saving (FR-034 to FR-039)

- [ ] **FR-034**: Prominent "Add to Log" or "Save" button
- [ ] **FR-035**: Save button disabled during processing or if invalid
- [ ] **FR-036**: Success confirmation shown after saving
- [ ] **FR-037**: FoodEntry records created for each food item
- [ ] **FR-038**: DailyTotal updated atomically
- [ ] **FR-039**: Navigation back to main view after save

### Daily Total Preview (FR-040 to FR-044)

- [ ] **FR-040**: Preview of daily totals after adding entry
- [ ] **FR-041**: Before/after comparison displayed
- [ ] **FR-042**: Percentage of daily goal calculated if set
- [ ] **FR-043**: Warning shown if exceeding daily goal
- [ ] **FR-044**: Preview updates in real-time with edits

### Error Handling (FR-045 to FR-050)

- [ ] **FR-045**: Empty LLM responses handled with clear message
- [ ] **FR-046**: Malformed JSON responses handled gracefully
- [ ] **FR-047**: Missing confidence scores default to medium
- [ ] **FR-048**: Nutritional values validated (0-10000 calories per item)
- [ ] **FR-049**: "Try Again" option provided on failure
- [ ] **FR-050**: Original voice transcription preserved for retry

### Accessibility (FR-051 to FR-056)

- [ ] **FR-051**: VoiceOver labels with units for all values
- [ ] **FR-052**: Confidence indicators announced to VoiceOver
- [ ] **FR-053**: Dynamic Type scaling supported
- [ ] **FR-054**: Non-color alternatives for confidence indicators
- [ ] **FR-055**: Minimum touch target size (44x44 points)
- [ ] **FR-056**: Reduce Motion support with alternative animations

### Integration Requirements (FR-057 to FR-061)

- [ ] **FR-057**: NutritionData received from LLM service
- [ ] **FR-058**: FoodItem array parsed from LLM response
- [ ] **FR-059**: FoodEntry models created from parsed data
- [ ] **FR-060**: FoodEntryRepository used for persistence
- [ ] **FR-061**: DailyTotal updated through repository pattern

## Success Criteria

### Performance Metrics

- [ ] **SC-001**: Nutrition data appears within 100ms of LLM response
- [ ] **SC-002**: Total calories visible without scrolling on all devices
- [ ] **SC-004**: Ring animations at 60fps on all devices
- [ ] **SC-007**: Loading state appears within 100ms
- [ ] **SC-008**: Success confirmation visible for 1+ second
- [ ] **SC-009**: Daily preview updates within 50ms

### User Experience Metrics

- [ ] **SC-003**: Users identify all food items within 2 seconds
- [ ] **SC-005**: 90% of users interpret confidence indicators correctly
- [ ] **SC-006**: Users edit and save within 10 seconds
- [ ] **SC-012**: Error messages appear within 500ms with recovery actions

### Accessibility Metrics

- [ ] **SC-010**: VoiceOver users achieve same comprehension as sighted users
- [ ] **SC-011**: Text readable at maximum Dynamic Type (AX5) without truncation

## Edge Cases Validation

- [ ] Empty LLM response (no food items parsed)
- [ ] Extremely high calorie values (>5000 calories)
- [ ] Missing confidence scores from LLM
- [ ] Very small quantities (e.g., 1g of butter)
- [ ] Saving without reviewing data
- [ ] Partial/incomplete LLM responses
- [ ] Multiple food items with identical names
- [ ] Micronutrient data display (if available)
- [ ] Navigation away before saving
- [ ] Very long food names that don't fit UI

## Dependencies Verification

- [ ] NutritionData DTO structure matches LLM service output
- [ ] FoodEntry model available and functional
- [ ] DailyTotal model available and functional
- [ ] FoodEntryRepository implemented and tested
- [ ] LLMService integration complete
- [ ] Voice Input interface (spec 004) complete

## Testing Checklist

### Unit Tests

- [ ] NutritionDisplayViewModel state management
- [ ] Confidence level calculation and display logic
- [ ] Macronutrient percentage calculations
- [ ] Edit mode value validation
- [ ] Daily total preview calculations

### Integration Tests

- [ ] LLM response parsing to UI display
- [ ] FoodEntry creation from nutrition data
- [ ] DailyTotal update on save
- [ ] Navigation flow from voice input to save
- [ ] Error handling and retry logic

### UI Tests

- [ ] Loading state appearance and timing
- [ ] Ring animation smoothness and completion
- [ ] Edit mode interaction and validation
- [ ] Save button state management
- [ ] Success confirmation display

### Accessibility Tests

- [ ] VoiceOver navigation through all elements
- [ ] Dynamic Type scaling at all sizes
- [ ] Color contrast validation (WCAG AA)
- [ ] Touch target size verification
- [ ] Reduce Motion alternative animations

## Sign-off

- [ ] Product Owner approval
- [ ] Technical Lead review
- [ ] UX Designer review
- [ ] Accessibility review
- [ ] Security review (if applicable)

---

**Notes**: This checklist should be reviewed and updated as implementation progresses. Mark items complete only when fully implemented and tested.