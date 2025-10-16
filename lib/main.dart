import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';
import 'package:flutter_application_1/screens/screen_test.dart';
import 'package:flutter_application_1/student.dart';

import 'section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
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
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  int intNumber = 1;
  double doubleNumber = 1.0;
  bool booleanValue = false;
  String text = '123123';

  List<int> basicIntList = [1, 2, 3, 4];
  List<double> basicDoubleList = [1.0, 2.0, 3.0, 4.0];
  List<bool> basicBoolList = [true, false];
  List<String> basicStringList = ['123', '456'];

  List<Student> studentsList = [
    Student(name: 'zhangsan', age: 18),
    Student(name: 'lisi', age: 19),
    Student(name: 'wangwu', age: 1),
    Student(name: 'zhangliu', age: 78),
  ];

  Widget showStudentsList() {
    List<Widget> studentWidgets = [];
    for (var student in studentsList) {
      studentWidgets.add(Text(AppLocalizations.of(context).studentNameAge(student.name, student.age)));
    }
    return Column(children: studentWidgets);
  }

  @override
  Widget build(BuildContext context) {
    // Recompute title from localization to keep it dynamic on locale change
    final localizedTitle = AppLocalizations.of(context).homeTitle;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(localizedTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => ScreenTest()));
              },
              child: Text(AppLocalizations.of(context).navToScreenTest),
            ),
            Text(AppLocalizations.of(context).counterHint),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              AppLocalizations.of(context).customLine,
              style: TextStyle(color: Colors.red, fontSize: 40),
            ),
            showStudentsList(),
            Row(
              children: [
                Expanded(child: FirstSection()),
                // Expanded(child: FirstSection()),
                // Expanded(child: FirstSection()),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: AppLocalizations.of(context).incrementTooltip,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
