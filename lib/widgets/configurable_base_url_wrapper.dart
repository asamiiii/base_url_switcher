import 'package:flutter/material.dart';
import 'package:base_url_switcher/base_url_switcher.dart';

/// Enhanced wrapper with custom configurations
class ConfigurableBaseUrlWrapper extends StatelessWidget {
  /// Widget to wrap
  final Widget child;
  
  /// Number of taps required
  final int tapCount;
  
  /// Password for access
  final String password;
  
  /// Settings screen title
  final String? settingsTitle;
  
  /// Settings screen icon
  final IconData? settingsIcon;
  
  /// Primary color
  final Color? primaryColor;
  
  /// Callback when environment changes
  final Function(Environment)? onEnvironmentChanged;
  
  /// Show in release mode
  final bool showInRelease;
  
  /// List of custom configurations
  final List<ConfigurationItem>? configurations;

  const ConfigurableBaseUrlWrapper({
    super.key,
    required this.child,
    this.tapCount = 7,
    this.password = "admin",
    this.settingsTitle,
    this.settingsIcon,
    this.primaryColor,
    this.onEnvironmentChanged,
    this.showInRelease = false,
    this.configurations,
  });

  @override
  Widget build(BuildContext context) {
    return BaseUrlWrapper(
      tapCount: tapCount,
      password: password,
      settingsTitle: settingsTitle,
      settingsIcon: settingsIcon,
      primaryColor: primaryColor,
      onEnvironmentChanged: onEnvironmentChanged,
      showInRelease: showInRelease,
      configurations: configurations,
      child: child,
    );
  }
}

