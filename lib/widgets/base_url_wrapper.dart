import 'package:flutter/material.dart';
import 'package:base_url_switcher/base_url_switcher.dart';
import '../models/configuration_item.dart';

/// Widget wrapper سهل الاستخدام - فقط wrap الـ widget المطلوب
class BaseUrlWrapper extends StatefulWidget {
  /// الـ widget المراد wrap
  final Widget child;
  
  /// عدد مرات الضغط المطلوبة لفتح الإعدادات (افتراضي: 7)
  final int tapCount;
  
  /// الباسورد المطلوب للوصول للإعدادات (افتراضي: "admin")
  final String password;
  
  /// عنوان صفحة الإعدادات
  final String? settingsTitle;
  
  /// أيقونة صفحة الإعدادات
  final IconData? settingsIcon;
  
  /// لون صفحة الإعدادات
  final Color? primaryColor;
  
  /// استدعاء عند تغيير البيئة
  final Function(Environment)? onEnvironmentChanged;
  
  /// إظهار في وضع الإنتاج
  final bool showInRelease;
  
  /// List of custom configurations
  final List<ConfigurationItem>? configurations;

  const BaseUrlWrapper({
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
  State<BaseUrlWrapper> createState() => _BaseUrlWrapperState();
}

class _BaseUrlWrapperState extends State<BaseUrlWrapper> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: widget.child,
    );
  }

  void _handleTap() {
    final now = DateTime.now();
    
    // إعادة تعيين العداد إذا مر أكثر من ثانيتين
    if (_lastTapTime != null && now.difference(_lastTapTime!).inSeconds > 2) {
      _tapCount = 0;
    }
    
    _tapCount++;
    _lastTapTime = now;
    
    // إذا وصل للعدد المطلوب
    if (_tapCount >= widget.tapCount) {
      _tapCount = 0;
      _showPasswordDialog();
    }
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => _PasswordDialog(
        password: widget.password,
        onSuccess: () {
          Navigator.pop(context);
          _openSettingsScreen();
        },
      ),
    );
  }

  void _openSettingsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnvSwitcherScreen(
          title: widget.settingsTitle ?? 'Environment Settings',
          icon: widget.settingsIcon ?? Icons.settings,
          primaryColor: widget.primaryColor ?? Theme.of(context).colorScheme.primary,
          onEnvironmentChanged: widget.onEnvironmentChanged,
          showInRelease: widget.showInRelease,
          configurations: widget.configurations,
        ),
      ),
    );
  }
}

/// Dialog للباسورد
class _PasswordDialog extends StatefulWidget {
  final String password;
  final VoidCallback onSuccess;

  const _PasswordDialog({
    required this.password,
    required this.onSuccess,
  });

  @override
  State<_PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends State<_PasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.lock,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          const Text('Enter Password'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter the password to access environment settings:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _isObscured,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              ),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _checkPassword(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _checkPassword,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Enter'),
        ),
      ],
    );
  }

  void _checkPassword() async {
    if (_passwordController.text.isEmpty) {
      _showError('Please enter a password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // محاكاة تحقق الباسورد
    await Future.delayed(const Duration(milliseconds: 500));

    if (_passwordController.text == widget.password) {
      widget.onSuccess();
    } else {
      _showError('Incorrect password');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
