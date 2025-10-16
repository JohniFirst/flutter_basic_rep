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
}
