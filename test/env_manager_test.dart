import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:base_url_switcher/base_url_switcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Environment Model Tests', () {
    test('should create environment with required fields', () {
      const env = Environment(
        name: 'test',
        baseUrl: 'https://test.com',
      );
      
      expect(env.name, 'test');
      expect(env.baseUrl, 'https://test.com');
      expect(env.config, isEmpty);
      expect(env.isDefault, false);
      expect(env.description, null);
    });

    test('should create environment with all fields', () {
      const env = Environment(
        name: 'production',
        baseUrl: 'https://api.com',
        config: {'timeout': 30, 'retries': 3},
        isDefault: true,
        description: 'Production environment',
      );
      
      expect(env.name, 'production');
      expect(env.baseUrl, 'https://api.com');
      expect(env.config, {'timeout': 30, 'retries': 3});
      expect(env.isDefault, true);
      expect(env.description, 'Production environment');
    });

    test('should copy environment with updated values', () {
      const original = Environment(
        name: 'test',
        baseUrl: 'https://test.com',
        config: {'timeout': 30},
      );
      
      final copied = original.copyWith(
        baseUrl: 'https://new-test.com',
        config: {'timeout': 60, 'retries': 3},
      );
      
      expect(copied.name, 'test');
      expect(copied.baseUrl, 'https://new-test.com');
      expect(copied.config, {'timeout': 60, 'retries': 3});
      expect(copied.isDefault, false);
    });

    test('should convert to and from JSON', () {
      const env = Environment(
        name: 'staging',
        baseUrl: 'https://staging.com',
        config: {'debug': true},
        isDefault: false,
        description: 'Staging environment',
      );
      
      final json = env.toJson();
      final restored = Environment.fromJson(json);
      
      expect(restored.name, env.name);
      expect(restored.baseUrl, env.baseUrl);
      expect(restored.config, env.config);
      expect(restored.isDefault, env.isDefault);
      expect(restored.description, env.description);
    });

    test('should compare environments correctly', () {
      const env1 = Environment(
        name: 'test',
        baseUrl: 'https://test.com',
        config: {'timeout': 30},
      );
      
      const env2 = Environment(
        name: 'test',
        baseUrl: 'https://test.com',
        config: {'timeout': 30},
      );
      
      const env3 = Environment(
        name: 'test',
        baseUrl: 'https://different.com',
        config: {'timeout': 30},
      );
      
      expect(env1, equals(env2));
      expect(env1, isNot(equals(env3)));
      expect(env1.hashCode, equals(env2.hashCode));
    });
  });

  group('EnvService Tests', () {
    late EnvService envService;

    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      await EnvService.initialize();
      envService = EnvService.instance;
    });

    test('should return default environments', () {
      final environments = envService.environments;
      
      expect(environments, isNotEmpty);
      expect(environments.containsKey('development'), true);
      expect(environments.containsKey('staging'), true);
      expect(environments.containsKey('production'), true);
    });

    test('should return current environment', () {
      final currentEnv = envService.currentEnvironment;
      
      expect(currentEnv, isNotNull);
      expect(currentEnv.name, isNotEmpty);
      expect(currentEnv.baseUrl, isNotEmpty);
    });

    test('should set and get environment', () async {
      await envService.setEnvironment('staging');
      final currentEnv = envService.currentEnvironment;
      
      expect(currentEnv.name.toLowerCase(), 'staging');
    });

    test('should add new environment', () async {
      const newEnv = Environment(
        name: 'custom',
        baseUrl: 'https://custom.com',
        description: 'Custom environment',
      );
      
      await envService.addEnvironment(newEnv);
      final environments = envService.environments;
      
      expect(environments.containsKey('custom'), true);
      expect(environments['custom']?.name, 'custom');
    });

    test('should update environment', () async {
      const originalEnv = Environment(
        name: 'test',
        baseUrl: 'https://test.com',
      );
      
      await envService.addEnvironment(originalEnv);
      
      const updatedEnv = Environment(
        name: 'test',
        baseUrl: 'https://updated-test.com',
        description: 'Updated test environment',
      );
      
      await envService.updateEnvironment('test', updatedEnv);
      final env = envService.getEnvironment('test');
      
      expect(env?.baseUrl, 'https://updated-test.com');
      expect(env?.description, 'Updated test environment');
    });

    test('should remove environment', () async {
      const env = Environment(
        name: 'temp',
        baseUrl: 'https://temp.com',
      );
      
      await envService.addEnvironment(env);
      expect(envService.hasEnvironment('temp'), true);
      
      await envService.removeEnvironment('temp');
      expect(envService.hasEnvironment('temp'), false);
    });

    test('should get environment by name', () {
      final env = envService.getEnvironment('development');
      
      expect(env, isNotNull);
      expect(env?.name, 'Development');
    });

    test('should check if environment exists', () {
      expect(envService.hasEnvironment('development'), true);
      expect(envService.hasEnvironment('nonexistent'), false);
    });

    test('should get current base URL', () {
      final baseUrl = envService.currentBaseUrl;
      
      expect(baseUrl, isNotEmpty);
      expect(baseUrl.startsWith('http'), true);
    });

    test('should get current environment name', () {
      final envName = envService.currentEnvironmentName;
      
      expect(envName, isNotEmpty);
    });

    test('should get and set config values', () async {
      await envService.setConfigValue('timeout', 30);
      final timeout = envService.getConfigValue<int>('timeout');
      
      expect(timeout, 30);
    });

    test('should reset to defaults', () async {
      const customEnv = Environment(
        name: 'custom',
        baseUrl: 'https://custom.com',
      );
      
      await envService.addEnvironment(customEnv);
      expect(envService.hasEnvironment('custom'), true);
      
      await envService.resetToDefaults();
      expect(envService.hasEnvironment('custom'), false);
    });

    test('should clear all data', () async {
      const customEnv = Environment(
        name: 'temp',
        baseUrl: 'https://temp.com',
      );
      
      await envService.addEnvironment(customEnv);
      await envService.setEnvironment('temp');
      
      await envService.clear();
      
      // Should fall back to default environment
      final currentEnv = envService.currentEnvironment;
      expect(currentEnv.name, isNotEmpty);
    });

    test('should throw error for invalid environment', () async {
      expect(
        () => envService.setEnvironment('nonexistent'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('EnvSwitcher Widget Tests', () {
    testWidgets('should render environment switcher', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnvSwitcher(
              onEnvironmentChanged: (env) {},
            ),
          ),
        ),
      );

      expect(find.byType(EnvSwitcher), findsOneWidget);
    });

    testWidgets('should show environment dialog on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnvSwitcher(
              onEnvironmentChanged: (env) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(EnvSwitcher));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}