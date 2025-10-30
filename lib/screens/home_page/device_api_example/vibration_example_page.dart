import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class VibrationExamplePage extends StatefulWidget {
  const VibrationExamplePage({super.key});

  @override
  State<VibrationExamplePage> createState() => _VibrationExamplePageState();
}

class _VibrationExamplePageState extends State<VibrationExamplePage> {
  bool _isSimulating = false;
  bool _hasVibrator = false;

  Future<void> _shortVibrate() async {
    await HapticFeedback.vibrate();
  }

  Future<void> _selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  Future<void> _simulatePattern() async {
    if (_isSimulating) return;
    setState(() => _isSimulating = true);
    try {
      // 模拟一个短促-短促-长促的震动序列（通过多次调用 HapticFeedback.vibrate）
      await HapticFeedback.vibrate();
      await Future.delayed(const Duration(milliseconds: 150));
      await HapticFeedback.vibrate();
      await Future.delayed(const Duration(milliseconds: 150));
      await HapticFeedback.vibrate();
    } finally {
      setState(() => _isSimulating = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkVibrator();
  }

  Future<void> _checkVibrator() async {
    final has = await Vibration.hasVibrator();
    if (mounted) {
      setState(() {
        _hasVibrator = has;
      });
    }
  }

  Future<void> _vibrationLong() async {
    if (!_hasVibrator) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('设备不支持震动')));
      return;
    }
    await Vibration.vibrate(duration: 2000);
  }

  Future<void> _vibrationPattern() async {
    if (!_hasVibrator) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('设备不支持震动')));
      return;
    }
    // pattern: [wait, vibrate, wait, vibrate, ...]
    await Vibration.vibrate(pattern: [0, 200, 100, 400, 100, 800]);
  }

  Future<void> _vibrationCancel() async {
    if (!_hasVibrator) return;
    await Vibration.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('震动模式示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            leading: const Icon(Icons.flash_on, color: Colors.green),
            title: const Text('短震'),
            subtitle: const Text('调用 HapticFeedback.vibrate() 触发一次短震'),
            trailing: const Icon(Icons.play_arrow),
            onTap: _shortVibrate,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.touch_app, color: Colors.blue),
            title: const Text('选择点击 (selectionClick)'),
            subtitle: const Text('调用 HapticFeedback.selectionClick() 更轻的触觉反馈'),
            trailing: const Icon(Icons.play_arrow),
            onTap: _selectionClick,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.multiple_stop, color: Colors.purple),
            title: const Text('模拟震动模式'),
            subtitle: const Text('通过多次短震和延迟模拟一个震动序列'),
            trailing: _isSimulating
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
            onTap: _simulatePattern,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.timer, color: Colors.teal),
            title: const Text('长震 (2s) - vibration 插件'),
            subtitle: Text(_hasVibrator ? '支持' : '设备不支持震动'),
            trailing: const Icon(Icons.play_arrow),
            onTap: _vibrationLong,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.auto_fix_high, color: Colors.brown),
            title: const Text('自定义模式 (pattern)'),
            subtitle: const Text('使用 vibration 包的 pattern 参数演示序列'),
            trailing: const Icon(Icons.play_arrow),
            onTap: _vibrationPattern,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.stop, color: Colors.red),
            title: const Text('停止震动'),
            subtitle: const Text('取消当前使用 vibration 的振动'),
            trailing: const Icon(Icons.stop),
            onTap: _vibrationCancel,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              '''说明：
• HapticFeedback 提供的反馈种类和强度取决于设备硬件与系统，效果可能不同。
• 若需要更精确的时长/模式控制，可使用第三方包（例如 vibration），需要在 pubspec.yaml 中添加依赖。''',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
