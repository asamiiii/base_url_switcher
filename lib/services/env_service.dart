import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/environment.dart';

/// Service class for managing environment configurations
class EnvService {
  static const String _currentEnvKey = 'current_environment';
  static const String _environmentsKey = 'available_environments';
  
  static EnvService? _instance;
  static SharedPreferences? _prefs;
  
  /// Private constructor for singleton pattern
  EnvService._();
  
  /// Get singleton instance
  static EnvService get instance {
    _instance ??= EnvService._();
    return _instance!;
  }
  
  /// Initialize the service with SharedPreferences
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  /// Default environments
  static final Map<String, Environment> _defaultEnvironments = {
    'development': Environment(
      name: 'Development',
      baseUrl: 'https://dev-api.example.com',
      description: 'Development environment for testing',
      isDefault: true,
    ),
    'staging': Environment(
      name: 'Staging',
      baseUrl: 'https://staging-api.example.com',
      description: 'Staging environment for pre-production testing',
    ),
    'production': Environment(
      name: 'Production',
      baseUrl: 'https://api.example.com',
      description: 'Production environment',
    ),
  };
  
  /// Get all available environments
  Map<String, Environment> get environments {
    final savedEnvs = _getSavedEnvironments();
    if (savedEnvs.isNotEmpty) {
      return savedEnvs;
    }
    return _defaultEnvironments;
  }
  
  /// Get current environment
  Environment get currentEnvironment {
    final currentEnvName = _prefs?.getString(_currentEnvKey);
    if (currentEnvName != null && environments.containsKey(currentEnvName)) {
      return environments[currentEnvName]!;
    }
    
    // Return default environment
    final defaultEnv = environments.values.firstWhere(
      (env) => env.isDefault,
      orElse: () => environments.values.first,
    );
    return defaultEnv;
  }
  
  /// Set current environment
  Future<void> setEnvironment(String envName) async {
    if (!environments.containsKey(envName)) {
      throw ArgumentError('Environment "$envName" not found');
    }
    
    await _prefs?.setString(_currentEnvKey, envName);
  }
  
  /// Add a new environment
  Future<void> addEnvironment(Environment environment) async {
    final currentEnvs = Map<String, Environment>.from(environments);
    currentEnvs[environment.name.toLowerCase()] = environment;
    await _saveEnvironments(currentEnvs);
  }
  
  /// Remove an environment
  Future<void> removeEnvironment(String envName) async {
    final currentEnvs = Map<String, Environment>.from(environments);
    currentEnvs.remove(envName.toLowerCase());
    
    // If we're removing the current environment, switch to default
    if (currentEnvironment.name.toLowerCase() == envName.toLowerCase()) {
      final defaultEnv = currentEnvs.values.firstWhere(
        (env) => env.isDefault,
        orElse: () => currentEnvs.values.first,
      );
      await setEnvironment(defaultEnv.name);
    }
    
    await _saveEnvironments(currentEnvs);
  }
  
  /// Update an existing environment
  Future<void> updateEnvironment(String envName, Environment updatedEnv) async {
    final currentEnvs = Map<String, Environment>.from(environments);
    currentEnvs[envName.toLowerCase()] = updatedEnv;
    await _saveEnvironments(currentEnvs);
  }
  
  /// Reset to default environments
  Future<void> resetToDefaults() async {
    await _prefs?.remove(_environmentsKey);
    final defaultEnv = _defaultEnvironments.values.firstWhere(
      (env) => env.isDefault,
      orElse: () => _defaultEnvironments.values.first,
    );
    await setEnvironment(defaultEnv.name.toLowerCase());
  }
  
  /// Get environment by name
  Environment? getEnvironment(String envName) {
    return environments[envName.toLowerCase()];
  }
  
  /// Check if environment exists
  bool hasEnvironment(String envName) {
    return environments.containsKey(envName.toLowerCase());
  }
  
  /// Get current base URL
  String get currentBaseUrl => currentEnvironment.baseUrl;
  
  /// Get current environment name
  String get currentEnvironmentName => currentEnvironment.name;
  
  /// Get configuration value from current environment
  T? getConfigValue<T>(String key) {
    return currentEnvironment.config[key] as T?;
  }
  
  /// Set configuration value for current environment
  Future<void> setConfigValue(String key, dynamic value) async {
    final currentEnv = currentEnvironment;
    final updatedEnv = currentEnv.copyWith(
      config: {...currentEnv.config, key: value},
    );
    await updateEnvironment(currentEnv.name, updatedEnv);
  }
  
  /// Save environments to SharedPreferences
  Future<void> _saveEnvironments(Map<String, Environment> envs) async {
    final envsJson = envs.map((key, value) => MapEntry(key, value.toJson()));
    await _prefs?.setString(_environmentsKey, jsonEncode(envsJson));
  }
  
  /// Get saved environments from SharedPreferences
  Map<String, Environment> _getSavedEnvironments() {
    final envsJsonString = _prefs?.getString(_environmentsKey);
    if (envsJsonString == null) return {};
    
    try {
      final envsJson = jsonDecode(envsJsonString) as Map<String, dynamic>;
      return envsJson.map(
        (key, value) => MapEntry(
          key,
          Environment.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      return {};
    }
  }
  
  /// Clear all saved data
  Future<void> clear() async {
    await _prefs?.remove(_currentEnvKey);
    await _prefs?.remove(_environmentsKey);
  }
}
