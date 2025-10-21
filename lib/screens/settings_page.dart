import 'package:flutter/material.dart';
import '../app_localizations.dart';
import '../services/theme_service.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // 通知设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context).notifications,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).enableNotifications),
                  subtitle: Text(AppLocalizations.of(context).receiveNotifications),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 外观设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context).appearance,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).darkMode),
                  subtitle: Text(AppLocalizations.of(context).switchToDarkTheme),
                  value: themeService.isDarkMode,
                  onChanged: (value) {
                    themeService.toggleDarkMode();
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).fontSize),
                  subtitle: Text('${themeService.fontSize.toInt()}px'),
                  trailing: SizedBox(
                    width: 200,
                    child: Slider(
                      value: themeService.fontSize,
                      min: 12.0,
                      max: 24.0,
                      divisions: 12,
                      onChanged: (value) {
                        themeService.setFontSize(value);
                      },
                    ),
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).language),
                  subtitle: Text(themeService.language == 'zh' 
                      ? AppLocalizations.of(context).chinese 
                      : AppLocalizations.of(context).english),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showLanguageDialog(themeService);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 应用设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context).application,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(AppLocalizations.of(context).aboutApp),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.update),
                  title: Text(AppLocalizations.of(context).checkUpdates),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).latestVersion)));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.clear_all),
                  title: Text(AppLocalizations.of(context).clearCache),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showClearCacheDialog();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 其他设置
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context).other,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(AppLocalizations.of(context).privacyPolicy),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).privacyPolicy)));
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: Text(AppLocalizations.of(context).userAgreement),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).userAgreement)));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppLocalizations.of(context).appName,
      applicationVersion: AppLocalizations.of(context).appVersion,
      applicationIcon: const Icon(Icons.flutter_dash),
      children: [Text(AppLocalizations.of(context).appDescription)],
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).clearCache),
        content: Text(AppLocalizations.of(context).clearCacheConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).cacheCleared)));
            },
            child: Text(AppLocalizations.of(context).confirm),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(ThemeService themeService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context).chinese),
              leading: Radio<String>(
                value: 'zh',
                groupValue: themeService.language,
                onChanged: (value) {
                  if (value != null) {
                    themeService.setLanguage(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).english),
              leading: Radio<String>(
                value: 'en',
                groupValue: themeService.language,
                onChanged: (value) {
                  if (value != null) {
                    themeService.setLanguage(value);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancel),
          ),
        ],
      ),
    );
  }
}
