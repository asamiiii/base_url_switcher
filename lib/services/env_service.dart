import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/environment.dart';
import '../models/environment_type.dart';

/// Service class for managing environment configurations
class EnvService {
  static const String _currentEnvKey = 'current_environment';
  static const String _environmentsKey = 'available_environments';
  static const String _hasUserSelectedKey = 'has_user_selected_environment';
  
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
  static Future<void> initialize({
    String? developmentUrl,
    String? productionUrl,
    String? stagingUrl,
    EnvironmentType? defaultEnvironment,
  }) async {
    _prefs ??= await SharedPreferences.getInstance();
    
    // If custom URLs are provided, clear existing environments and add them
    if (developmentUrl != null || productionUrl != null || stagingUrl != null) {
      await instance.clear();
      await _setupCustomEnvironments(
        developmentUrl: developmentUrl,
        productionUrl: productionUrl,
        stagingUrl: stagingUrl,
        defaultEnvironment: defaultEnvironment,
      );
    }
  }
  
  /// Setup custom environments
  static Future<void> _setupCustomEnvironments({
    String? developmentUrl,
    String? productionUrl,
    String? stagingUrl,
    EnvironmentType? defaultEnvironment,
  }) async {
    final instance = EnvService.instance;
    
    // Add development environment
    if (developmentUrl != null) {
      final devEnv = Environment(
        name: EnvironmentType.development.displayName,
        baseUrl: developmentUrl,
        description: EnvironmentType.development.description,
        isDefault: false, // We'll set the default after adding all environments
      );
      await instance.addEnvironment(devEnv);
    }
    
    // Add production environment
    if (productionUrl != null) {
      final prodEnv = Environment(
        name: EnvironmentType.production.displayName,
        baseUrl: productionUrl,
        description: EnvironmentType.production.description,
        isDefault: false, // We'll set the default after adding all environments
      );
      await instance.addEnvironment(prodEnv);
    }
    
    // Add staging environment
    if (stagingUrl != null) {
      final stagingEnv = Environment(
        name: EnvironmentType.staging.displayName,
        baseUrl: stagingUrl,
        description: EnvironmentType.staging.description,
        isDefault: false, // We'll set the default after adding all environments
      );
      await instance.addEnvironment(stagingEnv);
    }
    
    // Set default environment after all environments are added
    if (defaultEnvironment != null) {
      // Check if the requested default environment exists
      if (instance.hasEnvironment(defaultEnvironment.displayName)) {
        await instance.setEnvironment(defaultEnvironment.displayName);
      } else {
        // Fallback to development if the requested environment doesn't exist
        if (instance.hasEnvironment(EnvironmentType.development.displayName)) {
          await instance.setEnvironment(EnvironmentType.development.displayName);
        }
      }
    } else if (developmentUrl != null) {
      await instance.setEnvironment(EnvironmentType.development.displayName);
    }
  }
  
  /// Default environments
  static final Map<String, Environment> _defaultEnvironments = {
    'development': Environment(
      name: EnvironmentType.development.displayName,
      baseUrl: 'https://dev-api.example.com',
      description: EnvironmentType.development.description,
      isDefault: true,
    ),
    'staging': Environment(
      name: EnvironmentType.staging.displayName,
      baseUrl: 'https://staging-api.example.com',
      description: EnvironmentType.staging.description,
    ),
    'production': Environment(
      name: EnvironmentType.production.displayName,
      baseUrl: 'https://api.example.com',
      description: EnvironmentType.production.description,
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
    final hasUserSelected = _prefs?.getBool(_hasUserSelectedKey) ?? false;
    
    // If user has selected an environment before, use saved or first available
    if (hasUserSelected) {
      if (currentEnvName != null && environments.containsKey(currentEnvName.toLowerCase())) {
        return environments[currentEnvName.toLowerCase()]!;
      }
      // If saved environment not found, return first available
      if (environments.isNotEmpty) {
        return environments.values.first;
      }
    }
    
    // First time opening app - return default environment
    if (environments.isEmpty) {
      // If no environments exist, return a default one
      return Environment(
        name: EnvironmentType.development.displayName,
        baseUrl: 'https://dev-api.example.com',
        description: EnvironmentType.development.description,
        isDefault: true,
      );
    }
    
    final defaultEnv = environments.values.firstWhere(
      (env) => env.isDefault,
      orElse: () => environments.values.first,
    );
    
    // Mark that we're using default (first time)
    // Don't set hasUserSelected to true yet - only when user explicitly changes
    return defaultEnv;
  }
  
  /// Set current environment
  Future<void> setEnvironment(String envName) async {
    if (!environments.containsKey(envName.toLowerCase())) {
      throw ArgumentError('Environment "$envName" not found');
    }
    
    await _prefs?.setString(_currentEnvKey, envName);
    // Mark that user has selected an environment (no longer using default)
    await _prefs?.setBool(_hasUserSelectedKey, true);
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
    await _prefs?.remove(_hasUserSelectedKey); // Reset user selection flag
    final defaultEnv = _defaultEnvironments.values.firstWhere(
      (env) => env.isDefault,
      orElse: () => _defaultEnvironments.values.first,
    );
    await _prefs?.setString(_currentEnvKey, defaultEnv.name.toLowerCase());
    // Don't set hasUserSelected - allow default to be used on next app start
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
    await _prefs?.remove(_hasUserSelectedKey); // Clear user selection flag
    environments.clear(); // Clear in-memory map
  }
}
