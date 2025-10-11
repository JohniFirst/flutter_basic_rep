import 'package:flutter/material.dart';
import 'package:flutter_application_1/student.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
      studentWidgets.add(Text('姓名: ${student.name}, 年龄: ${student.age}'));
    }
    return Column(children: studentWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'I custom add a line',
              style: TextStyle(color: Colors.red, fontSize: 40),
            ),
            showStudentsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
