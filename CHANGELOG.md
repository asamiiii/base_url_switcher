# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.1] - 2025-01-15

### Changed
- 🎯 **Removed defaultEnvironment Parameter** - No longer needed, production is always the default
- 🚀 **Production as Default** - Production environment is now always the default when available
- 📝 **Simplified API** - `EnvService.initialize()` no longer requires `defaultEnvironment` parameter

### Fixed
- 🐛 **Default Environment Behavior** - Fixed issue where default environment was always used on app restart
- 🎯 **User Selection Persistence** - Default environment is now only used on first app launch
- 💾 **Environment Memory** - Selected environment is remembered after user changes it
- ✅ **Smart Default Logic** - Once user selects an environment, it persists across app restarts

### Technical Details
- Added `has_user_selected_environment` flag to track user selections
- Default environment is only used when `hasUserSelected` is false (first time)
- After user changes environment, the selection is saved and persists
- Reset to defaults now properly clears user selection flag

## [2.2.0] - 2025-01-15

### Added
- 🎯 **Automatic Toggle State Management** - Configuration items now manage their own toggle state automatically!
- ✨ **Simplified Configuration API** - No need for external state management (`setState` not required!)
- 🔄 **State Callback** - `onTap` callback receives the new state as `(bool newState)` parameter
- 🎨 **Better UX** - Toggle buttons update automatically when tapped

### Changed
- `ConfigurationItem.onTap` now receives `(bool newState)` parameter instead of `VoidCallback`
- Removed `configurationsBuilder` parameter (no longer needed)
- Improved internal state management for configuration items

### Features
- **Auto Toggle**: Switch buttons change automatically when tapped
- **Initial Value**: Set initial state via `enabled` parameter
- **No External State**: No need for `setState` or state variables
- **State Callback**: Receive new state in `onTap` callback

### Example
```dart
ConfigurationItem(
  title: 'Network Inspector',
  enabled: ChuckerFlutter.showOnRelease, // Initial value
  onTap: (newState) {
    // Toggle happens automatically!
    // newState is the new enabled state
    ChuckerFlutter.showOnRelease = newState;
  },
)
```

### Removed
- `configurationsBuilder` parameter (replaced by automatic state management)

## [2.1.2] - 2025-01-15

### Documentation
- 📚 **Improved README** - Added clear examples showing where to wrap `SimpleBaseUrlWrapper`
- 💡 **Better Examples** - Added multiple examples for different use cases
- 🎯 **Clearer Instructions** - Explained exactly where users should tap to access settings

### Examples Added
- Wrap entire app body
- Wrap specific logo/button
- Wrap custom area with tap instructions

## [2.1.1] - 2025-01-15

### Fixed
- 🐛 **Critical Bug Fix** - Fixed "Environment not found" error when setting default environment
- 🔧 **Case Sensitivity** - Fixed case sensitivity issues in environment lookup
- 🧹 **Empty State Handling** - Added proper handling for empty environments map
- ✅ **Test Coverage** - All tests now pass successfully

### Technical Details
- Fixed `setEnvironment()` method to use lowercase keys consistently
- Fixed `currentEnvironment` getter to handle empty environments map
- Fixed `clear()` method to properly clear in-memory environments
- Added fallback environment when no environments exist

## [2.1.0] - 2025-01-15

### Added
- 🎯 **EnvironmentType Enum** - Type-safe environment management
- 🔧 **Enhanced Type Safety** - No more string typos in environment names
- 📝 **Auto-completion Support** - IDE support for environment types
- 🎨 **Display Name Extensions** - Automatic formatting for environment names

### Changed
- `EnvService.initialize()` now accepts `EnvironmentType` instead of strings
- All environment creation methods use enum for consistency
- Improved type safety throughout the package

### New Features
- `EnvironmentType` enum with `development`, `staging`, `production`, `local`
- Extension methods for display names and descriptions
- Type-safe environment initialization

### Breaking Changes
- `EnvService.initialize(defaultEnvironment: String)` → `EnvService.initialize(defaultEnvironment: EnvironmentType)`

## [2.0.0] - 2025-01-15

### Added
- 🚀 **Ultra Simple Usage** - Just wrap your widget with `SimpleBaseUrlWrapper`
- 🔐 **Hidden Access** - Tap multiple times to access settings
- 🔒 **Password Protection** - Secure access with customizable password
- 📱 **Ready-to-Use Screen** - Complete `EnvSwitcherScreen` included
- 🎯 **Environment Indicator** - Show current environment in UI
- 📊 **Environment Info Widget** - Display environment details
- 🔧 **BaseUrlManager** - Simplified API for accessing current Base URL
- 🎨 **Enhanced UI** - Beautiful and responsive design
- 📚 **Comprehensive Examples** - Multiple usage examples included

### Changed
- Simplified API with `BaseUrlManager` for easier access
- Enhanced UI components with better styling
- Improved documentation with ultra-simple usage examples
- Better error handling and user feedback

### New Widgets
- `SimpleBaseUrlWrapper` - Ultra-simple wrapper widget
- `BaseUrlWrapper` - Full-featured wrapper with customization
- `EnvironmentIndicator` - Show current environment in UI
- `EnvironmentInfo` - Display environment details

### Breaking Changes
- None - fully backward compatible

## [1.0.0] - 2025-01-15

### Added
- Initial release of Env Manager package
- Environment model with full configuration support
- EnvService singleton for environment management
- Beautiful EnvSwitcher UI widget
- Persistent storage using SharedPreferences
- Support for custom environments
- Configuration value management
- Comprehensive test coverage (21 tests)
- Complete documentation and examples
- Support for environment descriptions
- Default environment indicator
- Custom styling options for UI components
- Programmatic environment switching
- Environment validation and error handling

### Features
- 🎨 Beautiful UI Switcher with customizable styling
- 🔧 Easy configuration with default environments
- 💾 Persistent storage that remembers environment choice
- 🎯 Full type safety with Dart
- 🧪 Comprehensive test coverage
- 📱 Responsive design for all screen sizes
- 🚀 Lightweight with minimal dependencies
- 🔄 Hot reload support for environment changes
- 🛡️ Error handling and validation
- 📚 Complete documentation and examples

### Technical Details
- Built with Flutter 3.0+
- Uses SharedPreferences for persistence
- Singleton pattern for service management
- Material Design 3 components
- Full widget testing support
- Mock-friendly architecture for testing