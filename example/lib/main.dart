import 'package:flutter/material.dart';
import 'package:base_url_switcher/base_url_switcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the EnvService
  await EnvService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Env Manager Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final EnvService _envService = EnvService.instance;
  Environment? _currentEnvironment;

  @override
  void initState() {
    super.initState();
    _currentEnvironment = _envService.currentEnvironment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Env Manager Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Environment switcher in app bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: EnvSwitcher(
              onEnvironmentChanged: (env) {
                setState(() {
                  _currentEnvironment = env;
                });
              },
              style: const EnvSwitcherStyle(
                backgroundColor: Colors.white,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current environment info
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
                    Text(
                      'Name: ${_currentEnvironment?.name ?? "Unknown"}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Base URL: ${_currentEnvironment?.baseUrl ?? "Unknown"}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (_currentEnvironment?.description != null)
                      Text(
                        'Description: ${_currentEnvironment!.description}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    if (_currentEnvironment?.isDefault == true)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'DEFAULT',
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
            ),
            
            const SizedBox(height: 16),
            
            // Environment switcher widget
            Text(
              'Environment Switcher',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const EnvSwitcher(
              showDescriptions: true,
              style: EnvSwitcherStyle(
                backgroundColor: Colors.blue,
                iconColor: Colors.white,
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                descriptionTextStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Available environments list
            Text(
              'Available Environments',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _envService.environments.length,
                itemBuilder: (context, index) {
                  final env = _envService.environments.values.elementAt(index);
                  final isCurrent = env.name == _currentEnvironment?.name;
                  
                  return Card(
                    color: isCurrent ? Colors.blue.shade50 : null,
                    child: ListTile(
                      leading: Icon(
                        isCurrent ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isCurrent ? Colors.blue : Colors.grey,
                      ),
                      title: Text(
                        env.name,
                        style: TextStyle(
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(env.baseUrl),
                          if (env.description != null)
                            Text(
                              env.description!,
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                      trailing: env.isDefault
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
                      onTap: () async {
                        try {
                          await _envService.setEnvironment(env.name);
                          setState(() {
                            _currentEnvironment = env;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Switched to ${env.name} environment'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to switch environment: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
