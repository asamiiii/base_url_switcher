import 'package:flutter/material.dart';

/// Configuration item for custom features
/// All logic should be implemented outside the package
class ConfigurationItem {
  /// Title of the configuration
  final String title;
  
  /// Description/Subtitle (optional)
  final String? description;
  
  /// Whether this configuration is enabled
  final bool enabled;
  
  /// Callback when tapped - implement your logic here
  /// The callback receives the new enabled state after toggle
  final Function(bool newState)? onTap;
  
  /// Custom widget to display (optional)
  final Widget? customWidget;

  const ConfigurationItem({
    required this.title,
    this.description,
    required this.enabled,
    this.onTap,
    this.customWidget,
  });
}
