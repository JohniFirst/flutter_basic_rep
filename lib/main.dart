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
  // 在桌面环境下启动本地HTTP服务器
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
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
    // 本地服务器已启动，监听端口: 9975
    // 可以通过 http://localhost:9975/test 访问
    // 可以通过 http://localhost:9975/files 访问文件列表

    await for (var request in server) {
      if (request.uri.path == '/test') {
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.text
          ..write('hello world');
      } else if (request.uri.path == '/files') {
        try {
          // 获取当前工作目录
          final currentDir = Directory.current;
          // 列出目录内容
          final entities = currentDir.listSync();
          
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
      await request.response.close();
    }
  } catch (e) {
    // 启动本地服务器失败: $e
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
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _isLoggedIn 
        ? const MainNavigationScreen() 
        : const LoginScreen();
  }
}

