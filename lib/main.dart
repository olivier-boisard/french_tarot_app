import 'package:flutter/material.dart';

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

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      ),
      backgroundColor: Colors.green[800],
    );
  }
}
