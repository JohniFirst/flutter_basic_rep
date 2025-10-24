// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Demo';

  @override
  String get homeTitle => 'Flutter Demo Home Page';

  @override
  String get navToScreenTest => 'Navigate to Screen Test';

  @override
  String get counterHint => 'You have pushed the button this many times:';

  @override
  String get customLine => 'I custom add a line';

  @override
  String get incrementTooltip => 'Increment';

  @override
  String get back => 'Back';

  @override
  String screenTestCounter(int count) {
    return 'You tapped the wooden fish $count times';
  }

  @override
  String get firstSection => 'First Section';

  @override
  String get secondSection => 'Second Section';

  @override
  String studentNameAge(String name, int age) {
    return 'Name: $name, Age: $age';
  }

  @override
  String get welcomeLogin => 'Welcome Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get rememberUser => 'Remember Current User';

  @override
  String get login => 'Login';

  @override
  String get loginHint => 'Hint: Enter any username and password to login';

  @override
  String get loginError => 'Username or password is incorrect';

  @override
  String get profile => 'Profile';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String userId(String username) {
    return 'User ID: $username';
  }

  @override
  String get settings => 'Settings';

  @override
  String get accountInfo => 'Account Info';

  @override
  String get securitySettings => 'Security Settings';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get helpFeedback => 'Help & Feedback';

  @override
  String get rememberedUser => 'Current user remembered';

  @override
  String get logout => 'Logout';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get receiveNotifications => 'Receive app notifications';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get switchToDarkTheme => 'Switch to dark theme';

  @override
  String get followSystemTheme => 'Follow System Theme';

  @override
  String get autoSwitchTheme =>
      'Automatically switch theme based on system settings';

  @override
  String get fontSize => 'Font Size';

  @override
  String get application => 'Application';

  @override
  String get aboutApp => 'About App';

  @override
  String get checkUpdates => 'Check Updates';

  @override
  String get latestVersion => 'Latest version';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get other => 'Other';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get userAgreement => 'User Agreement';

  @override
  String get clearCacheConfirm => 'Are you sure you want to clear app cache?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get cacheCleared => 'Cache cleared';

  @override
  String get examplesCollection => 'Examples Collection';

  @override
  String get appName => 'Flutter App';

  @override
  String get appVersion => '1.0.0';

  @override
  String get appDescription => 'This is a sample app developed with Flutter.';

  @override
  String get responsiveDesign => 'Responsive Design';

  @override
  String get responsiveDesignDescription =>
      'This page demonstrates responsive design for different screen sizes';

  @override
  String get smallScreen => 'Small Screen';

  @override
  String get mediumScreen => 'Medium Screen';

  @override
  String get largeScreen => 'Large Screen';

  @override
  String screenSize(int width, int height) {
    return 'Screen Size: $width x $height';
  }

  @override
  String deviceType(String type) {
    return 'Device Type: $type';
  }

  @override
  String get sharedElementAnimation => 'Shared Element Animation';

  @override
  String get sharedElementDescription =>
      'This page demonstrates shared element animations';

  @override
  String get tapToAnimate => 'Tap to animate';

  @override
  String get sharedElementDemo => 'Shared Element Demo';

  @override
  String get animationPage => 'Animation Page';

  @override
  String get returnToHome => 'Return to Home';

  @override
  String get language => 'Language';

  @override
  String get followSystemLanguage => 'Follow System Language';

  @override
  String get autoSwitchLanguage =>
      'Automatically switch language based on system settings';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';
}
