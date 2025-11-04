import 'package:flutter/material.dart';
import 'package:base_url_switcher/base_url_switcher.dart';

/// أبسط wrapper ممكن - فقط wrap الـ widget
class SimpleBaseUrlWrapper extends StatelessWidget {
  /// الـ widget المراد wrap
  final Widget child;
  
  /// الباسورد (افتراضي: "admin")
  final String? password;
  
  /// عدد مرات الضغط (افتراضي: 7)
  final int? tapCount;
  
  /// List of custom configurations
  final List<ConfigurationItem>? configurations;

  const SimpleBaseUrlWrapper({
    super.key,
    required this.child,
    this.password,
    this.tapCount,
    this.configurations,
  });

  @override
  Widget build(BuildContext context) {
    return BaseUrlWrapper(
      tapCount: tapCount ?? 7,
      password: password ?? "admin",
      configurations: configurations,
      child: child,
    );
  }
}

/// Widget للاستخدام في AppBar - يظهر معلومات البيئة الحالية
class EnvironmentIndicator extends StatelessWidget {
  /// لون المؤشر
  final Color? color;
  
  /// حجم النص
  final double? fontSize;

  const EnvironmentIndicator({
    super.key,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final envName = BaseUrlManager.instance.currentEnvironmentName;
    final primaryColor = color ?? Theme.of(context).colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud,
            size: (fontSize ?? 14) - 2,
            color: primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            envName,
            style: TextStyle(
              fontSize: fontSize ?? 12,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget لعرض معلومات البيئة في أي مكان
class EnvironmentInfo extends StatelessWidget {
  /// إظهار الـ Base URL
  final bool showBaseUrl;
  
  /// إظهار الوصف
  final bool showDescription;
  
  /// نمط النص
  final TextStyle? textStyle;

  const EnvironmentInfo({
    super.key,
    this.showBaseUrl = false,
    this.showDescription = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final env = BaseUrlManager.instance.currentEnvironment;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Environment: ${env.name}',
          style: textStyle ?? const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (showBaseUrl)
          Text(
            'Base URL: ${env.baseUrl}',
            style: textStyle,
          ),
        if (showDescription && env.description != null)
          Text(
            'Description: ${env.description}',
            style: textStyle,
          ),
      ],
    );
  }
}
