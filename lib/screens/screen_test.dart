import 'package:flutter/material.dart';
import '../app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenTest extends StatefulWidget {
  const ScreenTest({super.key});

  @override
  State<ScreenTest> createState() => _ScreenTestState();
}

class _ScreenTestState extends State<ScreenTest> {
  int otherNumber = 0;

  // 打开电话应用并自动填充号码
  void launchPhoneApp(String phoneNumber) async {
    // 拼接电话协议（tel: + 电话号码）
    final Uri url = Uri.parse('tel:$phoneNumber');

    try {
      // 检查是否可以打开该链接
      if (await canLaunchUrl(url)) {
        // 启动电话应用
        bool launched = await launchUrl(
          url,
          // 配置启动模式
          mode: LaunchMode.externalApplication,
        );

        if (launched) {
          // 成功启动电话应用
        } else {
          // 启动电话应用失败
        }
      } else {
        // 无法打开电话应用，请检查权限设置
        // 显示用户友好的错误信息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('无法打开电话应用，请检查权限设置'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // 打开电话应用失败
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('打开电话应用失败：$e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(vertical: 28.0, horizontal: 29.0),
              ),
              textStyle: WidgetStateProperty.all(TextStyle(fontSize: 40)),
            ),
            onPressed: () {
              launchPhoneApp('10086');
            },
            child: Row(children: [Text('call 10086')]),
          ),
          Text(
            AppLocalizations.of(context).screenTestCounter(otherNumber),
            style: TextStyle(
              fontSize: 60,
              color: Colors.red,
              decoration: TextDecoration.none,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                otherNumber++;
              });
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
