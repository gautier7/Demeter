# Demeter iOS Project - Complete Folder/File Structure

## Overview
This document defines the complete folder and file structure for the Demeter iOS calorie tracking application, based on the technical constitution. The structure follows MVVM architecture with Repository pattern, organized by feature and layer.

---

## Root Directory Structure

```
Demeter/
├── Demeter/                          # Main application target
├── DemeterTests/                     # Unit tests
├── DemeterUITests/                   # UI tests
├── DemeterWatch/                     # Apple Watch extension (Post-MVP)
├── Shared/                           # Shared code between targets
├── Resources/                        # Assets, localization, data files
├── Documentation/                    # Project documentation
├── Scripts/                          # Build scripts, utilities
└── Configuration/                    # Xcode configuration files
```

---

## Detailed Structure

### 1. Demeter/ (Main Application Target)

```
Demeter/
├── App/
│   ├── DemeterApp.swift                    # Main app entry point (@main)
│   ├── AppDelegate.swift                   # App lifecycle delegate
│   └── SceneDelegate.swift                 # Scene lifecycle (if needed)
│
├── Core/
│   ├── Configuration/
│   │   ├── AppConfiguration.swift          # App-wide configuration
│   │   ├── Environment.swift               # Environment management (dev/staging/prod)
│   │   └── FeatureFlags.swift              # Feature flag management
│   │
│   ├── Extensions/
│   │   ├── Date+Extensions.swift           # Date utilities
│   │   ├── Double+Extensions.swift         # Number formatting
│   │   ├── String+Extensions.swift         # String utilities
│   │   ├── Color+Extensions.swift          # Custom colors
│   │   └── View+Extensions.swift           # SwiftUI view modifiers
│   │
│   ├── Utilities/
│   │   ├── Logger.swift                    # Logging utility
│   │   ├── DateFormatter+Shared.swift      # Shared date formatters
│   │   ├── NumberFormatter+Shared.swift    # Shared number formatters
│   │   └── HapticManager.swift             # Haptic feedback manager
│   │
│   └── Constants/
│       ├── AppConstants.swift              # App-wide constants
│       ├── APIConstants.swift              # API endpoints, keys
│       └── DesignConstants.swift           # Design system constants
│
├── Features/
│   ├── VoiceInput/
│   │   ├── Views/
│   │   │   ├── VoiceInputView.swift                    # Main voice input screen
│   │   │   ├── VoiceRecordingButton.swift              # Custom recording button
│   │   │   ├── TranscriptionDisplayView.swift          # Real-time transcription
│   │   │   └── VoiceInputPermissionView.swift          # Permission request UI
│   │   │
│   │   ├── ViewModels/
│   │   │   └── VoiceInputViewModel.swift               # Voice input business logic
│   │   │
│   │   └── Models/
│   │       ├── TranscriptionResult.swift               # Transcription data model
│   │       └── VoiceInputState.swift                   # Voice input state enum
│   │
│   ├── NutritionDisplay/
│   │   ├── Views/
│   │   │   ├── NutritionDisplayView.swift              # Nutrition breakdown display
│   │   │   ├── NutritionCardView.swift                 # Individual nutrient card
│   │   │   ├── MacronutrientRingView.swift             # Circular progress rings
│   │   │   └── FoodItemRowView.swift                   # Food item list row
│   │   │
│   │   ├── ViewModels/
│   │   │   └── NutritionAnalysisViewModel.swift        # Nutrition analysis logic
│   │   │
│   │   └── Models/
│   │       ├── NutritionData.swift                     # Nutrition data structure
│   │       ├── FoodItem.swift                          # Individual food item
│   │       └── MacronutrientBreakdown.swift            # Macro breakdown model
│   │
│   ├── DailyTotals/
│   │   ├── Views/
│   │   │   ├── DailyTotalsView.swift                   # Daily summary screen
│   │   │   ├── DailyProgressView.swift                 # Progress indicators
│   │   │   ├── CalorieGoalView.swift                   # Goal setting/display
│   │   │   └── NutrientBreakdownChartView.swift        # Pie/bar charts
│   │   │
│   │   ├── ViewModels/
│   │   │   └── DailyTotalsViewModel.swift              # Daily totals logic
│   │   │
│   │   └── Models/
│   │       ├── DailyGoal.swift                         # User goals model
│   │       └── DailyProgress.swift                     # Progress tracking
│   │
│   ├── History/
│   │   ├── Views/
│   │   │   ├── CalendarHistoryView.swift               # Calendar view
│   │   │   ├── DayDetailView.swift                     # Single day detail
│   │   │   ├── CalendarDayCell.swift                   # Calendar cell
│   │   │   └── HistoryFilterView.swift                 # Filter options
│   │   │
│   │   ├── ViewModels/
│   │   │   └── HistoryViewModel.swift                  # History management logic
│   │   │
│   │   └── Models/
│   │       ├── HistoryFilter.swift                     # Filter criteria
│   │       └── DateRange.swift                         # Date range model
│   │
│   ├── ManualEntry/
│   │   ├── Views/
│   │   │   ├── ManualEntryView.swift                   # Manual food entry form
│   │   │   ├── FoodSearchView.swift                    # Search ingredients
│   │   │   ├── QuantityInputView.swift                 # Quantity picker
│   │   │   └── NutritionInputView.swift                # Manual nutrition input
│   │   │
│   │   ├── ViewModels/
│   │   │   └── ManualEntryViewModel.swift              # Manual entry logic
│   │   │
│   │   └── Models/
│   │       └── ManualEntryData.swift                   # Manual entry structure
│   │
│   ├── Settings/
│   │   ├── Views/
│   │   │   ├── SettingsView.swift                      # Main settings screen
│   │   │   ├── ProfileSettingsView.swift               # User profile
│   │   │   ├── GoalsSettingsView.swift                 # Goal configuration
│   │   │   ├── PrivacySettingsView.swift               # Privacy controls
│   │   │   ├── NotificationSettingsView.swift          # Notification preferences
│   │   │   ├── HealthKitSettingsView.swift             # HealthKit integration
│   │   │   └── AboutView.swift                         # About/credits
│   │   │
│   │   ├── ViewModels/
│   │   │   └── SettingsViewModel.swift                 # Settings management
│   │   │
│   │   └── Models/
│   │       ├── UserProfile.swift                       # User profile data
│   │       └── AppSettings.swift                       # App settings model
│   │
│   └── Onboarding/
│       ├── Views/
│       │   ├── OnboardingContainerView.swift           # Onboarding flow container
│       │   ├── WelcomeView.swift                       # Welcome screen
│       │   ├── PermissionsView.swift                   # Permissions request
│       │   ├── GoalSetupView.swift                     # Initial goal setup
│       │   └── OnboardingCompleteView.swift            # Completion screen
│       │
│       ├── ViewModels/
│       │   └── OnboardingViewModel.swift               # Onboarding logic
│       │
│       └── Models/
│           └── OnboardingState.swift                   # Onboarding progress
│
├── Services/
│   ├── Speech/
│   │   ├── SpeechRecognitionService.swift              # Speech-to-text service
│   │   ├── AudioEngineManager.swift                    # Audio engine wrapper
│   │   └── SpeechPermissionManager.swift               # Permission handling
│   │
│   ├── LLM/
│   │   ├── LLMService.swift                            # OpenAI API integration
│   │   ├── LLMContextBuilder.swift                     # System prompt builder
│   │   ├── LLMResponseParser.swift                     # JSON response parser
│   │   ├── LLMRequestBuilder.swift                     # Request construction
│   │
│   ├── Database/
│   │   ├── IngredientDatabaseService.swift             # Ingredient queries
│   │   ├── DatabaseSeeder.swift                        # Initial data seeding
│   │   └── IngredientMatcher.swift                     # Fuzzy matching logic
│   │
│   ├── Background/
│   │   ├── BackgroundTaskService.swift                 # BGTaskScheduler wrapper
│   │   ├── MidnightResetHandler.swift                  # Daily rollover logic
│   │   └── DataArchivalService.swift                   # Historical data archival
│   │
│   ├── HealthKit/
│   │   ├── HealthKitService.swift                      # HealthKit integration
│   │   ├── HealthKitPermissionManager.swift            # Permission handling
│   │   └── HealthKitDataExporter.swift                 # Data export to Health
│   │
│   ├── Network/
│   │   ├── NetworkService.swift                        # Base networking layer
│   │   ├── NetworkMonitor.swift                        # Connectivity monitoring
│   │   ├── RequestBuilder.swift                        # HTTP request builder
│   │   └── ResponseHandler.swift                       # Response processing
│   │
│   ├── Cache/
│   │   ├── ResponseCache.swift                         # LLM response cache
│   │   ├── IngredientCache.swift                       # Ingredient cache
│   │   └── CacheManager.swift                          # Cache coordination
│   │
│   ├── Security/
│   │   ├── SecurityService.swift                       # Keychain management
│   │   ├── APIKeyManager.swift                         # API key storage
│   │   └── CertificatePinner.swift                     # Certificate pinning
│   │
│   ├── Analytics/
│   │   ├── AnalyticsService.swift                      # Analytics tracking
│   │   ├── PerformanceMonitor.swift                    # Performance metrics
│   │   └── EventLogger.swift                           # Event logging
│   │
│   └── Sync/
│       ├── SyncService.swift                           # iCloud sync coordination
│       ├── ConflictResolver.swift                      # Sync conflict resolution
│       └── OfflineQueueManager.swift                   # Offline request queue
│
├── Data/
│   ├── Models/
│   │   ├── SwiftData/
│   │   │   ├── FoodEntry.swift                         # @Model FoodEntry
│   │   │   ├── DailyTotal.swift                        # @Model DailyTotal
│   │   │   ├── Ingredient.swift                        # @Model Ingredient
│   │   │   └── UserPreferences.swift                   # @Model UserPreferences
│   │   │
│   │   ├── DTOs/
│   │   │   ├── OpenAIRequest.swift                     # OpenAI API request DTO
│   │   │   ├── OpenAIResponse.swift                    # OpenAI API response DTO
│   │   │   └── HealthKitSample.swift                   # HealthKit data DTO
│   │   │
│   │   └── Enums/
│   │       ├── IngredientCategory.swift                # Ingredient categories
│   │       ├── DataSource.swift                        # Data source types
│   │       ├── VerificationStatus.swift                # Verification states
│   │       ├── EntrySource.swift                       # Entry source (voice/manual)
│   │       └── ErrorType.swift                         # App error types
│   │
│   ├── Repositories/
│   │   ├── FoodEntryRepository.swift                   # Food entry CRUD
│   │   ├── DailyTotalRepository.swift                  # Daily totals CRUD
│   │   ├── IngredientRepository.swift                  # Ingredient CRUD
│   │   └── UserPreferencesRepository.swift             # User prefs CRUD
│   │
│   └── DataSources/
│       ├── LocalDataSource.swift                       # SwiftData operations
│       ├── RemoteDataSource.swift                      # API operations
│       └── CacheDataSource.swift                       # Cache operations
│
├── UI/
│   ├── Components/
│   │   ├── Buttons/
│   │   │   ├── PrimaryButton.swift                     # Primary action button
│   │   │   ├── SecondaryButton.swift                   # Secondary button
│   │   │   └── IconButton.swift                        # Icon-only button
│   │   │
│   │   ├── Cards/
│   │   │   ├── NutritionCard.swift                     # Nutrition info card
│   │   │   ├── FoodEntryCard.swift                     # Food entry card
│   │   │   └── SummaryCard.swift                       # Summary card
│   │   │
│   │   ├── Charts/
│   │   │   ├── MacronutrientPieChart.swift             # Pie chart
│   │   │   ├── CalorieBarChart.swift                   # Bar chart
│   │   │   └── ProgressRing.swift                      # Circular progress
│   │   │
│   │   ├── TextFields/
│   │   │   ├── SearchTextField.swift                   # Search input
│   │   │   ├── NumberTextField.swift                   # Numeric input
│   │   │   └── MultilineTextField.swift                # Text area
│   │   │
│   │   ├── Lists/
│   │   │   ├── FoodEntryList.swift                     # Food entry list
│   │   │   ├── IngredientList.swift                    # Ingredient list
│   │   │   └── EmptyStateView.swift                    # Empty state
│   │   │
│   │   └── Overlays/
│   │       ├── LoadingOverlay.swift                    # Loading indicator
│   │       ├── ErrorOverlay.swift                      # Error display
│   │       └── SuccessToast.swift                      # Success message
│   │
│   ├── Styles/
│   │   ├── ButtonStyles.swift                          # Custom button styles
│   │   ├── TextStyles.swift                            # Text styles
│   │   ├── CardStyles.swift                            # Card styles
│   │   └── ColorScheme.swift                           # Color definitions
│   │
│   ├── Modifiers/
│   │   ├── CardModifier.swift                          # Card styling modifier
│   │   ├── ShimmerModifier.swift                       # Loading shimmer
│   │   └── AccessibilityModifier.swift                 # Accessibility helpers
│   │
│   └── Navigation/
│       ├── AppCoordinator.swift                        # Navigation coordinator
│       ├── NavigationRouter.swift                      # Route definitions
│       └── DeepLinkHandler.swift                       # Deep link handling
│
└── Supporting Files/
    ├── Info.plist                                      # App configuration
    ├── Demeter.entitlements                            # App entitlements
    ├── PrivacyInfo.xcprivacy                           # Privacy manifest
    └── Localizable.strings                             # Localization strings
```

