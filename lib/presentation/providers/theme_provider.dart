import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  MaterialColor _primaryColor = Colors.blue;

  bool get isDarkMode => _isDarkMode;
  MaterialColor get primaryColor => _primaryColor;

  ThemeData get currentTheme => _isDarkMode
      ? ThemeData.dark().copyWith(primaryColor: _primaryColor)
      : ThemeData.light().copyWith(primaryColor: _primaryColor);

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void changePrimaryColor(MaterialColor color) {
    _primaryColor = color;
    notifyListeners();
  }
}
