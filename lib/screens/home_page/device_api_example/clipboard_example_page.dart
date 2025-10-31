import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardExamplePage extends StatefulWidget {
  const ClipboardExamplePage({super.key});

  @override
  State<ClipboardExamplePage> createState() => _ClipboardExamplePageState();
}

class _ClipboardExamplePageState extends State<ClipboardExamplePage> {
  final TextEditingController _controller = TextEditingController();
  String _pasted = '';

  Future<void> _copy() async {
    final text = _controller.text;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已复制到剪贴板')));
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    setState(() {
      _pasted = data?.text ?? '';
    });
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已从剪贴板粘贴')));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('剪贴板示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('输入文本，然后使用复制/粘贴操作：'),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '输入要复制的文本',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _copy,
                  icon: const Icon(Icons.copy),
                  label: const Text('复制'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _paste,
                  icon: const Icon(Icons.paste),
                  label: const Text('粘贴'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('粘贴内容：'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(_pasted.isEmpty ? '（无）' : _pasted),
            ),
          ],
        ),
      ),
    );
  }
}
