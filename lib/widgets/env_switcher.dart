import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/environment.dart';
import '../services/env_service.dart';

/// A beautiful UI widget for switching between environments
class EnvSwitcher extends StatefulWidget {
  /// Callback when environment changes
  final Function(Environment)? onEnvironmentChanged;
  
  /// Whether to show the switcher in release mode
  final bool showInRelease;
  
  /// Custom styling for the switcher
  final EnvSwitcherStyle? style;
  
  /// Whether to show environment descriptions
  final bool showDescriptions;
  
  /// Custom icon for the switcher
  final IconData? icon;

  const EnvSwitcher({
    super.key,
    this.onEnvironmentChanged,
    this.showInRelease = false,
    this.style,
    this.showDescriptions = true,
    this.icon,
  });

  @override
  State<EnvSwitcher> createState() => _EnvSwitcherState();
}

class _EnvSwitcherState extends State<EnvSwitcher> {
  late EnvService _envService;
  Environment? _currentEnvironment;

  @override
  void initState() {
    super.initState();
    _envService = EnvService.instance;
    _currentEnvironment = _envService.currentEnvironment;
  }

  @override
  Widget build(BuildContext context) {
    // Don't show in release mode unless explicitly allowed
    if (kReleaseMode && !widget.showInRelease) {
      return const SizedBox.shrink();
    }

    final style = widget.style ?? EnvSwitcherStyle();
    
    return Container(
      margin: style.margin,
      child: Material(
        color: style.backgroundColor,
        borderRadius: style.borderRadius,
        elevation: style.elevation,
        child: InkWell(
          onTap: _showEnvironmentDialog,
          borderRadius: style.borderRadius,
          child: Container(
            padding: style.padding,
            decoration: BoxDecoration(
              borderRadius: style.borderRadius,
              border: style.border,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon ?? Icons.settings,
                  color: style.iconColor,
                  size: style.iconSize,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentEnvironment?.name ?? 'Unknown',
                      style: style.titleTextStyle,
                    ),
                    if (widget.showDescriptions && _currentEnvironment?.description != null)
                      Text(
                        _currentEnvironment!.description!,
                        style: style.descriptionTextStyle,
                      ),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_drop_down,
                  color: style.iconColor,
                  size: style.iconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEnvironmentDialog() {
    showDialog(
      context: context,
      builder: (context) => _EnvironmentDialog(
        currentEnvironment: _currentEnvironment,
        onEnvironmentSelected: _onEnvironmentSelected,
        showDescriptions: widget.showDescriptions,
        style: widget.style,
      ),
    );
  }

  void _onEnvironmentSelected(Environment environment) async {
    try {
      await _envService.setEnvironment(environment.name);
      setState(() {
        _currentEnvironment = environment;
      });
      widget.onEnvironmentChanged?.call(environment);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Switched to ${environment.name} environment'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to switch environment: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

/// Dialog for selecting environment
class _EnvironmentDialog extends StatelessWidget {
  final Environment? currentEnvironment;
  final Function(Environment) onEnvironmentSelected;
  final bool showDescriptions;
  final EnvSwitcherStyle? style;

  const _EnvironmentDialog({
    required this.currentEnvironment,
    required this.onEnvironmentSelected,
    required this.showDescriptions,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final envService = EnvService.instance;
    final environments = envService.environments.values.toList();
    final dialogStyle = style ?? EnvSwitcherStyle();

    return AlertDialog(
      title: Text(
        'Select Environment',
        style: dialogStyle.dialogTitleStyle,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: environments.length,
          itemBuilder: (context, index) {
            final environment = environments[index];
            final isSelected = currentEnvironment?.name == environment.name;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: isSelected ? Colors.blue.shade50 : null,
              child: ListTile(
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
                title: Text(
                  environment.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue : null,
                  ),
                ),
                subtitle: showDescriptions && environment.description != null
                    ? Text(environment.description!)
                    : Text(environment.baseUrl),
                trailing: environment.isDefault
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'DEFAULT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
                onTap: () {
                  Navigator.of(context).pop();
                  onEnvironmentSelected(environment);
                },
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

/// Styling options for EnvSwitcher
class EnvSwitcherStyle {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;
  final BorderRadius borderRadius;
  final Border? border;
  final double elevation;
  final TextStyle titleTextStyle;
  final TextStyle descriptionTextStyle;
  final TextStyle dialogTitleStyle;

  const EnvSwitcherStyle({
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.all(12.0),
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.blue,
    this.iconSize = 20.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.border,
    this.elevation = 2.0,
    this.titleTextStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    this.descriptionTextStyle = const TextStyle(
      fontSize: 12,
      color: Colors.grey,
    ),
    this.dialogTitleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  });
}
