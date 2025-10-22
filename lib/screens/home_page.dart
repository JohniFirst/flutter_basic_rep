import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'responsive_design_page.dart';
import 'shared_element_animation_page.dart';
import 'form_page.dart';
import 'list_loading_page.dart';
import '../app_localizations.dart';

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

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: '退出登录',
          ),
        ],
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

            // 功能按钮
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ResponsiveDesignPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.pageview),
                  label: Text(AppLocalizations.of(context).responsiveDesign),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const SharedElementAnimationPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.animation),
                  label: Text(
                    AppLocalizations.of(context).sharedElementAnimation,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const FormPage()),
                    );
                  },
                  icon: const Icon(Icons.assignment),
                  label: const Text('表单示例'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ListLoadingPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('列表加载示例'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
