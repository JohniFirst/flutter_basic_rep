import 'package:flutter/material.dart';

class ScreenTest extends StatefulWidget {
  const ScreenTest({super.key});

  @override
  State<ScreenTest> createState() => _ScreenTestState();
}

class _ScreenTestState extends State<ScreenTest> {
  int otherNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.chevron_left_rounded),
        ),
        Text(
          '你已经敲击了这个木鱼$otherNumber次',
          style: TextStyle(
            fontSize: 100,
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
    );
  }
}
