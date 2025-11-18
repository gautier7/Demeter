# Feature Specification: Nutrition Display Interface

**Feature Branch**: `005-nutrition-display`  
**Created**: 2025-11-18  
**Status**: Draft  
**Input**: User description: "Create a feature specification for the Nutrition Display interface of the Demeter iOS calorie tracking app. Build the real-time nutrition breakdown display that shows users the parsed nutritional information after voice input is processed by the LLM."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - View Parsed Nutrition Breakdown (Priority: P1)

As a user, I want to see the nutritional breakdown of my food immediately after speaking so that I can verify the app understood my meal correctly before saving it.

**Why this priority**: This is the core value delivery moment where users see the results of their voice input. Without clear nutrition display, users cannot verify accuracy or trust the system.

**Independent Test**: Can be fully tested by completing a voice input, waiting for LLM processing, and verifying that nutrition data appears within 100ms with calories prominently displayed and macronutrients clearly visible.

**Acceptance Scenarios**:

1. **Given** voice input "I ate a grilled chicken breast with rice" has been processed, **When** the nutrition display appears, **Then** total calories are shown prominently at the top (e.g., "450 calories")
2. **Given** nutrition data is displayed, **When** user views the breakdown, **Then** macronutrients (protein, carbs, fat) are shown with both gram amounts and percentage of total calories
3. **Given** multiple food items were mentioned, **When** nutrition display appears, **Then** each food item is listed separately with its individual nutritional values before showing the combined total

---

### User Story 2 - Understand Individual Food Items (Priority: P1)

As a user, I want to see each food item I mentioned listed separately with its quantity and nutrition so that I can verify the app correctly identified all components of my meal.

**Why this priority**: Users often describe complex meals with multiple items. Clear itemization builds trust and allows users to spot errors before saving.

**Independent Test**: Can be fully tested by speaking a multi-item meal description and verifying each item appears as a separate card with name, quantity, unit, and nutritional breakdown.

**Acceptance Scenarios**:

1. **Given** user said "chicken breast and broccoli", **When** nutrition display appears, **Then** two separate food item cards are shown: one for chicken breast and one for broccoli
2. **Given** a food item card is displayed, **When** user views it, **Then** it shows the food name, quantity with unit (e.g., "150g"), and individual calories/macros
3. **Given** food items are listed, **When** displayed, **Then** they appear in the order mentioned by the user

---

### User Story 3 - See Confidence Indicators (Priority: P2)

As a user, I want to see confidence scores for nutritional estimates so that I know when the app is certain versus making educated guesses.

**Why this priority**: Transparency about estimation accuracy helps users make informed decisions about whether to accept or edit the data. Builds trust through honesty.

**Independent Test**: Can be fully tested by viewing nutrition display and verifying that confidence indicators (visual or numeric) appear for each food item, with clear differentiation between high and low confidence.

**Acceptance Scenarios**:

1. **Given** a food item has high confidence (>0.9), **When** displayed, **Then** a green checkmark or "High confidence" indicator appears
2. **Given** a food item has medium confidence (0.7-0.9), **When** displayed, **Then** a yellow indicator or "Estimated" label appears
3. **Given** a food item has low confidence (<0.7), **When** displayed, **Then** an orange/red indicator appears with suggestion to review or edit

---

### User Story 4 - View Macronutrient Visualization (Priority: P2)

As a user, I want to see a visual representation of my macronutrient breakdown so that I can quickly understand the composition of my meal at a glance.

**Why this priority**: Visual representations (rings, charts) provide instant understanding of meal composition, which is faster than reading numbers. Enhances user experience and engagement.

**Independent Test**: Can be fully tested by viewing nutrition display and verifying that circular progress rings or similar visualizations show the proportion of protein, carbs, and fat.

**Acceptance Scenarios**:

1. **Given** nutrition data is displayed, **When** user views macronutrient section, **Then** three circular progress rings appear showing protein, carbs, and fat percentages
2. **Given** macronutrient rings are shown, **When** displayed, **Then** each ring uses a distinct color (e.g., blue for protein, orange for carbs, yellow for fat)
3. **Given** rings are displayed, **When** user views them, **Then** both gram amounts and percentage of total calories are shown for each macronutrient

---

### User Story 5 - See Processing States (Priority: P1)

As a user, I want clear visual feedback while my voice input is being analyzed so that I know the app is working and approximately how long to wait.

**Why this priority**: Processing can take 2-3 seconds. Without feedback, users may think the app froze. Clear loading states maintain user confidence.

**Independent Test**: Can be fully tested by completing voice input and verifying that a loading indicator appears immediately with appropriate messaging during LLM processing.

**Acceptance Scenarios**:

1. **Given** voice transcription is complete, **When** LLM processing begins, **Then** a loading indicator appears with text "Analyzing your meal..."
2. **Given** processing is ongoing, **When** displayed, **Then** an animated spinner or progress indicator shows activity
3. **Given** processing takes longer than 3 seconds, **When** displayed, **Then** additional context appears: "This is taking longer than usual..."

---

### User Story 6 - Edit Before Saving (Priority: P2)

As a user, I want to edit nutritional values or food quantities before saving so that I can correct any mistakes the LLM made.

**Why this priority**: LLM estimates won't always be perfect. Allowing edits before saving prevents bad data from entering the system and gives users control.

**Independent Test**: Can be fully tested by tapping an edit button on the nutrition display and verifying that editable fields appear for quantities and nutritional values.

**Acceptance Scenarios**:

1. **Given** nutrition display is shown, **When** user taps "Edit" button, **Then** quantity fields become editable with numeric keyboard
2. **Given** edit mode is active, **When** user changes a quantity, **Then** nutritional values recalculate automatically in real-time
3. **Given** edits are made, **When** user taps "Save", **Then** the edited values are persisted to the database

---

### User Story 7 - Confirm and Save Entry (Priority: P1)

As a user, I want a clear "Save" or "Confirm" action after reviewing nutrition so that I can explicitly approve the entry before it's added to my daily totals.

**Why this priority**: Explicit confirmation prevents accidental entries and gives users a final review opportunity. Critical for data accuracy.

**Independent Test**: Can be fully tested by viewing nutrition display and verifying that a prominent "Save" or "Add to Log" button appears, and tapping it successfully saves the entry.

**Acceptance Scenarios**:

1. **Given** nutrition display is shown, **When** user reviews the data, **Then** a prominent "Add to Log" button appears at the bottom
2. **Given** user taps "Add to Log", **When** the action completes, **Then** a success confirmation appears (checkmark animation or toast message)
3. **Given** entry is saved, **When** confirmed, **Then** user is returned to the main view with updated daily totals visible

---

### User Story 8 - Preview Daily Total Impact (Priority: P3)

As a user, I want to see how this meal will affect my daily totals before saving so that I can understand its impact on my daily goals.

**Why this priority**: Helps users make informed decisions about their meals and understand progress toward daily goals. Enhances goal-tracking value.

**Independent Test**: Can be fully tested by viewing nutrition display and verifying that a "Daily Total Preview" section shows current totals plus the new entry.

**Acceptance Scenarios**:

1. **Given** nutrition display is shown, **When** user scrolls to bottom, **Then** a preview section shows "After adding: X calories (Y% of daily goal)"
2. **Given** daily total preview is shown, **When** displayed, **Then** it shows before/after comparison for calories and macros
3. **Given** adding this meal would exceed daily goal, **When** preview is shown, **Then** a gentle warning appears: "This will exceed your daily goal by X calories"

---

### Edge Cases