---

### 2. Resources/

```
Resources/
├── Assets.xcassets/
│   ├── AppIcon.appiconset/                             # App icons
│   ├── Colors/
│   │   ├── Primary.colorset/                           # Primary color
│   │   ├── Secondary.colorset/                         # Secondary color
│   │   ├── Background.colorset/                        # Background colors
│   │   └── Text.colorset/                              # Text colors
│   │
│   ├── Images/
│   │   ├── Onboarding/                                 # Onboarding images
│   │   ├── Icons/                                      # Custom icons
│   │   └── Illustrations/                              # Illustrations
│   │
│   └── Symbols/
│       └── CustomSymbols.symbolset/                    # SF Symbols custom
│
├── Fonts/
│   └── (Custom fonts if needed)
│
├── Data/
│   ├── InitialIngredients.json                         # Seed data (50-100 items)
│   ├── IngredientCategories.json                       # Category definitions
│   └── SystemPromptTemplate.txt                        # LLM system prompt
│
└── Localization/
    ├── en.lproj/
    │   └── Localizable.strings                         # English strings
    └── (Other languages as needed)
```

---

### 3. DemeterTests/

```
DemeterTests/
├── UnitTests/
│   ├── Services/
│   │   ├── SpeechRecognitionServiceTests.swift
│   │   ├── LLMServiceTests.swift
│   │   ├── IngredientDatabaseServiceTests.swift
│   │   ├── BackgroundTaskServiceTests.swift
│   │   └── HealthKitServiceTests.swift
│   │
│   ├── ViewModels/
│   │   ├── VoiceInputViewModelTests.swift
│   │   ├── NutritionAnalysisViewModelTests.swift
│   │   ├── DailyTotalsViewModelTests.swift
│   │   └── HistoryViewModelTests.swift
│   │
│   ├── Repositories/
│   │   ├── FoodEntryRepositoryTests.swift
│   │   ├── DailyTotalRepositoryTests.swift
│   │   └── IngredientRepositoryTests.swift
│   │
│   ├── Models/
│   │   ├── FoodEntryTests.swift
│   │   ├── DailyTotalTests.swift
│   │   └── IngredientTests.swift
│   │
│   └── Utilities/
│       ├── DateFormatterTests.swift
│       ├── NumberFormatterTests.swift
│       └── CacheTests.swift
│
├── IntegrationTests/
│   ├── VoiceToLLMIntegrationTests.swift                # Voice → LLM flow
│   ├── LLMToDatabaseIntegrationTests.swift             # LLM → Database flow
│   ├── DailyRolloverIntegrationTests.swift             # Midnight reset flow
│   └── HealthKitSyncIntegrationTests.swift             # HealthKit sync flow
│
├── Mocks/
│   ├── MockSpeechRecognitionService.swift
│   ├── MockLLMService.swift
│   ├── MockNetworkService.swift
│   ├── MockHealthKitService.swift
│   └── MockModelContext.swift
│
└── Fixtures/
    ├── MockAudioFiles/
    │   ├── chicken_breast.wav
    │   └── mixed_meal.wav
    │
    ├── MockResponses/
    │   ├── openai_success_response.json
    │   └── openai_error_response.json
    │
    └── TestData/
        ├── test_ingredients.json
        └── test_food_entries.json
```

