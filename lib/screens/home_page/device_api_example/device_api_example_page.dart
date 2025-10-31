import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'camera_example_page.dart';
import 'notification_example_page.dart';
import 'vibration_example_page.dart';
import 'clipboard_example_page.dart';
import 'windows_explorer_page.dart';

class DeviceApiExamplePage extends StatelessWidget {
  const DeviceApiExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设备API示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        spacing: 8.0,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, size: 28, color: Colors.blue),
            title: const Text(
              '系统相机',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('调用设备相机拍摄照片'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CameraExamplePage(),
                ),
              );
            },
          ),
          const Divider(),
          // 剪贴板示例（大多数平台可用）
          ListTile(
            leading: const Icon(
              Icons.content_paste,
              size: 28,
              color: Colors.teal,
            ),
            title: const Text(
              '系统剪贴板',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('复制/粘贴示例（适用于移动与桌面）'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ClipboardExamplePage(),
                ),
              );
            },
          ),
          // Windows 专有入口，仅在 Windows 平台显示
          if (!kIsWeb && Platform.isWindows) ...[
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.desktop_windows,
                size: 28,
                color: Colors.green,
              ),
              title: const Text(
                'Windows 专用能力',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('调用 Windows 特有的能力（示例：打开 文档 文件夹）'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const WindowsExplorerPage(),
                  ),
                );
              },
            ),
          ],
          ListTile(
            leading: const Icon(
              Icons.notifications,
              size: 28,
              color: Colors.orange,
            ),
            title: const Text(
              '系统通知',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('发送系统通知'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NotificationExamplePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.vibration,
              size: 28,
              color: Colors.purple,
            ),
            title: const Text(
              '设备震动',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('进入震动模式示例页面'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const VibrationExamplePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
