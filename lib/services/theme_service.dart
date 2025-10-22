import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _darkModeKey = 'dark_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _languageKey = 'language';
  static const String _followSystemThemeKey = 'follow_system_theme';

  bool _isDarkMode = false;
  bool _followSystemTheme = true; // 默认跟随系统主题
  double _fontSize = 16.0;
  String _language = 'zh';

  bool get isDarkMode => _isDarkMode;
  bool get followSystemTheme => _followSystemTheme;
  double get fontSize => _fontSize;
  String get language => _language;

  ThemeService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _followSystemTheme = prefs.getBool(_followSystemThemeKey) ?? true;
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 16.0;
    _language = prefs.getString(_languageKey) ?? 'zh';
    
    // 如果设置为跟随系统，则更新当前主题模式
    if (_followSystemTheme && WidgetsBinding.instance != null) {
      final brightness = WidgetsBinding.instance!.window.platformBrightness;
      _isDarkMode = brightness == Brightness.dark;
    }
    
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    _followSystemTheme = false; // 手动切换时不再跟随系统
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setFollowSystemTheme(bool value) async {
    _followSystemTheme = value;
    
    // 如果设置为跟随系统，立即更新当前主题模式
    if (value && WidgetsBinding.instance != null) {
      final brightness = WidgetsBinding.instance!.window.platformBrightness;
      _isDarkMode = brightness == Brightness.dark;
    }
    
    await _saveSettings();
    notifyListeners();
  }
  
  // 更新系统主题模式
  void updateSystemTheme(Brightness brightness) {
    if (_followSystemTheme) {
      _isDarkMode = brightness == Brightness.dark;
      notifyListeners();
    }
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
    await prefs.setBool(_followSystemThemeKey, _followSystemTheme);
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
