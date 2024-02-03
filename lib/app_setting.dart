import 'package:flutter/material.dart';

class AppSetting {
  static Locale? locale;

  static Null Function(Locale locale)? changeLocale;
}