# Base URL Switcher

A beautiful and easy-to-use Flutter package for switching between base URLs with a stunning UI switcher.

[![pub package](https://img.shields.io/pub/v/base_url_switcher.svg)](https://pub.dev/packages/base_url_switcher)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- 🎨 **Beautiful UI Switcher** - Elegant environment switcher widget
- 🔧 **Easy Configuration** - Simple setup with default environments
- 💾 **Persistent Storage** - Remembers your environment choice
- 🎯 **Type Safety** - Full type safety with Dart
- 🧪 **Well Tested** - Comprehensive test coverage
- 📱 **Responsive Design** - Works on all screen sizes
- 🚀 **Lightweight** - Minimal dependencies

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  base_url_switcher: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Initialize the Service

```dart
import 'package:base_url_switcher/base_url_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the EnvService
  await EnvService.initialize();
  
  runApp(MyApp());
}
```

### 2. Use the Environment Switcher

```dart
import 'package:base_url_switcher/base_url_switcher.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
          actions: [
            // Add environment switcher to app bar
            EnvSwitcher(
              onEnvironmentChanged: (env) {
                print('Switched to ${env.name}');
              },
            ),
          ],
        ),
        body: MyHomePage(),
      ),
    );
  }
}
```

### 3. Access Current Environment

```dart
final envService = EnvService.instance;

// Get current environment
final currentEnv = envService.currentEnvironment;
print('Current environment: ${currentEnv.name}');
print('Base URL: ${currentEnv.baseUrl}');

// Get current base URL directly
final baseUrl = envService.currentBaseUrl;

// Get configuration values
final timeout = envService.getConfigValue<int>('timeout');
```

## Default Environments

The package comes with three default environments:

- **Development** - `https://dev-api.example.com`
- **Staging** - `https://staging-api.example.com`
- **Production** - `https://api.example.com`

## Customization

### Custom Environments

```dart
final envService = EnvService.instance;

// Add custom environment
const customEnv = Environment(
  name: 'Custom',
  baseUrl: 'https://custom-api.com',
  description: 'Custom environment for testing',
  config: {
    'timeout': 30,
    'retries': 3,
  },
);

await envService.addEnvironment(customEnv);
```

### Custom Styling

```dart
EnvSwitcher(
  style: EnvSwitcherStyle(
    backgroundColor: Colors.blue,
    iconColor: Colors.white,
    borderRadius: BorderRadius.circular(12),
    elevation: 4,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  onEnvironmentChanged: (env) {
    // Handle environment change
  },
)
```

### Environment Configuration

```dart
// Set configuration values
await envService.setConfigValue('api_key', 'your-api-key');
await envService.setConfigValue('timeout', 30);

// Get configuration values
final apiKey = envService.getConfigValue<String>('api_key');
final timeout = envService.getConfigValue<int>('timeout');
```

## Advanced Usage

### Programmatic Environment Switching

```dart
// Switch environment programmatically
await envService.setEnvironment('staging');

// Get specific environment
final stagingEnv = envService.getEnvironment('staging');

// Check if environment exists
if (envService.hasEnvironment('custom')) {
  // Do something
}
```

### Environment Management

```dart
// Update existing environment
const updatedEnv = Environment(
  name: 'development',
  baseUrl: 'https://new-dev-api.com',
  description: 'Updated development environment',
);

await envService.updateEnvironment('development', updatedEnv);

// Remove environment
await envService.removeEnvironment('old-environment');

// Reset to defaults
await envService.resetToDefaults();
```

### Show in Release Mode

By default, the environment switcher only shows in debug mode. To show it in release mode:

```dart
EnvSwitcher(
  showInRelease: true, // Show in release mode
  onEnvironmentChanged: (env) {
    // Handle environment change
  },
)
```

## API Reference

### Environment Class

```dart
class Environment {
  final String name;           // Environment name
  final String baseUrl;        // Base URL for API calls
  final Map<String, dynamic> config;  // Additional configuration
  final bool isDefault;        // Whether this is the default environment
  final String? description;   // Optional description
}
```

### EnvService Class

```dart
class EnvService {
  // Singleton instance
  static EnvService get instance;
  
  // Initialize the service
  static Future<void> initialize();
  
  // Environment management
  Map<String, Environment> get environments;
  Environment get currentEnvironment;
  Future<void> setEnvironment(String envName);
  
  // Environment CRUD operations
  Future<void> addEnvironment(Environment environment);
  Future<void> updateEnvironment(String envName, Environment environment);
  Future<void> removeEnvironment(String envName);
  
  // Utility methods
  Environment? getEnvironment(String envName);
  bool hasEnvironment(String envName);
  String get currentBaseUrl;
  String get currentEnvironmentName;
  
  // Configuration management
  T? getConfigValue<T>(String key);
  Future<void> setConfigValue(String key, dynamic value);
  
  // Data management
  Future<void> resetToDefaults();
  Future<void> clear();
}
```

### EnvSwitcher Widget

```dart
class EnvSwitcher extends StatefulWidget {
  final Function(Environment)? onEnvironmentChanged;
  final bool showInRelease;
  final EnvSwitcherStyle? style;
  final bool showDescriptions;
  final IconData? icon;
}
```

### EnvSwitcherStyle Class

```dart
class EnvSwitcherStyle {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;
  final BorderRadius borderRadius;
  final Border? border;
  final double elevation;
  final TextStyle titleTextStyle;
  final TextStyle descriptionTextStyle;
  final TextStyle dialogTitleStyle;
}
```

## Example App

Check out the example app in the `example/` directory to see the package in action.

```bash
cd example
flutter run
```

## Testing

Run the tests:

```bash
flutter test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package helpful, please give it a ⭐ on [pub.dev](https://pub.dev/packages/env_manager)!

## Changelog

### 1.0.0
- Initial release
- Environment management with persistent storage
- Beautiful UI switcher widget
- Comprehensive test coverage
- Full documentation

---

Made with ❤️ for the Flutter community