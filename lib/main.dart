import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'services/auth_service.dart';
import 'services/theme_service.dart';
import 'package:provider/provider.dart';

void main() {
  // 仅在调试模式和桌面环境下启动本地HTTP服务器
  // 避免在生产环境或移动设备上运行
  if (kDebugMode && !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    _startLocalServer();
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: const MyApp(),
    ),
  );
}

void _startLocalServer() async {
  try {
    final server = await HttpServer.bind('localhost', 9975);
    print('本地服务器已启动，监听端口: 9975');

    // 使用Isolate或更轻量的方式处理请求，避免阻塞主UI线程
    // 仅在调试模式下运行
    server.listen((request) {
      _handleServerRequest(request);
    });
  } catch (e) {
    print('启动本地服务器失败: $e');
  }
}

void _handleServerRequest(HttpRequest request) async {
  try {
    if (request.uri.path == '/test') {
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.text
        ..write('hello world');
    } else if (request.uri.path == '/files') {
      try {
        // 获取当前工作目录
        final currentDir = Directory.current;
        // 列出目录内容 - 限制数量避免处理过多文件
        final entities = currentDir.listSync(recursive: false).take(100);
        
        // 构建文件列表响应
        String response = '当前目录: ${currentDir.path}\n\n';
        response += '文件和文件夹列表:\n';
        
        for (var entity in entities) {
          if (entity is Directory) {
            response += '[目录] ${entity.path.split(Platform.pathSeparator).last}\n';
          } else if (entity is File) {
            response += '[文件] ${entity.path.split(Platform.pathSeparator).last}\n';
          }
        }
        
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.text
          ..write(response);
      } catch (e) {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write('获取文件列表失败: $e');
      }
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not Found');
    }
  } finally {
    await request.response.close();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // 注册为WidgetsBinding的观察者
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // 移除观察者
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // 获取当前的亮度模式
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    
    // 获取ThemeService实例并更新主题
    final themeService = context.read<ThemeService>();
    themeService.updateSystemTheme(brightness);
  }
  
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    
    // 获取ThemeService实例并更新语言
    final themeService = context.read<ThemeService>();
    themeService.updateSystemLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: themeService.lightTheme,
          darkTheme: themeService.darkTheme,
          themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('zh'),
          ],
          locale: Locale(themeService.language),
          home: const AppWrapper(),
        );
      },
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  // 临时改为HTTP测试页面，方便测试网络连接
  @override
  Widget build(BuildContext context) {
    // 检查是否已登录，根据登录状态显示不同的页面
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        return snapshot.data == true ? const MainNavigationScreen() : const LoginScreen();
      },
    );
  }
}

