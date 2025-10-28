import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'examples_collection_page.dart';
import 'device_api_example/device_api_example_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _currentUsername;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final username = await AuthService.getCurrentUsername();
    setState(() {
      _currentUsername = username;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _showBottomSheetForm() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  '填写表单',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '标题',
                  border: OutlineInputBorder(),
                  hintText: '请输入标题',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入标题';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: '内容',
                  border: OutlineInputBorder(),
                  hintText: '请输入内容',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入内容';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('取消'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 这里可以处理表单提交逻辑
                      if (titleController.text.isNotEmpty &&
                          contentController.text.isNotEmpty) {
                        // 显示成功提示
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('表单提交成功'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        // 关闭弹窗
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('提交'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        titleTextStyle: const TextStyle(fontSize: 18), // 减小字体大小
        toolbarHeight: 50, // 减小高度
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 欢迎信息
            const Icon(Icons.home, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text('欢迎回来！', style: Theme.of(context).textTheme.headlineMedium),
            if (_currentUsername != null) ...[
              const SizedBox(height: 10),
              Text(
                '当前用户：$_currentUsername',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 40),

            // 计数器
            const Text('计数器：', style: TextStyle(fontSize: 18)),
            Text('$_counter', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('增加计数'),
            ),

            const SizedBox(height: 40),

            // 功能按钮 - 导航到示例集合页面
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ExamplesCollectionPage(),
                  ),
                );
              },
              icon: const Icon(Icons.grid_view),
              label: const Text('查看示例集合'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),

            // 新按钮 - 导航到设备API示例页面
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DeviceApiExamplePage(),
                  ),
                );
              },
              icon: const Icon(Icons.devices),
              label: const Text('设备API示例'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBottomSheetForm,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: '填写表单',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
