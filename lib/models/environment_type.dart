/// Enum for environment types
enum EnvironmentType {
  development,
  staging,
  production,
  local,
}

extension EnvironmentTypeExtension on EnvironmentType {
  /// Get the display name for the environment
  String get displayName {
    switch (this) {
      case EnvironmentType.development:
        return 'Development';
      case EnvironmentType.staging:
        return 'Staging';
      case EnvironmentType.production:
        return 'Production';
      case EnvironmentType.local:
        return 'Local';
    }
  }
  
  /// Get the description for the environment
  String get description {
    switch (this) {
      case EnvironmentType.development:
        return 'Development environment for testing';
      case EnvironmentType.staging:
        return 'Staging environment for pre-production testing';
      case EnvironmentType.production:
        return 'Production environment';
      case EnvironmentType.local:
        return 'Local development server';
    }
  }
}
