import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _darkModeKey = 'dark_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _languageKey = 'language';
  static const String _followSystemThemeKey = 'follow_system_theme';
  static const String _followSystemLanguageKey = 'follow_system_language';

  bool _isDarkMode = false;
  bool _followSystemTheme = true; // 默认跟随系统主题
  bool _followSystemLanguage = true; // 默认跟随系统语言
  double _fontSize = 16.0;
  String _language = 'zh';

  bool get isDarkMode => _isDarkMode;
  bool get followSystemTheme => _followSystemTheme;
  bool get followSystemLanguage => _followSystemLanguage;
  double get fontSize => _fontSize;
  String get language => _language;

  ThemeService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _followSystemTheme = prefs.getBool(_followSystemThemeKey) ?? true;
    _followSystemLanguage = prefs.getBool(_followSystemLanguageKey) ?? true;
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 16.0;
    _language = prefs.getString(_languageKey) ?? 'zh';
    
    // 如果设置为跟随系统，则更新当前主题模式
    if (_followSystemTheme) {
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = brightness == Brightness.dark;
    }
    
    // 如果设置为跟随系统，则更新当前语言
    if (_followSystemLanguage) {
      _updateSystemLanguage();
    }
    
    notifyListeners();
  }
  
  // 更新系统语言
  void _updateSystemLanguage() {
      try {
        // 获取系统语言
        final systemLocale = SchedulerBinding.instance.platformDispatcher.locale;
        // 只获取语言代码（如 'en', 'zh'）
        final languageCode = systemLocale.languageCode;
        // 检查是否支持该语言
        if (languageCode == 'en' || languageCode == 'zh') {
          _language = languageCode;
        } else {
          // 默认使用英语
          _language = 'en';
        }
      } catch (e) {
        // 可以考虑使用更好的日志方式
      }
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
    if (value) {
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
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
    _followSystemLanguage = false; // 手动切换时不再跟随系统
    await _saveSettings();
    notifyListeners();
  }
  
  Future<void> setFollowSystemLanguage(bool value) async {
    _followSystemLanguage = value;
    
    // 如果设置为跟随系统，立即更新当前语言
    if (value) {
      _updateSystemLanguage();
    }
    
    await _saveSettings();
    notifyListeners();
  }
  
  // 更新系统语言
  void updateSystemLanguage() {
    if (_followSystemLanguage) {
      _updateSystemLanguage();
      notifyListeners();
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_followSystemThemeKey, _followSystemTheme);
    await prefs.setBool(_followSystemLanguageKey, _followSystemLanguage);
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