---

### 4. DemeterUITests/

```
DemeterUITests/
├── Flows/
│   ├── OnboardingFlowTests.swift                       # Onboarding flow
│   ├── VoiceInputFlowTests.swift                       # Voice input flow
│   ├── ManualEntryFlowTests.swift                      # Manual entry flow
│   └── HistoryNavigationTests.swift                    # History navigation
│
├── Screens/
│   ├── VoiceInputScreenTests.swift
│   ├── DailyTotalsScreenTests.swift
│   ├── CalendarHistoryScreenTests.swift
│   └── SettingsScreenTests.swift
│
├── Accessibility/
│   ├── VoiceOverTests.swift                            # VoiceOver support
│   ├── DynamicTypeTests.swift                          # Dynamic Type
│   └── ColorContrastTests.swift                        # High contrast
│
└── Helpers/
    ├── UITestHelpers.swift                             # Test utilities
    └── ScreenObjects/                                  # Page objects
        ├── VoiceInputScreen.swift
        ├── DailyTotalsScreen.swift
        └── SettingsScreen.swift
```

---

### 5. Documentation/

```
Documentation/
├── Architecture/
│   ├── ARCHITECTURE.md                                 # Architecture overview
│   ├── DATA_FLOW.md                                    # Data flow diagrams
│   ├── MVVM_PATTERN.md                                 # MVVM implementation
│   └── REPOSITORY_PATTERN.md                           # Repository pattern
│
├── API/
│   ├── OPENAI_INTEGRATION.md                           # OpenAI API docs
│   ├── HEALTHKIT_INTEGRATION.md                        # HealthKit docs
│   └── API_SPECIFICATIONS.md                           # API specs
│
├── Features/
│   ├── VOICE_INPUT.md                                  # Voice input feature
│   ├── LLM_PROCESSING.md                               # LLM processing
│   ├── DAILY_TOTALS.md                                 # Daily totals
│   └── HISTORY.md                                      # History feature
│
├── Development/
│   ├── SETUP.md                                        # Development setup
│   ├── CODING_STANDARDS.md                             # Code standards
│   ├── TESTING_GUIDE.md                                # Testing guidelines
│   └── DEPLOYMENT.md                                   # Deployment process
│
└── User/
    ├── USER_GUIDE.md                                   # User documentation
    ├── PRIVACY_POLICY.md                               # Privacy policy
    └── TERMS_OF_SERVICE.md                             # Terms of service
```

