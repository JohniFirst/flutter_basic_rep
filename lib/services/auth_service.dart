import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _rememberUserKey = 'remember_user';
  static const String _isLoggedInKey = 'is_logged_in';

  // 登录验证（简单验证，实际项目中应该调用API）
  static Future<bool> login(String username, String password, bool rememberUser) async {
    // 简单的用户名密码验证（实际项目中应该调用后端API）
    if (username.isNotEmpty && password.isNotEmpty) {
      // 如果选择记住用户，保存用户名和密码
      if (rememberUser) {
        await _storage.write(key: _usernameKey, value: username);
        await _storage.write(key: _passwordKey, value: password);
        await _storage.write(key: _rememberUserKey, value: 'true');
      } else {
        // 不记住用户，清除之前保存的信息
        await _storage.delete(key: _usernameKey);
        await _storage.delete(key: _passwordKey);
        await _storage.write(key: _rememberUserKey, value: 'false');
      }
      
      // 保存登录状态
      await _storage.write(key: _isLoggedInKey, value: 'true');
      return true;
    }
    return false;
  }

  // 登出
  static Future<void> logout() async {
    await _storage.delete(key: _isLoggedInKey);
    await _storage.delete(key: _usernameKey);
    await _storage.delete(key: _passwordKey);
    await _storage.delete(key: _rememberUserKey);
  }

  // 检查是否已登录
  static Future<bool> isLoggedIn() async {
    final isLoggedIn = await _storage.read(key: _isLoggedInKey);
    return isLoggedIn == 'true';
  }

  // 获取记住的用户名
  static Future<String?> getRememberedUsername() async {
    return await _storage.read(key: _usernameKey);
  }

  // 获取记住的密码
  static Future<String?> getRememberedPassword() async {
    return await _storage.read(key: _passwordKey);
  }

  // 检查是否记住用户
  static Future<bool> isRememberUser() async {
    final rememberUser = await _storage.read(key: _rememberUserKey);
    return rememberUser == 'true';
  }

  // 获取当前登录用户名
  static Future<String?> getCurrentUsername() async {
    return await _storage.read(key: _usernameKey);
  }
}
