import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter Demo'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter Demo Home Page'**
  String get homeTitle;

  /// No description provided for @navToScreenTest.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Screen Test'**
  String get navToScreenTest;

  /// No description provided for @counterHint.
  ///
  /// In en, this message translates to:
  /// **'You have pushed the button this many times:'**
  String get counterHint;

  /// No description provided for @customLine.
  ///
  /// In en, this message translates to:
  /// **'I custom add a line'**
  String get customLine;

  /// No description provided for @incrementTooltip.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get incrementTooltip;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @screenTestCounter.
  ///
  /// In en, this message translates to:
  /// **'You tapped the wooden fish {count} times'**
  String screenTestCounter(int count);

  /// No description provided for @firstSection.
  ///
  /// In en, this message translates to:
  /// **'First Section'**
  String get firstSection;

  /// No description provided for @secondSection.
  ///
  /// In en, this message translates to:
  /// **'Second Section'**
  String get secondSection;

  /// No description provided for @studentNameAge.
  ///
  /// In en, this message translates to:
  /// **'Name: {name}, Age: {age}'**
  String studentNameAge(String name, int age);

  /// No description provided for @welcomeLogin.
  ///
  /// In en, this message translates to:
  /// **'Welcome Login'**
  String get welcomeLogin;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberUser.
  ///
  /// In en, this message translates to:
  /// **'Remember Current User'**
  String get rememberUser;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginHint.
  ///
  /// In en, this message translates to:
  /// **'Hint: Enter any username and password to login'**
  String get loginHint;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Username or password is incorrect'**
  String get loginError;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID: {username}'**
  String userId(String username);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfo;

  /// No description provided for @securitySettings.
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettings;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @helpFeedback.
  ///
  /// In en, this message translates to:
  /// **'Help & Feedback'**
  String get helpFeedback;

  /// No description provided for @rememberedUser.
  ///
  /// In en, this message translates to:
  /// **'Current user remembered'**
  String get rememberedUser;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @receiveNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive app notifications'**
  String get receiveNotifications;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @switchToDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get switchToDarkTheme;

  /// No description provided for @followSystemTheme.
  ///
  /// In en, this message translates to:
  /// **'Follow System Theme'**
  String get followSystemTheme;

  /// No description provided for @autoSwitchTheme.
  ///
  /// In en, this message translates to:
  /// **'Automatically switch theme based on system settings'**
  String get autoSwitchTheme;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @checkUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check Updates'**
  String get checkUpdates;

  /// No description provided for @latestVersion.
  ///
  /// In en, this message translates to:
  /// **'Latest version'**
  String get latestVersion;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @userAgreement.
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get userAgreement;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear app cache?'**
  String get clearCacheConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get cacheCleared;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Flutter App'**
  String get appName;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get appVersion;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'This is a sample app developed with Flutter.'**
  String get appDescription;

  /// No description provided for @responsiveDesign.
  ///
  /// In en, this message translates to:
  /// **'Responsive Design'**
  String get responsiveDesign;

  /// No description provided for @responsiveDesignDescription.
  ///
  /// In en, this message translates to:
  /// **'This page demonstrates responsive design for different screen sizes'**
  String get responsiveDesignDescription;

  /// No description provided for @smallScreen.
  ///
  /// In en, this message translates to:
  /// **'Small Screen'**
  String get smallScreen;

  /// No description provided for @mediumScreen.
  ///
  /// In en, this message translates to:
  /// **'Medium Screen'**
  String get mediumScreen;

  /// No description provided for @largeScreen.
  ///
  /// In en, this message translates to:
  /// **'Large Screen'**
  String get largeScreen;

  /// No description provided for @screenSize.
  ///
  /// In en, this message translates to:
  /// **'Screen Size: {width} x {height}'**
  String screenSize(int width, int height);

  /// No description provided for @deviceType.
  ///
  /// In en, this message translates to:
  /// **'Device Type: {type}'**
  String deviceType(String type);

  /// No description provided for @sharedElementAnimation.
  ///
  /// In en, this message translates to:
  /// **'Shared Element Animation'**
  String get sharedElementAnimation;

  /// No description provided for @sharedElementDescription.
  ///
  /// In en, this message translates to:
  /// **'This page demonstrates shared element animations'**
  String get sharedElementDescription;

  /// No description provided for @tapToAnimate.
  ///
  /// In en, this message translates to:
  /// **'Tap to animate'**
  String get tapToAnimate;

  /// No description provided for @sharedElementDemo.
  ///
  /// In en, this message translates to:
  /// **'Shared Element Demo'**
  String get sharedElementDemo;

  /// No description provided for @animationPage.
  ///
  /// In en, this message translates to:
  /// **'Animation Page'**
  String get animationPage;

  /// No description provided for @returnToHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get returnToHome;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
