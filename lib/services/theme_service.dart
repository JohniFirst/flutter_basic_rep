import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _darkModeKey = 'dark_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _languageKey = 'language';

  bool _isDarkMode = false;
  double _fontSize = 16.0;
  String _language = 'zh';

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  String get language => _language;

  ThemeService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 16.0;
    _language = prefs.getString(_languageKey) ?? 'zh';
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
    await prefs.setDouble(_fontSizeKey, _fontSize);
    await prefs.setString(_languageKey, _language);
  }

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      textTheme: _getTextTheme(Brightness.light),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      textTheme: _getTextTheme(Brightness.dark),
    );
  }

  TextTheme _getTextTheme(Brightness brightness) {
    final baseTextTheme = brightness == Brightness.light 
        ? ThemeData.light().textTheme 
        : ThemeData.dark().textTheme;
    
    return baseTextTheme.copyWith(
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: _fontSize),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: _fontSize),
      bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: _fontSize),
      titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: _fontSize + 4),
      titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: _fontSize + 2),
      titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: _fontSize),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontSize: _fontSize + 8),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: _fontSize + 6),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: _fontSize + 4),
    );
  }
}
