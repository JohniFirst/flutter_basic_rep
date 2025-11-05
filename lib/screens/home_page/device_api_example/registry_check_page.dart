import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistryCheckPage extends StatefulWidget {
  const RegistryCheckPage({Key? key}) : super(key: key);

  @override
  State<RegistryCheckPage> createState() => _RegistryCheckPageState();
}

class _RegistryCheckPageState extends State<RegistryCheckPage> {
  String _status = '等待扫描...';
  List<String> _found = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && Platform.isWindows) {
      // Run a scan after first frame so UI shows quickly
      WidgetsBinding.instance.addPostFrameCallback((_) => _scanRegistry());
    } else {
      _status = '此功能仅在 Windows 平台可用。';
    }
  }

  Future<void> _scanRegistry() async {
    setState(() {
      _loading = true;
      _status = '正在扫描注册表，查找 VS Code...';
      _found = [];
    });

    try {
      // Candidate uninstall keys to search
      final keys = <String>[
        r'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
        r'HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall',
        r'HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
      ];

      final matchingKeys = <String>{};

      for (final key in keys) {
        // Use Windows `reg` command to search for "Visual Studio Code"
        final result = await Process.run('reg', [
          'query',
          key,
          '/s',
          '/f',
          'Visual Studio Code',
        ]);
        if (result.exitCode == 0) {
          final out = result.stdout?.toString() ?? '';
          // Extract any HKEY... lines which point to subkeys
          final regKeyRegexp = RegExp(
            r'^(HKEY(?:_LOCAL_MACHINE|_CURRENT_USER)[^\r\n]*)',
            multiLine: true,
          );
          for (final m in regKeyRegexp.allMatches(out)) {
            final foundKey = m.group(1)?.trim();
            if (foundKey != null && foundKey.isNotEmpty)
              matchingKeys.add(foundKey);
          }
        }
      }

      // For each matching key, try to read InstallLocation or DisplayIcon
      for (final k in matchingKeys) {
        // Query InstallLocation
        final installRes = await Process.run('reg', [
          'query',
          k,
          '/v',
          'InstallLocation',
        ]);
        if (installRes.exitCode == 0) {
          final txt = installRes.stdout?.toString() ?? '';
          final m = RegExp(
            r'InstallLocation\s+REG_[A-Z]+\s+(.*)',
            caseSensitive: false,
          ).firstMatch(txt);
          if (m != null) {
            final path = m.group(1)?.trim();
            if (path != null && path.isNotEmpty) _found.add(path);
            continue;
          }
        }

        // Query DisplayIcon as fallback (often contains path to Code.exe)
        final iconRes = await Process.run('reg', [
          'query',
          k,
          '/v',
          'DisplayIcon',
        ]);
        if (iconRes.exitCode == 0) {
          final txt = iconRes.stdout?.toString() ?? '';
          final m = RegExp(
            r'DisplayIcon\s+REG_[A-Z]+\s+(.*)',
            caseSensitive: false,
          ).firstMatch(txt);
          if (m != null) {
            var value = m.group(1)?.trim() ?? '';
            // DisplayIcon may contain command-line args like ",0"; strip trailing comma and args
            value = value.split(',')[0].trim();
            if (value.isNotEmpty) {
              // If it's a file path to Code.exe, use its directory
              final file = File(value.replaceAll('"', ''));
              if (file.existsSync()) {
                _found.add(file.parent.path);
              } else {
                _found.add(value);
              }
            }
          }
        }
      }

      // If nothing found via reg, try common default install locations
      if (_found.isEmpty) {
        final candidates = <String>[
          Platform.environment['LOCALAPPDATA'] != null
              ? '${Platform.environment['LOCALAPPDATA']}\\Programs\\Microsoft VS Code\\Code.exe'
              : '',
          r'C:\Program Files\Microsoft VS Code\Code.exe',
          r'C:\Program Files (x86)\Microsoft VS Code\Code.exe',
        ];
        for (final c in candidates) {
          if (c.isEmpty) continue;
          final f = File(c.replaceAll('"', ''));
          if (f.existsSync()) {
            _found.add(f.parent.path);
          }
        }
      }

      setState(() {
        if (_found.isNotEmpty) {
          _status = '找到以下 VS Code 安装目录：';
        } else {
          _status = '未在注册表或常见安装路径中找到 VS Code。';
        }
      });
    } catch (e) {
      setState(() {
        _status = '扫描时发生错误：$e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('读取注册表'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_status),
            const SizedBox(height: 12),
            if (_loading) const LinearProgressIndicator(),
            if (!_loading && _found.isNotEmpty) ...[
              for (final p in _found)
                Card(
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(p),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: p));
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('路径已复制')));
                      },
                    ),
                  ),
                ),
            ],
            if (!_loading && _found.isEmpty) ...[
              const SizedBox(height: 8),
              Text('（如果未找到，可尝试手动检查下列常见路径：'),
              const SizedBox(height: 6),
              Text('- %LocalAppData%\\Programs\\Microsoft VS Code\\'),
              Text('- C:\\Program Files\\Microsoft VS Code\\'),
              Text('- C:\\Program Files (x86)\\Microsoft VS Code\\'),
              const SizedBox(height: 6),
              const Text('）'),
            ],
            const Spacer(),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _loading ? null : _scanRegistry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新扫描'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('返回'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