- What happens when LLM returns no food items (couldn't parse the input)?
- How does system handle extremely high calorie values (>5000 calories in one entry)?
- What happens when confidence scores are missing from LLM response?
- How does system display nutrition for very small quantities (e.g., 1g of butter)?
- What happens when user tries to save without reviewing the data?
- How does system handle partial LLM responses (incomplete JSON)?
- What happens when multiple food items have identical names?
- How does system display micronutrients if available (fiber, sugar)?
- What happens when user navigates away before saving?
- How does system handle very long food names that don't fit in the UI?

## Requirements *(mandatory)*

### Functional Requirements

#### Display Components

- **FR-001**: System MUST display total calories prominently at the top of the nutrition display with large, bold typography
- **FR-002**: System MUST show macronutrient breakdown (protein, carbs, fat) with both gram amounts and percentage of total calories
- **FR-003**: System MUST list each food item separately when multiple items are present in the LLM response
- **FR-004**: System MUST display food item name, quantity, and unit for each item (e.g., "Grilled Chicken Breast - 150g")
- **FR-005**: System MUST show individual nutritional values (calories, protein, carbs, fat) for each food item
- **FR-006**: System MUST display confidence scores or indicators for each food item's nutritional estimate

#### Visual Hierarchy

- **FR-007**: Total calories MUST be the most prominent element, using largest font size (minimum 32pt)
- **FR-008**: Macronutrient summary MUST be second-level hierarchy, clearly visible without scrolling
- **FR-009**: Individual food items MUST be displayed in card format with clear visual separation
- **FR-010**: System MUST use color coding for confidence levels: green (high), yellow (medium), orange/red (low)
- **FR-011**: System MUST maintain consistent spacing and alignment across all nutritional data displays

#### Macronutrient Visualization

- **FR-012**: System MUST display circular progress rings for protein, carbohydrates, and fat
- **FR-013**: Each macronutrient ring MUST use a distinct, accessible color (meeting WCAG AA contrast)
- **FR-014**: Rings MUST show both percentage fill and numeric values (grams and % of calories)
- **FR-015**: Ring animations MUST complete within 500ms of data appearing
- **FR-016**: System MUST calculate macronutrient percentages based on caloric contribution (protein/carbs: 4 cal/g, fat: 9 cal/g)

#### Loading and Processing States

- **FR-017**: System MUST display loading indicator immediately when LLM processing begins
- **FR-018**: Loading indicator MUST include descriptive text: "Analyzing your meal..."
- **FR-019**: System MUST show animated spinner or progress indicator during processing
- **FR-020**: If processing exceeds 3 seconds, system MUST display additional context message
- **FR-021**: System MUST handle processing timeout (>10 seconds) with error message and retry option

#### Confidence Indicators

- **FR-022**: System MUST display confidence score for each food item from LLM response
- **FR-023**: Confidence indicators MUST be visual (icons, colors) not just numeric
- **FR-024**: High confidence (>0.9) MUST show green checkmark or "Verified" badge
- **FR-025**: Medium confidence (0.7-0.9) MUST show yellow indicator with "Estimated" label
- **FR-026**: Low confidence (<0.7) MUST show warning indicator with "Please review" message
- **FR-027**: System MUST provide tooltip or info button explaining confidence scores

#### Editing Capabilities

- **FR-028**: System MUST provide "Edit" button to enable modification of nutritional values
- **FR-029**: In edit mode, quantity fields MUST become editable with numeric keyboard
- **FR-030**: System MUST recalculate nutritional values in real-time when quantities change
- **FR-031**: System MUST validate edited values (no negative numbers, reasonable ranges)
- **FR-032**: System MUST allow editing individual food item names
- **FR-033**: System MUST provide "Cancel" option to discard edits and restore original values

#### Confirmation and Saving

- **FR-034**: System MUST display prominent "Add to Log" or "Save" button after nutrition display
- **FR-035**: Save button MUST be disabled during processing or if data is invalid
- **FR-036**: System MUST show success confirmation (animation, toast, or checkmark) after saving
- **FR-037**: System MUST create [`FoodEntry`](Demeter/Models/FoodEntry.swift) records for each food item when saving
- **FR-038**: System MUST update [`DailyTotal`](Demeter/Models/DailyTotal.swift) with new entries atomically
- **FR-039**: System MUST navigate back to main view after successful save

#### Daily Total Preview

- **FR-040**: System MUST show preview of daily totals after adding this entry
- **FR-041**: Preview MUST display before/after comparison for calories and macros
- **FR-042**: System MUST calculate percentage of daily goal if goal is set
- **FR-043**: System MUST show gentle warning if entry would exceed daily goal
- **FR-044**: Preview MUST update in real-time if user edits quantities

#### Error Handling

- **FR-045**: System MUST handle empty LLM responses (no food items parsed) with clear message
- **FR-046**: System MUST handle malformed JSON responses from LLM gracefully
- **FR-047**: System MUST handle missing confidence scores by defaulting to medium confidence
- **FR-048**: System MUST validate nutritional values are within reasonable ranges (0-10000 calories per item)
- **FR-049**: System MUST provide "Try Again" option if LLM processing fails
- **FR-050**: System MUST preserve original voice transcription for retry attempts

#### Accessibility

- **FR-051**: All nutritional values MUST have VoiceOver labels with units (e.g., "450 calories")
- **FR-052**: Confidence indicators MUST be announced to VoiceOver users
- **FR-053**: System MUST support Dynamic Type scaling for all text elements
- **FR-054**: Color-coded confidence indicators MUST have non-color alternatives (icons, text)
- **FR-055**: All interactive elements MUST meet minimum touch target size (44x44 points)
- **FR-056**: System MUST support Reduce Motion with alternative animations

#### Integration Requirements

- **FR-057**: System MUST receive [`NutritionData`](Demeter/Data/Models/DTOs/OpenAIRequest.swift:69) from LLM service
- **FR-058**: System MUST parse [`FoodItem`](Demeter/Data/Models/DTOs/OpenAIRequest.swift:78) array from LLM response
- **FR-059**: System MUST create [`FoodEntry`](Demeter/Models/FoodEntry.swift) models from parsed data
- **FR-060**: System MUST use [`FoodEntryRepository`](Demeter/Repositories/FoodEntryRepository.swift) for persistence
- **FR-061**: System MUST update [`DailyTotal`](Demeter/Models/DailyTotal.swift) through repository pattern

### Key Entities

- **NutritionDisplayView**: Main SwiftUI view displaying parsed nutrition. Key attributes: nutritionData, processingState, isEditing, showDailyPreview
- **NutritionCardView**: Reusable card component for displaying individual nutrients. Key attributes: title, value, unit, color, icon
- **MacronutrientRingView**: Circular progress ring for macros. Key attributes: value, total, color, label, animationProgress
- **FoodItemRowView**: List row for individual food items. Key attributes: foodItem, confidence, isEditing, onEdit
- **NutritionDisplayViewModel**: ObservableObject managing business logic. Key attributes: nutritionData, dailyTotal, isLoading, errorMessage, editedValues
- **ProcessingState**: Enum for LLM processing states. Values: idle, processing, success(NutritionData), error(Error)
- **ConfidenceLevel**: Enum for confidence indicators. Values: high, medium, low, unknown

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Nutrition data appears on screen within 100ms of LLM response completion
- **SC-002**: Total calories are visible without scrolling on all supported device sizes (iPhone SE to Pro Max)
- **SC-003**: Users can identify all food items in their meal within 2 seconds of viewing the display
- **SC-004**: Macronutrient ring animations complete smoothly at 60fps on all supported devices
- **SC-005**: 90% of users can correctly interpret confidence indicators without additional explanation
- **SC-006**: Users can edit and save nutritional values within 10 seconds of tapping "Edit"
- **SC-007**: Loading state appears within 100ms of voice input completion
- **SC-008**: Success confirmation is visible for at least 1 second after saving
- **SC-009**: Daily total preview accurately reflects the impact of the new entry within 50ms
- **SC-010**: VoiceOver users can navigate and understand all nutritional information with same comprehension as sighted users
- **SC-011**: All text remains readable at maximum Dynamic Type size (AX5) without truncation
- **SC-012**: Error messages appear within 500ms of error occurrence with clear recovery actions

## Assumptions

- LLM service returns structured [`NutritionData`](Demeter/Data/Models/DTOs/OpenAIRequest.swift:69) in expected JSON format
- Voice input has already been transcribed and processed before reaching this view
- [`FoodEntry`](Demeter/Models/FoodEntry.swift) and [`DailyTotal`](Demeter/Models/DailyTotal.swift) models are available and functional
- Users understand basic nutritional concepts (calories, protein, carbs, fat)
- Network connectivity is available for LLM processing (handled by previous layer)
- Users will review nutrition data before saving (not blindly accepting)
- Confidence scores from LLM are in range 0.0-1.0
- Food quantities are in reasonable ranges (not extreme values)
- Users have basic familiarity with circular progress indicators
- Daily calorie goals are optional (system works without them)

## Dependencies

- [`NutritionData`](Demeter/Data/Models/DTOs/OpenAIRequest.swift:69) DTO from LLM service response
- [`FoodEntry`](Demeter/Models/FoodEntry.swift) model for creating entries
- [`DailyTotal`](Demeter/Models/DailyTotal.swift) model for updating daily aggregates
- [`FoodEntryRepository`](Demeter/Repositories/FoodEntryRepository.swift) for data persistence
- LLMService for processing voice transcription (from spec 003)
- SwiftUI for UI implementation
- Combine framework for reactive state management
- SwiftData for persistence layer
- Voice Input interface (spec 004) as the preceding step in user flow

## Out of Scope (Post-MVP)

- Detailed micronutrient display (vitamins, minerals, fiber)
- Meal photo attachment or display
- Nutritional goal tracking and progress bars
- Comparison with previous meals
- Nutritional recommendations or suggestions
- Barcode scanning integration
- Restaurant menu integration
- Recipe breakdown and scaling
- Meal planning features
- Social sharing of meals
- Nutritional trends and analytics
- Custom macronutrient ratio goals
- Meal timing and frequency analysis
- Integration with fitness trackers
- Nutritionist consultation features

## Technical Notes

### Data Flow

```
Voice Input (spec 004)
    ↓
LLM Processing
    ↓
NutritionData DTO
    ↓
NutritionDisplayView ← You are here
    ↓
User Review/Edit
    ↓
FoodEntry Creation
    ↓
DailyTotal Update
    ↓
Main View (updated totals)
```

### View Hierarchy

```
NutritionDisplayView
├── LoadingStateView (conditional)
├── ErrorStateView (conditional)
└── ContentView
    ├── TotalCaloriesHeader
    ├── MacronutrientRingView (x3)
    ├── FoodItemsList
    │   └── FoodItemRowView (foreach)
    ├── ConfidenceIndicatorView
    ├── DailyTotalPreview (optional)
    └── ActionButtons
        ├── EditButton
        └── SaveButton
```

### Animation Timing

- Ring animations: 500ms ease-in-out
- Card appearance: 300ms staggered (100ms delay between items)
- Success confirmation: 1000ms fade-in, 500ms hold, 500ms fade-out
- Loading spinner: continuous rotation
- State transitions: 200ms cross-fade

### Color Palette (Suggested)

- Calories: Primary brand color
- Protein: Blue (#007AFF)
- Carbohydrates: Orange (#FF9500)
- Fat: Yellow (#FFCC00)
- High confidence: Green (#34C759)
- Medium confidence: Yellow (#FFCC00)
- Low confidence: Orange (#FF9500)
- Error: Red (#FF3B30)