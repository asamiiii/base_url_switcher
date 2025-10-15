# دليل تخصيص البيئات والـ Base URLs

## 🎯 الطرق المختلفة لتحديد الـ Base URLs

### 1. **الطريقة الأساسية - في main.dart (مُوصى بها)**

```dart
import 'package:flutter/material.dart';
import 'package:base_url_switcher/base_url_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة الخدمة
  await EnvService.initialize();
  
  // تخصيص البيئات
  await _setupCustomEnvironments();
  
  runApp(MyApp());
}

Future<void> _setupCustomEnvironments() async {
  final envManager = BaseUrlManager.instance;
  
  // إنشاء البيئات
  final environments = [
    // بيئة التطوير
    BaseUrlManager.createDevelopmentEnv(
      baseUrl: 'https://dev-api.mycompany.com',
      description: 'Development environment',
      config: {
        'timeout': 30,
        'retries': 3,
        'debug': true,
        'api_key': 'dev_key_123',
      },
    ),
    
    // بيئة الإنتاج
    BaseUrlManager.createProductionEnv(
      baseUrl: 'https://api.mycompany.com',
      description: 'Production environment',
      config: {
        'timeout': 15,
        'retries': 1,
        'debug': false,
        'api_key': 'prod_key_789',
      },
    ),
    
    // بيئة محلية
    BaseUrlManager.createCustomEnv(
      name: 'Local',
      baseUrl: 'http://localhost:3000',
      description: 'Local development server',
      config: {
        'timeout': 10,
        'retries': 5,
        'debug': true,
        'api_key': 'local_key_000',
      },
      isDefault: true, // جعلها افتراضية
    ),
  ];
  
  // إضافة البيئات
  for (final env in environments) {
    await envManager.addEnvironment(env);
  }
  
  // تعيين البيئة الافتراضية
  await envManager.setEnvironment('Local');
}
```

### 2. **الطريقة المتقدمة - مع إعدادات مفصلة**

```dart
Future<void> _setupAdvancedEnvironments() async {
  final envManager = BaseUrlManager.instance;
  
  // بيئة التطوير مع إعدادات مفصلة
  const devEnv = Environment(
    name: 'Development',
    baseUrl: 'https://dev-api.mycompany.com',
    description: 'Development environment for testing new features',
    config: {
      'timeout': 30,
      'retries': 3,
      'debug': true,
      'api_key': 'dev_key_123',
      'enable_logging': true,
      'max_requests_per_minute': 100,
      'cache_duration': 300, // 5 minutes
    },
    isDefault: false,
  );
  
  // بيئة الإنتاج مع إعدادات مفصلة
  const prodEnv = Environment(
    name: 'Production',
    baseUrl: 'https://api.mycompany.com',
    description: 'Production environment - Live API',
    config: {
      'timeout': 15,
      'retries': 1,
      'debug': false,
      'api_key': 'prod_key_789',
      'enable_logging': false,
      'max_requests_per_minute': 1000,
      'cache_duration': 600, // 10 minutes
    },
    isDefault: true,
  );
  
  // إضافة البيئات
  await envManager.addEnvironment(devEnv);
  await envManager.addEnvironment(prodEnv);
  
  // تعيين البيئة الافتراضية
  await envManager.setEnvironment('Production');
}
```

### 3. **الطريقة الديناميكية - من ملف JSON**

```dart
Future<void> _setupEnvironmentsFromJson() async {
  final envManager = BaseUrlManager.instance;
  
  // قراءة الإعدادات من ملف JSON
  final jsonString = await rootBundle.loadString('assets/config/environments.json');
  final jsonData = json.decode(jsonString);
  
  for (final envData in jsonData['environments']) {
    final env = Environment.fromJson(envData);
    await envManager.addEnvironment(env);
  }
  
  // تعيين البيئة الافتراضية
  final defaultEnv = jsonData['default_environment'] as String;
  await envManager.setEnvironment(defaultEnv);
}
```

### 4. **الطريقة الشرطية - حسب نوع البناء**

```dart
Future<void> _setupEnvironmentsByBuildType() async {
  final envManager = BaseUrlManager.instance;
  
  // تحديد البيئات حسب نوع البناء
  if (kDebugMode) {
    // بيئة التطوير
    await envManager.addEnvironment(
      BaseUrlManager.createDevelopmentEnv(
        baseUrl: 'https://dev-api.mycompany.com',
        description: 'Debug mode - Development environment',
      ),
    );
    await envManager.setEnvironment('Development');
  } else if (kProfileMode) {
    // بيئة التجريب
    await envManager.addEnvironment(
      BaseUrlManager.createStagingEnv(
        baseUrl: 'https://staging-api.mycompany.com',
        description: 'Profile mode - Staging environment',
      ),
    );
    await envManager.setEnvironment('Staging');
  } else {
    // بيئة الإنتاج
    await envManager.addEnvironment(
      BaseUrlManager.createProductionEnv(
        baseUrl: 'https://api.mycompany.com',
        description: 'Release mode - Production environment',
      ),
    );
    await envManager.setEnvironment('Production');
  }
}
```

