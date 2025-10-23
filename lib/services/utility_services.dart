import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// 工具服务类，提供各种通用功能
class UtilityServices {
  /// 打开电话应用并自动填充号码
  /// [phoneNumber] - 要拨打的电话号码
  /// [context] - 上下文，用于显示错误提示
  static Future<void> launchPhoneApp(
      String phoneNumber, BuildContext context) async {
    // 确保上下文在使用时仍然有效
    if (!context.mounted) return;
    
    // 获取ScaffoldMessenger
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    if (scaffoldMessenger == null) return;
    
    // 拼接电话协议（tel: + 电话号码）
    final Uri url = Uri.parse('tel:$phoneNumber');

    try {
      // 检查是否可以打开该链接
      if (await canLaunchUrl(url)) {
        // 启动电话应用
        bool launched = await launchUrl(
          url,
          // 配置启动模式
          mode: LaunchMode.externalApplication,
        );

        if (launched) {
          // 成功启动电话应用
        } else {
          // 启动电话应用失败
          _showErrorSnackBarWithMessenger(
              scaffoldMessenger, '启动电话应用失败，请手动拨打');
        }
      } else {
        // 无法打开电话应用，请检查权限设置
        _showErrorSnackBarWithMessenger(
            scaffoldMessenger, '无法打开电话应用，请检查权限设置');
      }
    } catch (e) {
      // 打开电话应用失败
      _showErrorSnackBarWithMessenger(scaffoldMessenger, '打开电话应用失败：$e');
    }
  }

  /// 打开浏览器
  /// [urlString] - 要打开的URL地址
  /// [context] - 上下文，用于显示错误提示
  static Future<void> launchBrowser(
      String urlString, BuildContext context) async {
    // 确保上下文在使用时仍然有效
    if (!context.mounted) return;
    
    // 获取ScaffoldMessenger
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    if (scaffoldMessenger == null) return;
    
    try {
      // 清理URL字符串
      String cleanUrl = urlString.trim();
      
      // 确保URL包含协议
      if (!cleanUrl.startsWith(RegExp(r'^https?://', caseSensitive: false))) {
        cleanUrl = 'http://' + cleanUrl;
      }
      
      // 使用tryParse来安全地解析URL
      final Uri? url = Uri.tryParse(cleanUrl);
      
      if (url == null || !url.hasScheme) {
        _showErrorSnackBarWithMessenger(scaffoldMessenger, '无效的URL格式');
        return;
      }
      
      // 直接尝试启动URL，不依赖canLaunchUrl检查
      // 因为canLaunchUrl在某些Android设备上可能不可靠
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.platformDefault, // 使用系统默认模式，兼容性更好
      );
      
      if (!launched) {
        // 如果默认模式失败，尝试externalApplication模式
        launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }
      
      if (!launched) {
        // 如果仍然失败，尝试inAppWebView模式
        launched = await launchUrl(
          url,
          mode: LaunchMode.inAppWebView,
        );
      }
      
      if (!launched) {
        _showErrorSnackBarWithMessenger(scaffoldMessenger, '无法打开链接，请检查系统设置');
      }
    } catch (e) {
      _showErrorSnackBarWithMessenger(scaffoldMessenger, '打开链接时发生错误');
    }
  }

  /// 打开邮件应用（简化版本，专注于基本功能）
  /// [email] - 收件人邮箱地址
  /// [context] - 上下文，用于显示错误提示
  static Future<void> launchEmailApp(String email, BuildContext context) async {
    // 确保上下文在使用时仍然有效
    if (!context.mounted) return;
    
    // 获取ScaffoldMessenger
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    if (scaffoldMessenger == null) return;
    
    // 确保邮箱地址有效
    if (email.isEmpty || !email.contains('@')) {
      _showErrorSnackBarWithMessenger(scaffoldMessenger, '无效的邮箱地址');
      return;
    }
    
    try {
      // 最简单的 mailto URL 格式，不含任何参数，提高兼容性
      String simpleMailto = 'mailto:$email';
      
      // 尝试直接使用 parse 方法创建 URI
      final Uri url = Uri.parse(simpleMailto);
      
      // 使用 platformDefault 模式，让系统决定最佳打开方式
      bool launched = await launchUrl(
        url,
        mode: LaunchMode.platformDefault,
      );
      
      if (!launched) {
        _showErrorSnackBarWithMessenger(scaffoldMessenger, '无法打开邮件应用，请确保已安装邮件客户端');
      }
    } catch (e) {
      // 提供明确的错误信息
      _showErrorSnackBarWithMessenger(scaffoldMessenger, '启动邮件应用失败，请检查系统设置');
    }
  }

  /// 使用ScaffoldMessenger显示错误提示
  static void _showErrorSnackBarWithMessenger(ScaffoldMessengerState messenger, String message) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  // 已替换为 _showErrorSnackBarWithMessenger 方法
  

  /// 格式化电话号码（移除空格、短横线等）
  static String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  /// 验证电话号码格式
  static bool isValidPhoneNumber(String phoneNumber) {
    // 简单的电话号码验证规则，可以根据需要修改
    final RegExp phoneRegex = RegExp(r'^[+]?[0-9]{8,15}$');
    return phoneRegex.hasMatch(formatPhoneNumber(phoneNumber));
  }
}