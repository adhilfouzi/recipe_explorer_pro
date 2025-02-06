import 'package:flutter/material.dart';
import '../utils/theme/custom_theme/text_theme.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  ThemeData _currentTheme = ThemeData.light().copyWith(
    textTheme: MyTextTheme.lightTextTheme,
  );

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _currentTheme = _isDarkMode
        ? ThemeData.dark().copyWith(textTheme: MyTextTheme.darkTextTheme)
        : ThemeData.light().copyWith(textTheme: MyTextTheme.lightTextTheme);
    notifyListeners();
  }
}
