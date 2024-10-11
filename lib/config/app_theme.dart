import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme(bool isDarkMode, MaterialColor primaryColor) {
    return isDarkMode
        ? ThemeData.dark().copyWith(
            primaryColor: primaryColor,
            scaffoldBackgroundColor: Colors.black87,
            cardColor: Colors.grey[800],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.grey[850],
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            colorScheme: ColorScheme.dark(
              primary: primaryColor,
              secondary: Colors.teal,
            ),
          )
        : ThemeData.light().copyWith(
            primaryColor: primaryColor,
            scaffoldBackgroundColor: Colors.grey[50],
            cardColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: primaryColor,
              iconTheme: const IconThemeData(color: Colors.black),
              titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              secondary: primaryColor,
            ),
          );
  }
}
