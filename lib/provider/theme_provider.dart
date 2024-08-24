import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void setThemeMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }
}
