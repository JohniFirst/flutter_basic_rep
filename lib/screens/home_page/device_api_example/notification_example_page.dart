import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class NotificationExamplePage extends StatefulWidget {
  const NotificationExamplePage({super.key});

  @override
  State<NotificationExamplePage> createState() => _NotificationExamplePageState();
}

class _NotificationExamplePageState extends State<NotificationExamplePage> {
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // 初始化设置
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 检查和请求权限
    await _requestNotificationPermission();
  }

  // 请求通知权限
  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      // Android 13+ (API 33+) 需要请求POST_NOTIFICATIONS权限
      if (await Permission.notification.isDenied) {
        final status = await Permission.notification.request();
        setState(() {
          _permissionGranted = status.isGranted;
        });
      } else {
        final isGranted = await Permission.notification.isGranted;
        setState(() {
          _permissionGranted = isGranted;
        });
      }
    } else if (Platform.isIOS) {
      // iOS权限检查
      final status = await Permission.notification.status;
      if (status.isDenied) {
        final newStatus = await Permission.notification.request();
        setState(() {
          _permissionGranted = newStatus.isGranted;
        });
      } else {
        setState(() {
          _permissionGranted = status.isGranted;
        });
      }
    } else {
      // 其他平台默认授予权限
      setState(() {
        _permissionGranted = true;
      });
    }
  }

  Future<void> _sendNotification() async {
    try {
      // 再次检查权限
      if (!_permissionGranted) {
        await _requestNotificationPermission();
        if (!_permissionGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('请先授予通知权限'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }
      }

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'basic_channel',
        '基本通知',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails();

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.show(
        0,
        '测试通知',
        '这是一条来自Flutter应用的系统通知',
        platformChannelSpecifics,
        payload: '这是通知的附加数据',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('通知发送成功'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('通知发送失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 手动请求权限的方法
  Future<void> _requestPermissionManually() async {
    await _requestNotificationPermission();
    if (_permissionGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('通知权限已授予'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('通知权限未授予，请在设备设置中允许'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('系统通知示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.notifications_active,
                size: 80,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              const Text(
                '系统通知测试',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                _permissionGranted ? '通知权限已授予' : '通知权限未授予',
                style: TextStyle(
                  color: _permissionGranted ? Colors.green : Colors.red,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              !_permissionGranted
                  ? ElevatedButton(
                      onPressed: _requestPermissionManually,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('请求通知权限'),
                    )
                  : Container(),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _sendNotification,
                icon: const Icon(Icons.send),
                label: const Text('发送系统通知'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.orange,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '点击按钮将发送一条测试通知到系统通知栏',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}