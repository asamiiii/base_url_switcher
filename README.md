# Base URL Switcher

**The simplest way to switch Base URLs in Flutter** 🚀

[![pub package](https://img.shields.io/pub/v/base_url_switcher.svg)](https://pub.dev/packages/base_url_switcher)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ⚡ Ultra Simple - Just 3 Steps!

### 1️⃣ Add the Package
```yaml
dependencies:
  base_url_switcher: ^2.1.2
```

### 2️⃣ Add URLs in main.dart
```dart
import 'package:base_url_switcher/base_url_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Just add URLs - everything else is automatic!
  await EnvService.initialize(
    developmentUrl: 'https://dev-api.mycompany.com',
    productionUrl: 'https://api.mycompany.com',
    defaultEnvironment: EnvironmentType.development,
  );
  
  runApp(MyApp());
}
```

### 3️⃣ Wrap the Widget You Want to Tap
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('My App')),
        body: SimpleBaseUrlWrapper(
          // Wrap the widget that users will tap on to access settings
          child: YourWidget(),
        ),
      ),
    );
  }
}
```

**💡 Important:** The `SimpleBaseUrlWrapper` should wrap the widget that users will tap on to access the environment settings. This could be:
- The entire body of your app
- A specific button or logo  
- Any interactive widget where you want the hidden access

## 🎯 How It Works?

1. **Tap 7 times** on the wrapped widget (the one inside `SimpleBaseUrlWrapper`)
2. **Enter password** (default: "admin")
3. **Switch environment** and use the new Base URL

**📍 Where to tap:** Users tap on the widget that's wrapped with `SimpleBaseUrlWrapper`. This could be your app's body, a logo, or any specific area you choose.

## 💻 Using Base URL in Code

```dart
// Anywhere in your app
final url = BaseUrlManager.instance.currentBaseUrl;
final response = await http.get(Uri.parse('$url/api/users'));
```

## 🎨 Customize Access

```dart
// Example 1: Wrap entire app body
SimpleBaseUrlWrapper(
  password: "myapp123", // Custom password
  tapCount: 5, // 5 taps instead of 7
  child: YourWidget(),
)

// Example 2: Wrap only a specific logo/button
SimpleBaseUrlWrapper(
  child: Image.asset('assets/logo.png'), // Users tap on logo
)

// Example 3: Wrap a specific area
SimpleBaseUrlWrapper(
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
    child: Center(child: Text('Tap here')),
  ),
)
```

## 📱 Show Environment Info

```dart
AppBar(
  title: Text('My App'),
  actions: [
    EnvironmentIndicator(), // Current environment indicator
  ],
)

// Or anywhere
EnvironmentInfo(
  showBaseUrl: true,
  showDescription: true,
)
```

## 🌟 Features

- ✅ **Setup in 3 steps** - No more!
- ✅ **Hidden access** - Multiple taps to access
- ✅ **Password protection** - Customizable
- ✅ **Ready-to-use screen** - No coding needed
- ✅ **Auto save** - Remembers your choice
- ✅ **Environment indicator** - Shows current environment
- ✅ **Comprehensive tests** - 21/21 tests passed

## 🔧 Advanced Setup

### Add Staging Environment
```dart
await EnvService.initialize(
  developmentUrl: 'https://dev-api.com',
  productionUrl: 'https://api.com',
  stagingUrl: 'https://staging-api.com', // Optional
  defaultEnvironment: EnvironmentType.development,
);
```

### Access Settings Manually
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EnvSwitcherScreen(),
  ),
);
```

### Use Widget Instead of Wrapper
```dart
AppBar(
  actions: [
    EnvSwitcher(
      onEnvironmentChanged: (env) {
        print('Switched to ${env.name}');
      },
    ),
  ],
)
```

## 📋 API Reference

### EnvService.initialize()
```dart
static Future<void> initialize({
  String? developmentUrl,    // Development environment URL
  String? productionUrl,     // Production environment URL
  String? stagingUrl,        // Staging environment URL (optional)
  EnvironmentType? defaultEnvironment, // Default environment
});
```

### BaseUrlManager
```dart
// Get current Base URL
String get currentBaseUrl;

// Get current environment name
String get currentEnvironmentName;

// Get current environment object
Environment get currentEnvironment;
```

### EnvironmentType Enum
```dart
enum EnvironmentType {
  development,
  staging,
  production,
  local,
}

// Usage
EnvironmentType.development.displayName  // "Development"
EnvironmentType.production.description   // "Production environment"
```

### SimpleBaseUrlWrapper
```dart
class SimpleBaseUrlWrapper extends StatelessWidget {
  final Widget child;        // Widget to wrap
  final String? password;    // Password (default: "admin")
  final int? tapCount;       // Number of taps (default: 7)
}
```

## 🚀 Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:base_url_switcher/base_url_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await EnvService.initialize(
    developmentUrl: 'https://dev-api.mycompany.com',
    productionUrl: 'https://api.mycompany.com',
    defaultEnvironment: EnvironmentType.development,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My App'),
          actions: [EnvironmentIndicator()],
        ),
        body: SimpleBaseUrlWrapper(
          password: "myapp123",
          tapCount: 5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Current Environment: ${BaseUrlManager.instance.currentEnvironmentName}'),
                Text('Base URL: ${BaseUrlManager.instance.currentBaseUrl}'),
                ElevatedButton(
                  onPressed: () async {
                    final response = await http.get(
                      Uri.parse('${BaseUrlManager.instance.currentBaseUrl}/api/users'),
                    );
                    print('Response: ${response.body}');
                  },
                  child: Text('Test API Call'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## 📦 Installation

```bash
flutter pub add base_url_switcher
```

## 🧪 Testing

```bash
flutter test
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## ⭐ Support

If you find this package helpful, please give it a ⭐ on [pub.dev](https://pub.dev/packages/base_url_switcher)!

---

**Made with ❤️ for the Flutter community**