---

### 6. Scripts/

```
Scripts/
├── setup.sh                                            # Initial project setup
├── seed_database.swift                                 # Database seeding script
├── generate_mocks.sh                                   # Mock generation
├── run_tests.sh                                        # Test execution
├── build.sh                                            # Build automation
└── deploy.sh                                           # Deployment script
```

---

### 7. Configuration/

```
Configuration/
├── Debug.xcconfig                                      # Debug configuration
├── Release.xcconfig                                    # Release configuration
├── Staging.xcconfig                                    # Staging configuration
└── Secrets.xcconfig.template                           # API keys template
```

---

## Key Files by Layer

### Presentation Layer (SwiftUI Views)
- **Purpose**: User interface components
- **Location**: `Demeter/Features/*/Views/`
- **Examples**: `VoiceInputView.swift`, `DailyTotalsView.swift`

### Business Logic Layer (ViewModels)
- **Purpose**: Business logic, state management
- **Location**: `Demeter/Features/*/ViewModels/`
- **Examples**: `VoiceInputViewModel.swift`, `NutritionAnalysisViewModel.swift`

### Service Layer
- **Purpose**: External integrations, business services
- **Location**: `Demeter/Services/`
- **Examples**: `SpeechRecognitionService.swift`, `LLMService.swift`

