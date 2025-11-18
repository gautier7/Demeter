# Feature Specification: Navigation System

**Feature Branch**: `008-navigation-system`  
**Created**: 2025-11-18  
**Status**: Draft  
**Input**: User description: "Create a feature specification for the Navigation System of the Demeter iOS calorie tracking app. Build the app-wide navigation coordinator and routing system that manages screen transitions, deep linking, and navigation flow between all major features."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Launch App and Land on Today View (Priority: P1)

As a user, I want the app to open directly to today's daily totals view so that I can immediately see my current progress without extra navigation.

**Why this priority**: The default landing screen is the most frequently accessed view. Users need instant access to their current day's data to make quick decisions about their next meal.

**Independent Test**: Can be fully tested by launching the app from a cold start and verifying that the Daily Totals view for today appears within 2 seconds with the tab bar visible.

**Acceptance Scenarios**:

1. **Given** I launch the app for the first time, **When** the app loads, **Then** I see the Daily Totals view with "Today" tab selected
2. **Given** I force-quit the app, **When** I relaunch it, **Then** I return to the Daily Totals view regardless of where I was before
3. **Given** the app is in background, **When** I bring it to foreground, **Then** I see the same view I was on before backgrounding

---

### User Story 2 - Navigate Between Main Tabs (Priority: P1)

As a user, I want to switch between Today, History, and Settings using a tab bar so that I can quickly access different sections of the app.

**Why this priority**: Tab navigation is the primary navigation pattern for the app. Users need fluid access to all main features without complex navigation hierarchies.

**Independent Test**: Can be fully tested by tapping each tab and verifying that the corresponding view appears within 100ms with smooth transitions.

**Acceptance Scenarios**:

1. **Given** I'm on the Today tab, **When** I tap the History tab, **Then** the Calendar History view appears with smooth transition
2. **Given** I'm on the History tab, **When** I tap the Settings tab, **Then** the Settings view appears
3. **Given** I'm on any tab, **When** I tap the currently selected tab again, **Then** the view scrolls to top if already at that tab
4. **Given** I'm viewing a detail screen, **When** I tap a different tab, **Then** I navigate to that tab's root view

---

### User Story 3 - Quick Access to Voice Input (Priority: P1)

As a user, I want a floating action button that opens voice input from any screen so that I can log food immediately without navigating back to a specific tab.

**Why this priority**: Voice input is the primary interaction method. Users should be able to log food from anywhere in the app without interrupting their current task.

**Independent Test**: Can be fully tested by tapping the floating action button from different screens and verifying that the voice input modal appears within 200ms.

**Acceptance Scenarios**:

1. **Given** I'm on any tab, **When** I tap the floating action button, **Then** the voice input modal slides up from bottom
2. **Given** the voice input modal is open, **When** I complete or cancel input, **Then** I return to the screen I was on before
3. **Given** I'm viewing a detail screen, **When** I tap the floating action button, **Then** voice input opens and tab bar remains hidden
4. **Given** voice input is open, **When** I swipe down to dismiss, **Then** the modal closes and I return to previous screen

---

### User Story 4 - View Day Details from History (Priority: P1)

As a user, I want to tap a day in the calendar to see its detailed view so that I can review past nutritional data.

**Why this priority**: Accessing historical details is essential for the History feature. Users need to drill down from calendar overview to specific day data.

**Independent Test**: Can be fully tested by tapping a calendar day and verifying that a day detail view appears with navigation back to calendar.

**Acceptance Scenarios**:

1. **Given** I'm viewing the calendar, **When** I tap a day with entries, **Then** the day detail view pushes onto the navigation stack
2. **Given** I'm viewing day details, **When** I tap the back button, **Then** I return to the calendar at the same scroll position
3. **Given** I'm viewing day details, **When** I swipe from left edge, **Then** I navigate back to calendar with smooth transition
4. **Given** I'm viewing day details, **When** I tap a food entry, **Then** the nutrition detail view appears

---

