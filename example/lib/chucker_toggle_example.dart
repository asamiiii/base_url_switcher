import 'package:flutter/material.dart';
import 'package:base_url_switcher/base_url_switcher.dart';
// import 'package:flutter_chucker/flutter_chucker.dart'; // Uncomment when using Chucker

/// Example showing how to properly implement toggle for Chucker
/// The toggle now manages its own state automatically!
class ChuckerToggleExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Chucker Toggle Example')),
        body: SimpleBaseUrlWrapper(
          password: '123',
          // Simple configurations - toggle manages its own state!
          configurations: [
            ConfigurationItem(
              title: 'Chucker',
              description: 'Enable network inspector',
              // Initial value from outside (e.g., ChuckerFlutter.showOnRelease)
              enabled: false, // or ChuckerFlutter.showOnRelease
              onTap: (newState) {
                // Your Chucker logic here - toggle happens automatically!
                // newState is the new enabled state after toggle
                // ChuckerFlutter.isDebugMode = newState;
                // ChuckerFlutter.showOnRelease = newState;
                print('Chucker toggled to: $newState');
              },
            ),
          ],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tap 7 times to access settings'),
                SizedBox(height: 16),
                Text(
                  'The toggle button will change automatically!',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
