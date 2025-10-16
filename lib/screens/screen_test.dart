import 'package:flutter/material.dart';
import '../app_localizations.dart';

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chevron_left_rounded),
              SizedBox(width: 4),
              Text(AppLocalizations.of(context).back),
            ],
          ),
        ),
        Text(
          AppLocalizations.of(context).screenTestCounter(otherNumber),
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
