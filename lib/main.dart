import 'package:flutter/material.dart';

import 'main_page.dart';

// Got inspirations from https://medium.com/flutter-community/creating-solitaire-in-flutter-946c34ef053c

void main() => runApp(FrenchTarotApp());

class FrenchTarotApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MainPage(),
    );
  }
}
