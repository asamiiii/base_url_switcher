/// A model class representing an environment configuration
class Environment {
  /// The name of the environment (e.g., 'development', 'staging', 'production')
  final String name;
  
  /// The base URL for API calls
  final String baseUrl;
  
  /// Additional configuration parameters
  final Map<String, dynamic> config;
  
  /// Whether this environment is the default one
  final bool isDefault;
  
  /// A description of the environment
  final String? description;

  const Environment({
    required this.name,
    required this.baseUrl,
    this.config = const {},
    this.isDefault = false,
    this.description,
  });

  /// Create a copy of this environment with updated values
  Environment copyWith({
    String? name,
    String? baseUrl,
    Map<String, dynamic>? config,
    bool? isDefault,
    String? description,
  }) {
    return Environment(
      name: name ?? this.name,
      baseUrl: baseUrl ?? this.baseUrl,
      config: config ?? this.config,
      isDefault: isDefault ?? this.isDefault,
      description: description ?? this.description,
    );
  }

  /// Convert environment to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'baseUrl': baseUrl,
      'config': config,
      'isDefault': isDefault,
      'description': description,
    };
  }

  /// Create environment from JSON
  factory Environment.fromJson(Map<String, dynamic> json) {
    return Environment(
      name: json['name'] as String,
      baseUrl: json['baseUrl'] as String,
      config: Map<String, dynamic>.from(json['config'] ?? {}),
      isDefault: json['isDefault'] as bool? ?? false,
      description: json['description'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Environment &&
        other.name == name &&
        other.baseUrl == baseUrl &&
        _mapEquals(other.config, config) &&
        other.isDefault == isDefault &&
        other.description == description;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        baseUrl.hashCode ^
        config.hashCode ^
        isDefault.hashCode ^
        description.hashCode;
  }

  @override
  String toString() {
    return 'Environment(name: $name, baseUrl: $baseUrl, isDefault: $isDefault)';
  }

  /// Helper method to compare maps
  bool _mapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}
