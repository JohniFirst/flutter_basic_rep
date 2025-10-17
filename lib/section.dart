import 'package:flutter/material.dart';
import 'app_localizations.dart';

class FirstSection extends StatelessWidget {
  const FirstSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          image: AssetImage('images/image-test.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      height: 200,
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context).firstSection,
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          Text(
            AppLocalizations.of(context).secondSection,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 50),
          ),
        ],
      ),
    );
  }
}
