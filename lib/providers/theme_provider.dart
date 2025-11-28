import 'package:flutter/material.dart';
// نستخدم الاسم المستعار للتأكيد
import 'package:flutter/material.dart' as mat;

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  mat.ThemeData getLightTheme() {
    return mat.ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1E40AF),
        brightness: Brightness.light,
      ),
      fontFamily: 'Cairo',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    );
  }

  mat.ThemeData getDarkTheme() {
    return mat.ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1E40AF),
        brightness: Brightness.dark,
      ),
      fontFamily: 'Cairo',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}