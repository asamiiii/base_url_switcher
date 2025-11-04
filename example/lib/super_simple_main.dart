import 'package:flutter/material.dart';
import 'package:base_url_switcher/base_url_switcher.dart';

/// مثال فائق البساطة - فقط أضف URLs في initialize
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service with URLs directly - Production is always the default!
  await EnvService.initialize(
    developmentUrl: 'https://dev-api.mycompany.com',
    productionUrl: 'https://api.mycompany.com',
    stagingUrl: 'https://staging-api.mycompany.com',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Simple App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyAppHomePage(),
    );
  }
}

class MyAppHomePage extends StatelessWidget {
  const MyAppHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        actions: [
          // مؤشر البيئة الحالية
          const EnvironmentIndicator(),
        ],
      ),
      body: SimpleBaseUrlWrapper(
        // فقط wrap الـ body - الباقي تلقائي!
        password: "myapp123",
        tapCount: 7,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // معلومات البيئة الحالية
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Environment',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      EnvironmentInfo(
                        showBaseUrl: true,
                        showDescription: true,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // تعليمات للوصول للإعدادات
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
                        '• Tap anywhere 7 times quickly\n'
                        '• Enter password: myapp123\n'
                        '• Switch between environments',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              
              const Spacer(),
              
              // مثال على استخدام الـ Base URL
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'API Usage Example',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Base URL:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              BaseUrlManager.instance.currentBaseUrl,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Usage in code:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'final url = BaseUrlManager.instance.currentBaseUrl;\n'
                              'final response = await http.get(Uri.parse("url/api/users"));',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
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
}
