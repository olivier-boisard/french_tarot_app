import 'package:flutter/material.dart';

// Got inspirations from https://medium.com/flutter-community/creating-solitaire-in-flutter-946c34ef053c

class FrenchTarotApp extends StatelessWidget {
  final Widget gameWidget;

  const FrenchTarotApp({Key key, @required this.gameWidget}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'French Tarot',
      home: gameWidget,
    );
  }
}
