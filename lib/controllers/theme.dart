import 'package:flutter/material.dart';

class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController() : super(ThemeMode.light);

  void toggleTheme(bool isDarkMode) {
    value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
