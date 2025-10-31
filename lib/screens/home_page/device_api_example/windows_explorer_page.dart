import 'dart:io';

import 'package:flutter/material.dart';

class WindowsExplorerPage extends StatefulWidget {
  const WindowsExplorerPage({super.key});

  @override
  State<WindowsExplorerPage> createState() => _WindowsExplorerPageState();
}

class _WindowsExplorerPageState extends State<WindowsExplorerPage> {
  Future<void> _openDocuments() async {
    try {
      final userProfile = Platform.environment['USERPROFILE'] ?? '';
      final docs = userProfile.isNotEmpty ? '$userProfile\\Documents' : '';
      if (docs.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('无法获取用户 Documents 路径')));
        return;
      }

      // 在 Windows 上使用 explorer 打开文档目录
      await Process.start('explorer', [docs]);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('已打开 文档 文件夹')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('打开失败: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Windows 专用示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('该页面展示 Windows 专有能力的调用示例：'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _openDocuments,
              icon: const Icon(Icons.folder_open),
              label: const Text('打开 文档 文件夹 (Windows)'),
            ),
            const SizedBox(height: 8),
            const Text('说明：仅在 Windows 平台显示此入口，且调用 explorer 来打开本地目录。'),
          ],
        ),
      ),
    );
  }
}
