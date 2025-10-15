# دليل استخدام Base URL Switcher

## 🚀 الاستخدام الأساسي

### 1. إضافة الباكدج للتطبيق

```yaml
# في pubspec.yaml
dependencies:
  base_url_switcher: ^1.0.0
  http: ^1.1.0  # للـ HTTP requests
```

### 2. تهيئة الباكدج

```dart
// في main.dart
import 'package:base_url_switcher/base_url_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة الخدمة
  await EnvService.initialize();
  
  runApp(MyApp());
}
```

### 3. استخدام الـ Base URL في API Calls

```dart
import 'package:http/http.dart' as http;
import 'package:base_url_switcher/base_url_switcher.dart';

// الحصول على الـ Base URL الحالي
final baseUrl = BaseUrlManager.instance.currentBaseUrl;

// استخدامه في HTTP request
final response = await http.get(
  Uri.parse('$baseUrl/api/users'),
);
```

## 📱 إضافة صفحة تبديل البيئات

### 1. إضافة زر في AppBar

```dart
AppBar(
  title: Text('My App'),
  actions: [
    IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnvSwitcherScreen(
              title: 'Environment Settings',
              icon: Icons.swap_horiz,
              primaryColor: Colors.blue,
              onEnvironmentChanged: (env) {
                print('Switched to ${env.name}');
                // إعادة جلب البيانات بالـ Base URL الجديد
                _refreshData();
              },
            ),
          ),
        );
      },
    ),
  ],
)
```

### 2. عرض معلومات البيئة الحالية

```dart
// في أي مكان في التطبيق
Text('Current Environment: ${BaseUrlManager.instance.currentEnvironmentName}');
Text('Base URL: ${BaseUrlManager.instance.currentBaseUrl}');
```

## 🔧 إنشاء API Service

### 1. API Service مع HTTP

```dart
import 'package:http/http.dart' as http;
import 'package:base_url_switcher/base_url_switcher.dart';

class ApiService {
  static String get baseUrl => BaseUrlManager.instance.currentBaseUrl;
  
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data');
    }
  }
}
```

### 2. API Service مع Dio

```dart
import 'package:dio/dio.dart';
import 'package:base_url_switcher/base_url_switcher.dart';

class DioService {
  static Dio? _dio;
  
  static Dio get dio {
    _dio ??= Dio();
    return _dio!;
  }

  static void setupDio() {
    dio.options.baseUrl = BaseUrlManager.instance.currentBaseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
  }

  static void updateBaseUrl() {
    dio.options.baseUrl = BaseUrlManager.instance.currentBaseUrl;
  }
}
```

## 🎨 تخصيص البيئات

### 1. إضافة بيئة مخصصة

```dart
// إنشاء بيئة مخصصة
final customEnv = BaseUrlManager.createDevelopmentEnv(
  baseUrl: 'https://your-api.com',
  description: 'Your custom API',
);

// إضافتها للخدمة
await BaseUrlManager.instance.addEnvironment(customEnv);

// تعيينها كافتراضي
await BaseUrlManager.instance.setEnvironment('Development');
```

### 2. إنشاء بيئات متعددة

```dart
// بيئة التطوير
final devEnv = BaseUrlManager.createDevelopmentEnv(
  baseUrl: 'https://dev-api.example.com',
  description: 'Development environment',
);

// بيئة الإنتاج
final prodEnv = BaseUrlManager.createProductionEnv(
  baseUrl: 'https://api.example.com',
  description: 'Production environment',
);

// إضافة البيئات
await BaseUrlManager.instance.addEnvironment(devEnv);
await BaseUrlManager.instance.addEnvironment(prodEnv);
```

## 🔄 التعامل مع تغيير البيئة

### 1. في Provider/Bloc

```dart
class DataProvider extends ChangeNotifier {
  Future<void> refreshData() async {
    // إعادة جلب البيانات بالـ Base URL الجديد
    final data = await ApiService.get('/api/data');
    // تحديث الـ state
    notifyListeners();
  }
}
```

### 2. في StatefulWidget

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void _onEnvironmentChanged(Environment env) {
    // إعادة جلب البيانات
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await ApiService.get('/api/data');
    setState(() {
      // تحديث الـ state
    });
  }
}
```

## 🎯 نصائح للاستخدام

### 1. دائماً استخدم BaseUrlManager.instance.currentBaseUrl

```dart
// ✅ صحيح
final url = BaseUrlManager.instance.currentBaseUrl;

// ❌ خطأ - لا تستخدم URL ثابت
final url = 'https://api.example.com';
```

### 2. أعد جلب البيانات عند تغيير البيئة

```dart
void _onEnvironmentChanged(Environment env) {
  // إعادة جلب البيانات
  _refreshData();
}
```

### 3. استخدم try-catch للتعامل مع الأخطاء

```dart
try {
  final data = await ApiService.get('/api/data');
} catch (e) {
  print('Error: $e');
  // التعامل مع الخطأ
}
```

### 4. اعرض معلومات البيئة للمستخدم

```dart
// في AppBar أو أي مكان مناسب
Text('Environment: ${BaseUrlManager.instance.currentEnvironmentName}')
```

## 📝 أمثلة كاملة

راجع الملفات التالية في مجلد `example/lib/`:
- `api_service_example.dart` - مثال على API Service
- `dio_service_example.dart` - مثال على Dio Service
- `complete_app_example.dart` - مثال كامل للتطبيق
- `simple_usage_example.dart` - مثال مبسط

## 🆘 حل المشاكل الشائعة

### 1. Base URL لا يتحدث
```dart
// تأكد من تهيئة الخدمة
await EnvService.initialize();

// تأكد من استخدام BaseUrlManager.instance.currentBaseUrl
final url = BaseUrlManager.instance.currentBaseUrl;
```

### 2. البيانات لا تتحدث عند تغيير البيئة
```dart
// أعد جلب البيانات في onEnvironmentChanged
void _onEnvironmentChanged(Environment env) {
  _refreshData();
}
```

### 3. خطأ في HTTP requests
```dart
// تأكد من إضافة http dependency
dependencies:
  http: ^1.1.0
```