### User Story 5 - Deep Link to Specific Day (Priority: P2)

As a user, I want to tap a notification about yesterday's summary and be taken directly to that day's detail view so that I can review the data immediately.

**Why this priority**: Deep linking enables rich notification experiences and widget interactions. Users expect to jump directly to relevant content from external triggers.

**Independent Test**: Can be fully tested by triggering a deep link URL and verifying that the app opens to the correct screen within 500ms.

**Acceptance Scenarios**:

1. **Given** I receive a notification for yesterday, **When** I tap it, **Then** the app opens to yesterday's day detail view
2. **Given** the app is already open, **When** I tap a deep link, **Then** the app navigates to the linked screen
3. **Given** I tap a deep link to a specific date, **When** the app opens, **Then** the History tab is selected and that day's detail is shown
4. **Given** I tap an invalid deep link, **When** processed, **Then** the app opens to the default Today view with no error

---

### User Story 6 - Navigate to Settings Sections (Priority: P2)

As a user, I want to access different settings sections (goals, preferences, about) so that I can configure the app to my needs.

**Why this priority**: Settings navigation enables users to customize their experience. Clear organization of settings improves discoverability.

**Independent Test**: Can be fully tested by tapping settings options and verifying that detail views appear with proper back navigation.

**Acceptance Scenarios**:

1. **Given** I'm on the Settings tab, **When** I tap "Daily Goals", **Then** the goals configuration view appears
2. **Given** I'm editing goals, **When** I tap back, **Then** I return to the settings list
3. **Given** I'm in a settings detail view, **When** I tap "Done" or "Save", **Then** changes persist and I navigate back
4. **Given** I'm in nested settings, **When** I tap the root tab again, **Then** I pop to the settings root view

---

### User Story 7 - Handle Navigation During Voice Input (Priority: P1)

As a user, I want the voice input modal to remain on top when I try to navigate so that I don't accidentally lose my recording.

**Why this priority**: Preventing accidental navigation during voice input protects user data and prevents frustration from lost recordings.

**Independent Test**: Can be fully tested by opening voice input and attempting to tap tabs or back buttons, verifying that navigation is blocked until input is complete.

**Acceptance Scenarios**:

1. **Given** voice input modal is open, **When** I tap a tab bar item, **Then** the tap is ignored and modal remains visible
2. **Given** voice input is recording, **When** I try to swipe down to dismiss, **Then** a confirmation alert appears
3. **Given** voice input has transcribed text, **When** I try to dismiss, **Then** I'm asked to confirm losing the data
4. **Given** voice input completes successfully, **When** nutrition display appears, **Then** I can navigate normally

---

### User Story 8 - Maintain Navigation State Across App Lifecycle (Priority: P2)

As a user, I want the app to remember which tab and screen I was on when I return so that I can continue where I left off.

**Why this priority**: State preservation improves user experience by respecting their context. Users shouldn't have to re-navigate after backgrounding the app.

**Independent Test**: Can be fully tested by navigating to a specific screen, backgrounding the app, and verifying that the same screen appears when returning.

**Acceptance Scenarios**:

1. **Given** I'm viewing a day detail on History tab, **When** I background and return, **Then** I'm still on that day detail
2. **Given** I'm editing settings, **When** I background and return, **Then** my edits are preserved and I'm still on that screen
3. **Given** I'm in the middle of voice input, **When** I background briefly, **Then** the recording pauses and I can resume
4. **Given** the app is backgrounded for >30 minutes, **When** I return, **Then** I'm taken to the Today tab (fresh start)

---

### User Story 9 - Navigate from Nutrition Display to Today (Priority: P2)

As a user, I want to see my updated daily totals immediately after confirming a food entry so that I understand the impact of what I just logged.

**Why this priority**: Immediate feedback after logging food reinforces the tracking behavior and helps users make informed decisions about their next meal.

**Independent Test**: Can be fully tested by completing voice input, confirming the nutrition display, and verifying that the Today view appears with updated totals.

**Acceptance Scenarios**:

