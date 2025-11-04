import 'package:flutter/material.dart';
import 'package:base_url_switcher/base_url_switcher.dart';

/// صفحة جاهزة لتبديل البيئات - يمكن إضافتها بسهولة في أي تطبيق
class EnvSwitcherScreen extends StatefulWidget {
  /// عنوان الصفحة
  final String? title;
  
  /// أيقونة الصفحة
  final IconData? icon;
  
  /// لون الخلفية
  final Color? backgroundColor;
  
  /// لون المقدمة
  final Color? primaryColor;
  
  /// استدعاء عند تغيير البيئة
  final Function(Environment)? onEnvironmentChanged;
  
  /// إظهار وصف البيئات
  final bool showDescriptions;
  
  /// إظهار في وضع الإنتاج
  final bool showInRelease;
  
  /// تخصيص النمط
  final EnvSwitcherStyle? style;
  
  /// List of custom configurations
  final List<ConfigurationItem>? configurations;

  const EnvSwitcherScreen({
    super.key,
    this.title,
    this.icon,
    this.backgroundColor,
    this.primaryColor,
    this.onEnvironmentChanged,
    this.showDescriptions = true,
    this.showInRelease = false,
    this.style,
    this.configurations,
  });

  @override
  State<EnvSwitcherScreen> createState() => _EnvSwitcherScreenState();
}

class _EnvSwitcherScreenState extends State<EnvSwitcherScreen> {
  final EnvService _envService = EnvService.instance;
  Environment? _currentEnvironment;
  
  // Map to store internal state for each configuration item
  final Map<String, bool> _configurationStates = {};

  @override
  void initState() {
    super.initState();
    _currentEnvironment = _envService.currentEnvironment;
    // Initialize states from configurations
    _initializeConfigurationStates();
  }
  
  @override
  void didUpdateWidget(EnvSwitcherScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update states if configurations changed
    if (oldWidget.configurations != widget.configurations) {
      _updateConfigurationStates();
    }
  }
  
  /// Initialize configuration states from initial values
  void _initializeConfigurationStates() {
    final configs = _getConfigurations();
    if (configs != null) {
      for (final config in configs) {
        if (!_configurationStates.containsKey(config.title)) {
          _configurationStates[config.title] = config.enabled;
        }
      }
    }
  }
  
  /// Update configuration states when configurations change
  void _updateConfigurationStates() {
    final configs = _getConfigurations();
    if (configs != null) {
      for (final config in configs) {
        // Only update if not already set (preserve user changes)
        if (!_configurationStates.containsKey(config.title)) {
          _configurationStates[config.title] = config.enabled;
        }
      }
    }
  }
  
  /// Get configurations list
  List<ConfigurationItem>? _getConfigurations() {
    return widget.configurations;
  }
  
  /// Get current enabled state for a configuration (internal state or initial value)
  bool _getConfigurationEnabled(ConfigurationItem config) {
    return _configurationStates[config.title] ?? config.enabled;
  }
  
  /// Toggle configuration state
  void _toggleConfiguration(ConfigurationItem config) {
    final currentState = _getConfigurationEnabled(config);
    final newState = !currentState;
    
    setState(() {
      _configurationStates[config.title] = newState;
    });
    
    // Call the original onTap callback with new state if provided
    config.onTap?.call(newState);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? Theme.of(context).colorScheme.primary;
    final backgroundColor = widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: Colors.white),
              const SizedBox(width: 8),
            ],
            Text(
              widget.title ?? 'Environment Settings',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          // زر إعادة تعيين للافتراضي
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _resetToDefault,
            tooltip: 'Reset to Default',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات البيئة الحالية
            _buildCurrentEnvironmentCard(primaryColor),
            
            const SizedBox(height: 24),
            
            // Environment Switcher
            _buildEnvironmentSwitcher(primaryColor),
            
            const SizedBox(height: 24),
            
            // قائمة البيئات المتاحة
            _buildEnvironmentsList(primaryColor),
            
            const SizedBox(height: 24),
            
            // Custom Configurations
            if (_getConfigurations() != null && _getConfigurations()!.isNotEmpty)
              _buildConfigurationsSection(primaryColor),
            
            if (_getConfigurations() != null && _getConfigurations()!.isNotEmpty)
              const SizedBox(height: 24),
            
            // معلومات إضافية
            _buildInfoCard(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentEnvironmentCard(Color primaryColor) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.1), primaryColor.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Current Environment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Name', _currentEnvironment?.name ?? "Unknown", primaryColor),
            _buildInfoRow('Base URL', _currentEnvironment?.baseUrl ?? "Unknown", primaryColor),
            if (_currentEnvironment?.description != null)
              _buildInfoRow('Description', _currentEnvironment!.description!, primaryColor),
            if (_currentEnvironment?.isDefault == true)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'DEFAULT ENVIRONMENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentSwitcher(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Switch Environment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        EnvSwitcher(
          showDescriptions: widget.showDescriptions,
          onEnvironmentChanged: (env) {
            setState(() {
              _currentEnvironment = env;
            });
            widget.onEnvironmentChanged?.call(env);
          },
          style: widget.style ?? EnvSwitcherStyle(
            backgroundColor: primaryColor,
            iconColor: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            elevation: 6,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            descriptionTextStyle: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnvironmentsList(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Environments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        ..._envService.environments.values.map((env) {
          final isCurrent = env.name == _currentEnvironment?.name;
          
          return Card(
            elevation: isCurrent ? 6 : 2,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: isCurrent ? primaryColor.withOpacity(0.1) : null,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isCurrent ? primaryColor : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(
                env.name,
                style: TextStyle(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent ? primaryColor : null,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    env.baseUrl,
                    style: TextStyle(
                      color: isCurrent ? primaryColor.withOpacity(0.8) : Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  if (env.description != null)
                    Text(
                      env.description!,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (env.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    ),
                  if (isCurrent)
                    Icon(
                      Icons.check_circle,
                      color: primaryColor,
                    ),
                ],
              ),
              onTap: () async {
                try {
                  await _envService.setEnvironment(env.name);
                  setState(() {
                    _currentEnvironment = env;
                  });
                  widget.onEnvironmentChanged?.call(env);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Switched to ${env.name} environment'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to switch environment: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildConfigurationsSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        ..._getConfigurations()!.map((config) {
          final isEnabled = _getConfigurationEnabled(config);
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: config.customWidget ?? Icon(
                isEnabled ? Icons.check_circle : Icons.circle_outlined,
                color: isEnabled ? Colors.green : Colors.grey,
              ),
              title: Text(
                config.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isEnabled ? null : Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              subtitle: config.description != null
                  ? Text(
                      config.description!,
                      style: TextStyle(
                        color: isEnabled ? Colors.grey[600] : Colors.grey[400],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  : null,
              trailing: isEnabled
                  ? Icon(Icons.toggle_on, color: primaryColor, size: 32)
                  : Icon(Icons.toggle_off, color: Colors.grey, size: 32),
              onTap: () => _toggleConfiguration(config),
              enabled: true,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildInfoCard(Color primaryColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Tips',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '• Tap on any environment to switch to it\n'
              '• The current environment is highlighted\n'
              '• Default environment is marked with "DEFAULT"\n'
              '• Changes are automatically saved',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: primaryColor.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  void _resetToDefault() async {
    try {
      await _envService.resetToDefaults();
      setState(() {
        _currentEnvironment = _envService.currentEnvironment;
      });
      widget.onEnvironmentChanged?.call(_currentEnvironment!);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset to default environment'),
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reset: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
