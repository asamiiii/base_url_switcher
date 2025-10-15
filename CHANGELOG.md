# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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