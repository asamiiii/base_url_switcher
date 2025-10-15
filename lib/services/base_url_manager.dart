import 'package:base_url_switcher/base_url_switcher.dart';
import '../models/environment_type.dart';

/// مدير مبسط للـ Base URL - يسهل الوصول للـ URL الحالي
class BaseUrlManager {
  static BaseUrlManager? _instance;
  static BaseUrlManager get instance => _instance ??= BaseUrlManager._();
  
  BaseUrlManager._();

  /// الحصول على الـ Base URL الحالي
  String get currentBaseUrl => EnvService.instance.currentBaseUrl;
  
  /// الحصول على اسم البيئة الحالية
  String get currentEnvironmentName => EnvService.instance.currentEnvironmentName;
  
  /// الحصول على البيئة الحالية كاملة
  Environment get currentEnvironment => EnvService.instance.currentEnvironment;
  
  /// التحقق من وجود بيئة معينة
  bool hasEnvironment(String name) => EnvService.instance.hasEnvironment(name);
  
  /// الحصول على بيئة معينة
  Environment? getEnvironment(String name) => EnvService.instance.getEnvironment(name);
  
  /// تبديل البيئة
  Future<void> setEnvironment(String name) => EnvService.instance.setEnvironment(name);
  
  /// إضافة بيئة جديدة
  Future<void> addEnvironment(Environment environment) => 
      EnvService.instance.addEnvironment(environment);
  
  /// تحديث بيئة موجودة
  Future<void> updateEnvironment(String name, Environment environment) => 
      EnvService.instance.updateEnvironment(name, environment);
  
  /// حذف بيئة
  Future<void> removeEnvironment(String name) => 
      EnvService.instance.removeEnvironment(name);
  
  /// إعادة تعيين للافتراضي
  Future<void> resetToDefaults() => EnvService.instance.resetToDefaults();
  
  /// الحصول على جميع البيئات
  Map<String, Environment> get environments => EnvService.instance.environments;
  
  /// الحصول على قيمة إعداد
  T? getConfigValue<T>(String key) => EnvService.instance.getConfigValue<T>(key);
  
  /// تعيين قيمة إعداد
  Future<void> setConfigValue(String key, dynamic value) => 
      EnvService.instance.setConfigValue(key, value);
  
  /// مسح جميع البيانات
  Future<void> clear() => EnvService.instance.clear();
  
  /// Create custom development environment
  static Environment createDevelopmentEnv({
    required String baseUrl,
    String? description,
    Map<String, dynamic>? config,
  }) {
    return Environment(
      name: EnvironmentType.development.displayName,
      baseUrl: baseUrl,
      description: description ?? EnvironmentType.development.description,
      config: config ?? {},
      isDefault: true,
    );
  }
  
  /// Create custom production environment
  static Environment createProductionEnv({
    required String baseUrl,
    String? description,
    Map<String, dynamic>? config,
  }) {
    return Environment(
      name: EnvironmentType.production.displayName,
      baseUrl: baseUrl,
      description: description ?? EnvironmentType.production.description,
      config: config ?? {},
      isDefault: false,
    );
  }
  
  /// Create custom staging environment
  static Environment createStagingEnv({
    required String baseUrl,
    String? description,
    Map<String, dynamic>? config,
  }) {
    return Environment(
      name: EnvironmentType.staging.displayName,
      baseUrl: baseUrl,
      description: description ?? EnvironmentType.staging.description,
      config: config ?? {},
      isDefault: false,
    );
  }
  
  /// إنشاء بيئة مخصصة
  static Environment createCustomEnv({
    required String name,
    required String baseUrl,
    String? description,
    Map<String, dynamic>? config,
    bool isDefault = false,
  }) {
    return Environment(
      name: name,
      baseUrl: baseUrl,
      description: description,
      config: config ?? {},
      isDefault: isDefault,
    );
  }
}