### Data Layer
- **Purpose**: Data persistence, models
- **Location**: `Demeter/Data/`
- **Examples**: `FoodEntry.swift`, `FoodEntryRepository.swift`

---

## Critical Files for MVP

### Must-Have Files (Week 1-2)
1. `DemeterApp.swift` - App entry point
2. `FoodEntry.swift` - Core data model
3. `DailyTotal.swift` - Daily aggregation model
4. `Ingredient.swift` - Ingredient model
5. `SpeechRecognitionService.swift` - Voice input
6. `LLMService.swift` - OpenAI integration
7. `VoiceInputView.swift` - Main UI
8. `VoiceInputViewModel.swift` - Voice logic
9. `Info.plist` - App configuration
10. `PrivacyInfo.xcprivacy` - Privacy manifest

### Important Files (Week 3-4)
11. `NutritionDisplayView.swift` - Nutrition display
12. `DailyTotalsView.swift` - Daily summary
13. `CalendarHistoryView.swift` - History view
14. `IngredientDatabaseService.swift` - Database queries
15. `BackgroundTaskService.swift` - Midnight reset
16. `FoodEntryRepository.swift` - Data access
17. `InitialIngredients.json` - Seed data

### Nice-to-Have Files (Week 5-8)
18. `HealthKitService.swift` - HealthKit integration
19. `ManualEntryView.swift` - Manual entry fallback
20. `SettingsView.swift` - Settings screen
21. `OnboardingContainerView.swift` - Onboarding flow
22. `AnalyticsService.swift` - Analytics tracking

