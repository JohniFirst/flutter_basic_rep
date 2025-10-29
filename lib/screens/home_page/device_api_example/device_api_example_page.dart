import 'package:flutter/material.dart';
import 'camera_example_page.dart';
import 'notification_example_page.dart';

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
        ],
      ),
    );
  }
}
