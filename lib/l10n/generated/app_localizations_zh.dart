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
}