---

## File Naming Conventions

### Swift Files
- **Views**: `*View.swift` (e.g., `VoiceInputView.swift`)
- **ViewModels**: `*ViewModel.swift` (e.g., `VoiceInputViewModel.swift`)
- **Services**: `*Service.swift` (e.g., `LLMService.swift`)
- **Repositories**: `*Repository.swift` (e.g., `FoodEntryRepository.swift`)
- **Models**: Descriptive names (e.g., `FoodEntry.swift`, `Ingredient.swift`)
- **Extensions**: `Type+Extensions.swift` (e.g., `Date+Extensions.swift`)
- **Protocols**: `*Protocol.swift` or `*able.swift` (e.g., `Cacheable.swift`)

### Test Files
- **Unit Tests**: `*Tests.swift` (e.g., `LLMServiceTests.swift`)
- **UI Tests**: `*UITests.swift` (e.g., `VoiceInputFlowUITests.swift`)
- **Mocks**: `Mock*.swift` (e.g., `MockLLMService.swift`)

### Resource Files
- **JSON Data**: `snake_case.json` (e.g., `initial_ingredients.json`)
- **Images**: `kebab-case.png` (e.g., `app-icon.png`)
- **Localization**: `Localizable.strings`

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         Demeter iOS App                          │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │              Presentation Layer (SwiftUI)               │    │
│  │  Features/*/Views/                                      │    │
│  │  - VoiceInputView, DailyTotalsView, etc.               │    │
│  └────────────────────────────────────────────────────────┘    │
│                            ↕                                     │
│  ┌────────────────────────────────────────────────────────┐    │
│  │         Business Logic Layer (ViewModels)               │    │
│  │  Features/*/ViewModels/                                 │    │
│  │  - VoiceInputViewModel, NutritionAnalysisViewModel     │    │
│  └────────────────────────────────────────────────────────┘    │
│                            ↕                                     │
│  ┌────────────────────────────────────────────────────────┐    │
│  │                  Service Layer                          │    │
│  │  Services/                                              │    │
│  │  - Speech/, LLM/, Database/, Background/, etc.         │    │
│  └────────────────────────────────────────────────────────┘    │
│                            ↕                                     │
│  ┌────────────────────────────────────────────────────────┐    │
│  │                   Data Layer                            │    │
│  │  Data/Models/, Data/Repositories/                       │    │
│  │  - SwiftData Models, Repository Pattern                │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

---

## Next Steps

1. **Create Xcode Project**: Initialize new iOS project with SwiftUI
2. **Set Up Folder Structure**: Create all folders as defined above
3. **Configure Build Settings**: Set up configurations, entitlements
4. **Add Dependencies**: Configure SPM packages if needed
5. **Create Core Files**: Start with critical MVP files
6. **Set Up Testing**: Configure test targets and frameworks
7. **Initialize Git**: Set up version control with proper .gitignore

---

## Notes

- All file paths are relative to the project root
- SwiftData models use `@Model` macro (iOS 17+)
- Follow MVVM pattern strictly for maintainability
- Repository pattern abstracts data access
- Feature-based organization for scalability
- Comprehensive testing structure (80%+ coverage target)
- Privacy-first approach with explicit manifests
- Modular design for future enhancements

---

**Document Version**: 1.0.0  
**Created**: 2025-10-26  
**Based On**: Technical Constitution v1.0.0  
**Status**: ✅ Ready for Implementation