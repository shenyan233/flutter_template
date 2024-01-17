import 'package:flutter/material.dart';

class AppSetting {
  Locale? locale;

  // 不可放在MyApp中，因为static无法访问非static方法，如setState()。
  Null Function(Locale locale)? changeLocale;

  AppSetting();
}