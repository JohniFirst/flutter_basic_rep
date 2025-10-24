// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Flutter示例';

  @override
  String get homeTitle => 'Flutter示例首页';

  @override
  String get navToScreenTest => '导航到 ScreenTest';

  @override
  String get counterHint => '你已经点按按钮的次数：';

  @override
  String get customLine => '我自定义新增的一行';

  @override
  String get incrementTooltip => '增加';

  @override
  String get back => '返回';

  @override
  String screenTestCounter(int count) {
    return '你已经敲击了这个木鱼$count次';
  }

  @override
  String get firstSection => '第一段';

  @override
  String get secondSection => '第二段';

  @override
  String studentNameAge(String name, int age) {
    return '姓名: $name, 年龄: $age';
  }

  @override
  String get welcomeLogin => '欢迎登录';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get rememberUser => '记住当前用户';

  @override
  String get login => '登录';

  @override
  String get loginHint => '提示：输入任意用户名和密码即可登录';

  @override
  String get loginError => '用户名或密码错误';

  @override
  String get profile => '个人资料';

  @override
  String get unknownUser => '未知用户';

  @override
  String userId(String username) {
    return '用户ID: $username';
  }

  @override
  String get settings => '设置';

  @override
  String get accountInfo => '账户信息';

  @override
  String get securitySettings => '安全设置';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get helpFeedback => '帮助与反馈';

  @override
  String get rememberedUser => '已记住当前用户';

  @override
  String get logout => '退出登录';

  @override
  String get notifications => '通知';

  @override
  String get enableNotifications => '启用通知';

  @override
  String get receiveNotifications => '接收应用通知';

  @override
  String get appearance => '外观';

  @override
  String get darkMode => '深色模式';

  @override
  String get switchToDarkTheme => '切换到深色主题';

  @override
  String get followSystemTheme => '跟随系统主题';

  @override
  String get autoSwitchTheme => '根据系统设置自动切换主题';

  @override
  String get fontSize => '字体大小';

  @override
  String get application => '应用';

  @override
  String get aboutApp => '关于应用';

  @override
  String get checkUpdates => '检查更新';

  @override
  String get latestVersion => '已是最新版本';

  @override
  String get clearCache => '清除缓存';

  @override
  String get other => '其他';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get userAgreement => '用户协议';

  @override
  String get clearCacheConfirm => '确定要清除应用缓存吗？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get cacheCleared => '缓存已清除';

  @override
  String get examplesCollection => '示例集合';

  @override
  String get appName => 'Flutter应用';

  @override
  String get appVersion => '1.0.0';

  @override
  String get appDescription => '这是一个使用Flutter开发的示例应用。';

  @override
  String get responsiveDesign => '响应式设计';

  @override
  String get responsiveDesignDescription => '此页面演示了不同屏幕尺寸的响应式设计';

  @override
  String get smallScreen => '小屏幕';

  @override
  String get mediumScreen => '中等屏幕';

  @override
  String get largeScreen => '大屏幕';

  @override
  String screenSize(int width, int height) {
    return '屏幕尺寸: $width x $height';
  }

  @override
  String deviceType(String type) {
    return '设备类型: $type';
  }

  @override
  String get sharedElementAnimation => '共享元素动画';

  @override
  String get sharedElementDescription => '此页面演示了共享元素动画效果';

  @override
  String get tapToAnimate => '点击动画';

  @override
  String get sharedElementDemo => '共享元素演示';

  @override
  String get animationPage => '动画页面';

  @override
  String get returnToHome => '返回首页';

  @override
  String get language => '语言';

  @override
  String get followSystemLanguage => '跟随系统语言';

  @override
  String get autoSwitchLanguage => '根据系统设置自动切换语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get english => '英文';

  @override
  String get chinese => '中文';
}
