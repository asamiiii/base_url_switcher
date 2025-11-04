import 'package:flutter/material.dart';
import 'package:base_url_switcher/base_url_switcher.dart';

/// Example showing how to use custom configurations
class ConfigurationsExample extends StatelessWidget {
  const ConfigurationsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Configurations Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyAppHomePage(),
    );
  }
}

class MyAppHomePage extends StatefulWidget {
  const MyAppHomePage({super.key});

  @override
  State<MyAppHomePage> createState() => _MyAppHomePageState();
}

class _MyAppHomePageState extends State<MyAppHomePage> {
  bool _chuckerEnabled = false;
  bool _loggingEnabled = true;
  bool _analyticsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurations Example'),
        actions: [const EnvironmentIndicator()],
      ),
      body: SimpleBaseUrlWrapper(
        password: "myapp123",
        tapCount: 5,
        configurations: [
          // Example 1: Network Inspector Toggle
          // ConfigurationItem(
          //   title: 'Network Inspector',
          //   description: 'Enable network request inspection',
          //   enabled: _chuckerEnabled,
          //   onTap: () {
          //     // setState(() {
          //     //   _chuckerEnabled = !_chuckerEnabled;
          //     // });
          //     // // Your logic here - initialize Chucker, etc.
          //     // if (_chuckerEnabled) {
          //     //   _initializeChucker();
          //     // } else {
          //     //   _disableChucker();
          //     // }
          //   },
          // ),
          
          // Example 2: Logging Toggle
          // ConfigurationItem(
          //   title: 'Debug Logging',
          //   description: 'Enable detailed debug logs',
          //   enabled: _loggingEnabled,
          //   onTap: () {
          //     setState(() {
          //       _loggingEnabled = !_loggingEnabled;
          //     });
          //     // Your logic here
          //     print('Logging ${_loggingEnabled ? "enabled" : "disabled"}');
          //   },
          // ),
          
          // Example 3: Analytics Toggle
          // ConfigurationItem(
          //   title: 'Analytics',
          //   description: 'Track user behavior and events',
          //   enabled: _analyticsEnabled,
          //   onTap: () {
          //     setState(() {
          //       _analyticsEnabled = !_analyticsEnabled;
          //     });
          //     // Your logic here
          //     print('Analytics ${_analyticsEnabled ? "enabled" : "disabled"}');
          //   },
          // ),
          
          // Example 4: Clear Cache Action
          // ConfigurationItem(
          //   title: 'Clear Cache',
          //   description: 'Clear all cached data',
          //   enabled: true,
          //   onTap: () {
          //     // Your clear cache logic here
          //     _clearCache();
          //   },
          // ),
          
          // Example 5: Export Logs with Custom Widget
          // ConfigurationItem(
          //   title: 'Export Logs',
          //   description: 'Export debug logs to file',
          //   enabled: true,
          //   customWidget: const Icon(Icons.download, color: Colors.blue),
          //   onTap: () {
          //     // Your export logic here
          //     _exportLogs();
          //   },
          // ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Settings',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      _buildSettingRow('Chucker', _chuckerEnabled),
                      _buildSettingRow('Logging', _loggingEnabled),
                      _buildSettingRow('Analytics', _analyticsEnabled),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'How to Access Settings',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Tap anywhere 5 times quickly\n'
                        '• Enter password: myapp123\n'
                        '• Access environment settings and custom configurations',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow(String name, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }

  void _initializeChucker() {
    // Initialize Chucker here
    print('✅ Chucker initialized');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Network Inspector (Chucker) enabled'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _disableChucker() {
    print('❌ Chucker disabled');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Network Inspector (Chucker) disabled'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache cleared successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _exportLogs() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logs exported successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