## 🔧 استخدام البيئات المخصصة في API Service

### 1. **API Service مع البيئات**

```dart
class ApiService {
  // الحصول على الـ Base URL الحالي
  static String get baseUrl => BaseUrlManager.instance.currentBaseUrl;
  
  // الحصول على API Key من إعدادات البيئة الحالية
  static String? get apiKey => BaseUrlManager.instance.getConfigValue<String>('api_key');
  
  // الحصول على Timeout من إعدادات البيئة الحالية
  static int get timeout => BaseUrlManager.instance.getConfigValue<int>('timeout') ?? 30;
  
  // Headers مع API Key
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (apiKey != null) 'Authorization': 'Bearer $apiKey',
  };

  // GET Request
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      url, 
      headers: _headers,
    ).timeout(Duration(seconds: timeout));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
```

### 2. **استخدام الـ API Service**

```dart
// في أي مكان في التطبيق
final users = await ApiService.get('/api/users');
final currentUrl = ApiService.baseUrl;
final apiKey = ApiService.apiKey;
```

## 📱 تخصيص الواجهة

### 1. **عرض معلومات البيئة**

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App'),
          actions: [
            // مؤشر البيئة الحالية
            const EnvironmentIndicator(),
          ],
        ),
        body: SimpleBaseUrlWrapper(
          password: "myapp123",
          tapCount: 7,
          child: YourWidget(),
        ),
      ),
    );
  }
}
```

### 2. **عرض تفاصيل البيئة**

```dart
// في أي مكان في التطبيق
EnvironmentInfo(
  showBaseUrl: true,
  showDescription: true,
)
```

## 🎯 نصائح مهمة

### 1. **تحديد البيئة الافتراضية**
```dart
// جعل بيئة معينة افتراضية
const env = Environment(
  name: 'Development',
  baseUrl: 'https://dev-api.com',
  isDefault: true, // هذا مهم!
);
```

### 2. **إعدادات البيئة**
```dart
// إضافة إعدادات مخصصة لكل بيئة
const env = Environment(
  name: 'Production',
  baseUrl: 'https://api.com',
  config: {
    'api_key': 'your_api_key',
    'timeout': 30,
    'retries': 3,
    'debug': false,
  },
);
```

### 3. **الوصول للإعدادات**
```dart
// الحصول على إعدادات البيئة الحالية
final apiKey = BaseUrlManager.instance.getConfigValue<String>('api_key');
final timeout = BaseUrlManager.instance.getConfigValue<int>('timeout');
final debug = BaseUrlManager.instance.getConfigValue<bool>('debug');
```

### 4. **تحديث الإعدادات**
```dart
// تحديث إعدادات البيئة الحالية
await BaseUrlManager.instance.setConfigValue('api_key', 'new_api_key');
await BaseUrlManager.instance.setConfigValue('timeout', 60);
```

## 📁 مثال على ملف JSON للإعدادات

```json
{
  "default_environment": "Development",
  "environments": [
    {
      "name": "Development",
      "baseUrl": "https://dev-api.mycompany.com",
      "description": "Development environment",
      "config": {
        "timeout": 30,
        "retries": 3,
        "debug": true,
        "api_key": "dev_key_123"
      },
      "isDefault": false
    },
    {
      "name": "Production",
      "baseUrl": "https://api.mycompany.com",
      "description": "Production environment",
      "config": {
        "timeout": 15,
        "retries": 1,
        "debug": false,
        "api_key": "prod_key_789"
      },
      "isDefault": true
    }
  ]
}
```

## 🚀 الخلاصة

1. **في main.dart**: حدد البيئات قبل `runApp()`
2. **استخدم الدوال المساعدة**: `createDevelopmentEnv()`, `createProductionEnv()`, إلخ
3. **أضف إعدادات مخصصة**: API keys, timeouts, إلخ
4. **حدد البيئة الافتراضية**: باستخدام `isDefault: true`
5. **استخدم BaseUrlManager**: للوصول للـ Base URL الحالي
6. **عرض معلومات البيئة**: باستخدام `EnvironmentIndicator` و `EnvironmentInfo`
