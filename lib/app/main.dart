import 'package:flutter/material.dart';

import '../engine/core/card.dart' as engine;
import 'game_page.dart';

// Got inspirations from https://medium.com/flutter-community/creating-solitaire-in-flutter-946c34ef053c

class FrenchTarotApp extends StatelessWidget {
  final List<engine.Card> _visibleHand;

  FrenchTarotApp(this._visibleHand, {Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'French Tarot',
      home: GamePage(_visibleHand),
    );
  }
}