1. **Given** I complete voice input, **When** I tap "Confirm" on nutrition display, **Then** I navigate to Today tab with updated totals
2. **Given** I'm on History tab and add an entry, **When** I confirm, **Then** I return to the History tab (not Today)
3. **Given** I edit an existing entry, **When** I save changes, **Then** I return to the view I came from
d, **Then** I return to the screen I was on before voice input

---

### User Story 10 - Handle Invalid Navigation States (Priority: P3)

As a user, I want the app to gracefully handle navigation errors so that I never get stuck on a broken screen.

**Why this priority**: Error handling prevents user frustration and maintains app stability. Users should always have a way to recover from navigation issues.

**Independent Test**: Can be fully tested by simulating invalid navigation states and verifying that the app recovers to a known good state.

**Acceptance Scenarios**:

1. **Given** a navigation error occurs, **When** detected, **Then** the app navigates to the Today tab as a safe fallback
2. **Given** I try to navigate to a deleted entry, **When** the error is detected, **Then** I see an error message and return to the previous screen
3. **Given** a deep link points to invalid data, **When** processed, **Then** I'm taken to Today tab with a toast notification
4. **Given** the navigation stack becomes corrupted, **When** detected, **Then** the app resets to the root tab bar state

---

### Edge Cases

- What happens when user taps multiple tabs rapidly in succession?
- How does system handle deep links while voice input modal is open?
- What happens when user force-quits app during navigation transition?
- How does system handle navigation when database is unavailable?
- What happens when user receives multiple notifications and taps them sequentially?
- How does system handle navigation during midnight reset?
- What happens when user tries to navigate to a future date?
- How does system handle back navigation when the previous screen no longer exists?
- What happens when user rotates device during navigation transition?
- How does system handle navigation with VoiceOver active?
- What happens when memory pressure forces view unloading during navigation?
- How does system handle navigation when app is launched from widget?

## Requirements *(mandatory)*

### Functional Requirements

#### Tab Bar Navigation

- **FR-001**: System MUST display a tab bar with three tabs: Today, History, Settings
- **FR-002**: Today tab MUST be the default selected tab on app launch
- **FR-003**: Tab bar MUST remain visible on all root-level screens
- **FR-004**: Tab bar MUST hide automatically when pushing detail views onto navigation stack
- **FR-005**: Tab bar MUST hide when voice input modal is presented
- **FR-006**: System MUST support tab bar item customization (icons, labels, badges)
- **FR-007**: Selected tab MUST have distinct visual styling (color, weight, icon variant)
- **FR-008**: Tapping currently selected tab MUST scroll that tab's content to top

#### Navigation Stack Management

- **FR-009**: Each tab MUST maintain its own independent navigation stack
- **FR-010**: System MUST use SwiftUI [`NavigationStack`](https://developer.apple.com/documentation/swiftui/navigationstack) for hierarchical navigation
- **FR-011**: Navigation stack MUST support push and pop operations with animations
- **FR-012**: System MUST support swipe-from-edge gesture for back navigation
- **FR-013**: Back button MUST appear automatically when navigation stack depth > 1
- **FR-014**: System MUST preserve navigation stack state when switching tabs
- **FR-015**: System MUST clear navigation stack when tapping root tab again (pop to root)

#### Modal Presentations

- **FR-016**: Voice input MUST present as a modal sheet from bottom
- **FR-017**: Modal sheets MUST support swipe-down-to-dismiss gesture
- **FR-018**: System MUST block tab bar interaction when modal is presented
- **FR-019**: System MUST support full-screen modal presentations for immersive experiences
- **FR-020**: System MUST handle nested modal presentations (modal over modal)
- **FR-021**: Dismissing modal MUST return to the exact screen that presented it
- **FR-022**: System MUST support programmatic modal dismissal from ViewModels

#### Floating Action Button

- **FR-023**: System MUST display a floating action button for voice input on all main screens
- **FR-024**: Floating button MUST be positioned in bottom-right corner above tab bar
- **FR-025**: Floating button MUST be minimum 56x56 points for easy tapping
- **FR-026**: Floating button MUST hide when keyboard is visible
- **FR-027**: Floating button MUST hide when scrolling down, reappear when scrolling up
- **FR-028**: Floating button MUST have distinct visual styling (shadow, color, icon)
- **FR-029**: Tapping floating button MUST present voice input modal

#### Deep Linking

- **FR-030**: System MUST support URL scheme: `demeter://`
- **FR-031**: System MUST handle deep link routes: `/today`, `/history`, `/history/{date}`, `/settings`
- **FR-032**: System MUST process deep links within 500ms of app launch
- **FR-033**: System MUST handle deep links when app is already running
- **FR-034**: System MUST validate deep link parameters before navigation
- **FR-035**: Invalid deep links MUST navigate to Today tab with error notification
- **FR-036**: System MUST support universal links (https://demeter.app/...) for future web integration
- **FR-037**: Deep links MUST respect current navigation state (don't interrupt voice input)

#### Navigation Coordinator

- **FR-038**: System MUST implement coordinator pattern for centralized navigation logic
- **FR-039**: Coordinator MUST manage all navigation state and routing decisions
- **FR-040**: Coordinator MUST provide type-safe navigation methods
- **FR-041**: Coordinator MUST handle navigation from ViewModels without view coupling
- **FR-042**: Coordinator MUST support navigation history tracking for analytics
- **FR-043**: Coordinator MUST handle navigation conflicts (e.g., multiple simultaneous requests)
- **FR-044**: Coordinator MUST provide navigation completion callbacks

#### State Preservation

- **FR-045**: System MUST save navigation state when app enters background
- **FR-046**: System MUST restore navigation state when app returns to foreground
- **FR-047**: State preservation MUST include: selected tab, navigation stack, modal state
- **FR-048**: System MUST reset to Today tab if backgrounded for >30 minutes
- **FR-049**: System MUST handle state restoration failures gracefully
- **FR-050**: System MUST preserve scroll positions within views when navigating away

#### Navigation Transitions

- **FR-051**: Tab switches MUST complete within 100ms with cross-fade animation
- **FR-052**: Navigation pushes MUST use slide-from-right animation (300ms)
- **FR-053**: Navigation pops MUST use slide-to-right animation (300ms)
- **FR-054**: Modal presentations MUST use slide-from-bottom animation (400ms)
- **FR-055**: All animations MUST maintain 60fps on supported devices
- **FR-056**: System MUST support Reduce Motion accessibility setting with fade transitions
- **FR-057**: Transitions MUST be interruptible (user can cancel mid-animation)

#### Navigation from Voice Input Flow

- **FR-058**: Completing voice input MUST navigate to nutrition display modal
- **FR-059**: Confirming nutrition display MUST dismiss modal and update current view
- **FR-060**: Canceling voice input MUST dismiss modal and return to previous screen
- **FR-061**: System MUST prevent navigation away from voice input during recording
- **FR-062**: System MUST show confirmation dialog if user tries to dismiss during recording

#### Error Handling

- **FR-063**: System MUST handle missing view data by navigating to safe fallback
- **FR-064**: System MUST log navigation errors for debugging without crashing
- **FR-065**: System MUST display user-friendly error messages for navigation failures
- **FR-066**: System MUST provide "Go to Today" button in error states
- **FR-067**: System MUST recover from corrupted navigation state automatically
- **FR-068**: System MUST handle concurrent navigation requests with queue management

#### Accessibility

- **FR-069**: All navigation elements MUST support VoiceOver with descriptive labels
- **FR-070**: Tab bar items MUST announce their state (selected/unselected)
- **FR-071**: Back button MUST announce destination ("Back to Calendar")
- **FR-072**: System MUST support keyboard navigation for external keyboards
- **FR-073**: Focus MUST move logically when navigating between screens
- **FR-074**: System MUST announce screen changes to VoiceOver users
- **FR-075**: All navigation gestures MUST have button alternatives

#### Performance

- **FR-076**: Tab switching MUST complete within 100ms
- **FR-077**: Deep link processing MUST complete within 500ms
- **FR-078**: Navigation stack operations MUST complete within 50ms
- **FR-079**: State restoration MUST complete within 1 second
- **FR-080**: System MUST handle 20+ screens in navigation stack without performance degradation
- **FR-081**: Memory footprint for navigation state MUST remain under 10MB

### Key Entities

- **AppCoordinator**: Main navigation coordinator managing app-wide navigation. Key attributes: selectedTab, navigationPaths, modalState, deepLinkHandler
- **NavigationRouter**: Route definitions and navigation logic. Key attributes: routes, currentRoute, navigationHistory
- **TabItem**: Enum for tab bar items. Values: today, history, settings
- **NavigationRoute**: Enum for all possible routes. Values: todayRoot, historyRoot, dayDetail(Date), settingsRoot, goalSettings, etc.
- **DeepLinkHandler**: Processes deep links and universal links. Key attributes: urlScheme, routeParser, validationRules
- **NavigationState**: Codable state for preservation. Key attributes: selectedTab, navigationPaths, modalStack, scrollPositions
- **ModalPresentationState**: Tracks modal state. Key attributes: isPresented, presentationType, sourceRoute
- **FloatingActionButton**: Reusable FAB component. Key attributes: action, isVisible, position, style

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can navigate to any main screen within 2 taps from any location
- **SC-002**: Tab switching completes within 100ms with smooth 60fps animation
- **SC-003**: Deep links open correct screens within 500ms of app launch
- **SC-004**: Navigation state persists correctly across 100% of app backgrounding events
- **SC-005**: Back navigation always works as expected with no stuck states
- **SC-006**: Voice input modal prevents accidental navigation 100% of the time
- **SC-007**: Floating action button is accessible from all main screens
- **SC-008**: VoiceOver users can navigate to any screen with same efficiency as sighted users
- **SC-009**: Navigation transitions maintain 60fps on all supported devices
- **SC-010**: System handles 100+ navigation operations without memory leaks
- **SC-011**: Invalid deep links are handled gracefully with no crashes
- **SC-012**: Navigation state restoration succeeds in 99% of cases

## Assumptions

- SwiftUI [`NavigationStack`](https://developer.apple.com/documentation/swiftui/navigationstack) is available (iOS 18.0+)
- Users understand standard iOS navigation patterns (tabs, back button, swipe gestures)
- Most users will stay within 3-4 levels of navigation depth
- Deep links will primarily come from notifications and widgets
- Tab bar will have exactly 3 tabs for MVP (extensible post-MVP)
- Voice input is the only modal that blocks navigation
- Users will not rapidly switch tabs (debouncing not critical for MVP)
- Navigation state can be serialized to UserDefaults (<1MB)
- Most navigation will be user-initiated (not programmatic)
- App will not support iPad split-view multitasking in MVP

## Dependencies

- SwiftUI framework for navigation components
- [`NavigationStack`](https://developer.apple.com/documentation/swiftui/navigationstack) for hierarchical navigation (iOS 18.0+)
- Combine framework for reactive navigation state
- All feature ViewModels (specs 004-007) for screen content
- [`DailyTotal`](Demeter/Models/DailyTotal.swift) and [`FoodEntry`](Demeter/Models/FoodEntry.swift) models for data-driven navigation
- UserDefaults or similar for state persistence
- NotificationCenter for navigation events
- URLComponents for deep link parsing

## Out of Scope (Post-MVP)

- iPad-specific navigation (split view, slide over)
- Apple Watch navigation and handoff
- Siri shortcuts integration
- Widget deep linking (basic support only)
- Navigation analytics and tracking
- A/B testing different navigation patterns
- Custom navigation transitions beyond standard iOS
- Navigation search (global app search)
- Recently viewed screens history
- Bookmarking or favoriting screens
- Multi-window support (iPadOS)
- Handoff between devices
- Navigation tutorials or onboarding
- Gesture customization
- Navigation performance profiling tools
- Advanced deep link routing (query parameters, fragments)

## Technical Notes

### Navigation Architecture

```
AppCoordinator (ObservableObject)
├── TabBarCoordinator
│   ├── TodayNavigationStack
│   │   └── DailyTotalsView
│   ├── HistoryNavigationStack
│   │   ├── CalendarHistoryView
│   │   └── DayDetailView (pushed)
│   └── SettingsNavigationStack
│       ├── SettingsListView
│       └── GoalSettingsView (pushed)
├── ModalCoordinator
│   ├── VoiceInputSheet
│   └── NutritionDisplaySheet
└── DeepLinkHandler
    └── RouteParser
```

### Coordinator Pattern Implementation

```swift
@Observable
class AppCoordinator {
    var selectedTab: TabItem = .today
    var todayPath = NavigationPath()
    var historyPath = NavigationPath()
    var settingsPath = NavigationPath()
    var presentedModal: ModalRoute?
    
    func navigate(to route: NavigationRoute) {
        switch route {
        case .todayRoot:
            selectedTab = .today
            todayPath = NavigationPath()
        case .historyRoot:
            selectedTab = .history
            historyPath = NavigationPath()
        case .dayDetail(let date):
            selectedTab = .history
            historyPath.append(DayDetailRoute(date: date))
        case .voiceInput:
            presentedModal = .voiceInput
        // ... more routes
        }
    }
    
    func handleDeepLink(_ url: URL) {
        guard let route = DeepLinkHandler.parse(url) else {
            navigate(to: .todayRoot)
            return
        }
        navigate(to: route)
    }
}
```

### Route Definitions

```swift
enum TabItem: String, Codable {
    case today
    case history
    case settings
}

enum NavigationRoute: Hashable {
    case todayRoot
    case historyRoot
    case dayDetail(Date)
    case entryDetail(UUID)
    case settingsRoot
    case goalSettings
    case preferences
    case about
    case voiceInput
    case nutritionDisplay(FoodEntry)
}

enum ModalRoute: Identifiable {
    case voiceInput
    case nutritionDisplay(FoodEntry)
    case goalSettings
    case confirmation(String)
    
    var id: String {
        switch self {
        case .voiceInput: return "voiceInput"
        case .nutritionDisplay: return "nutritionDisplay"
        case .goalSettings: return "goalSettings"
        case .confirmation: return "confirmation"
        }
    }
}
```

### Deep Link URL Scheme

```
demeter://today
demeter://history
demeter://history/2024-11-18
demeter://history/2024-11-18/entry/{uuid}
demeter://settings
demeter://settings/goals
demeter://settings/preferences
```

### Deep Link Handler

```swift
struct DeepLinkHandler {
    static func parse(_ url: URL) -> NavigationRoute? {
        guard url.scheme == "demeter" else { return nil }
        
        let path = url.path
        let components = path.split(separator: "/").map(String.init)
        
        switch components.first {
        case "today":
            return .todayRoot
        case "history":
            if components.count == 1 {
                return .historyRoot
            } else if components.count == 2,
                      let date = ISO8601DateFormatter().date(from: components[1]) {
                return .dayDetail(date)
            }
        case "settings":
            if components.count == 1 {
                return .settingsRoot
            } else if components[1] == "goals" {
                return .goalSettings
            }
        default:
            return nil
        }
        
        return nil
    }
}
```

### State Preservation

```swift
struct NavigationState: Codable {
    var selectedTab: TabItem
    var todayPathData: Data
    var historyPathData: Data
    var settingsPathData: Data
    var lastActiveDate: Date
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "navigationState")
        }
    }
    
    static func restore() -> NavigationState? {
        guard let data = UserDefaults.standard.data(forKey: "navigationState"),
              let state = try? JSONDecoder().decode(NavigationState.self, from: data) else {
            return nil
        }
        
        // Reset if backgrounded for >30 minutes
        if Date().timeIntervalSince(state.lastActiveDate) > 1800 {
            return nil
        }
        
        return state
    }
}
```

### Tab Bar View Structure

```swift
struct RootTabView: View {
    @Environment(AppCoordinator.self) private var coordinator
    
    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            TodayNavigationView()
                .tabItem {
                    Label("Today", systemImage: "calendar.badge.clock")
                }
                .tag(TabItem.today)
            
            HistoryNavigationView()
                .tabItem {
                    Label("History", systemImage: "calendar")
                }
                .tag(TabItem.history)
            
            SettingsNavigationView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(TabItem.settings)
        }
        .overlay(alignment: .bottomTrailing) {
            FloatingActionButton {
                coordinator.navigate(to: .voiceInput)
            }
            .padding()
        }
        .sheet(item: $coordinator.presentedModal) { modal in
            modalView(for: modal)
        }
    }
    
    @ViewBuilder
    func modalView(for modal: ModalRoute) -> some View {
        switch modal {
        case .voiceInput:
            VoiceInputView()
        case .nutritionDisplay(let entry):
            NutritionDisplayView(entry: entry)
        case .goalSettings:
            GoalSettingsView()
        case .confirmation(let message):
            ConfirmationView(message: message)
        }
    }
}
```

### Navigation Stack Views

```swift
struct TodayNavigationView: View {
    @Environment(AppCoordinator.self) private var coordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.todayPath) {
            DailyTotalsView()
                .navigationDestination(for: NavigationRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }
    
    @ViewBuilder
    func destinationView(for route: NavigationRoute) -> some View {
        switch route {
        case .entryDetail(let id):
            EntryDetailView(entryID: id)
        default:
            EmptyView()
        }
    }
}

struct HistoryNavigationView: View {
    @Environment(AppCoordinator.self) private var coordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.historyPath) {
            CalendarHistoryView()
                .navigationDestination(for: NavigationRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }
    
    @ViewBuilder
    func destinationView(for route: NavigationRoute) -> some View {
        switch route {
        case .dayDetail(let date):
            DayDetailView(date: date)
        case .entryDetail(let id):
            EntryDetailView(entryID: id)
        default:
            EmptyView()
        }
    }
}
```

### Floating Action Button

```swift
struct FloatingActionButton: View {
    let action: () -> Void
    @State private var isVisible = true
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "mic.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.accentColor)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0.8)
        .animation(.spring(response: 0.3), value: isVisible)
    }
}
```

### Navigation Event Tracking

```swift
extension AppCoordinator {
    func trackNavigation(to route: NavigationRoute) {
        NotificationCenter.default.post(
            name: .navigationOccurred,
            object: nil,
            userInfo: ["route": route]
        )
        
        // Analytics tracking (post-MVP)
        // AnalyticsService.track(event: "navigation", properties: ["route": route.description])
    }
}

extension Notification.Name {
    static let navigationOccurred = Notification.Name("navigationOccurred")
}
```

### Voice Input Navigation Guard

```swift
extension AppCoordinator {
    var canNavigate: Bool {
        // Prevent navigation during voice input recording
        if case .voiceInput = presentedModal {
            return false
        }
        return true
    }
    
    func navigate(to route: NavigationRoute) {
        guard canNavigate else {
            showNavigationBlockedAlert()
            return
        }
        
        performNavigation(to: route)
    }
    
    private func showNavigationBlockedAlert() {
        presentedModal = .confirmation("Complete or cancel voice input before navigating")
    }
}
```

## Related Specifications

- **spec-004**: Voice Input Interface - Modal presentation and navigation flow
- **spec-005**: Nutrition Display Interface - Modal presentation after voice input
- **spec-006**: Daily Totals Summary - Today tab root view
- **spec-007**: Calendar History - History tab root view and day details
- **spec-001**: SwiftData Models - Data models used in navigation routes

## Open Questions

None - all critical aspects are specified with reasonable assumptions documented.
4. **Given** I cancel nutrition display, **When** dismisse