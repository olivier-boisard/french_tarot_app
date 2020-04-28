import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../engine/core/card.dart' as engine;
import '../../engine/core/suited_playable.dart';
import 'dimensions.dart';

class FaceUpCard extends StatelessWidget {
  //TODO should depend on abstraction of card
  final engine.Card card;

  const FaceUpCard({Key key, @required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final valueAsString = _convertStrengthToString(card.value);
    final suitAsString = _convertSuitToString();
    const excuseAsString = '🎸';
    final smallTextWidget = Text(
      card != const engine.Card.excuse()
          ? '$valueAsString\n$suitAsString'
          : excuseAsString,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: window.physicalSize.width / 150,
      ),
    );
    final row = Row(
      children: <Widget>[
        smallTextWidget,
        Expanded(
          child: Container(),
        ),
        smallTextWidget,
      ],
    );

    return Container(
      height: cardWidgetHeight,
      width: cardWidgetWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardWidgetBorderRadius),
      ),
      child: Column(
        children: <Widget>[
          row,
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                  card == const engine.Card.excuse()
                      ? excuseAsString
                      : '$valueAsString$suitAsString',
                  textAlign: TextAlign.center),
            ),
          ),
          row,
        ],
      ),
    );
  }

  //TODO abstract strength
  String _convertStrengthToString(int value) {
    String output;
    if (engine.Card.standardSuits.contains(card.suit)) {
      final valueToString = {
        11: '♗',
        12: '♕',
        13: '♘',
        14: '♔',
      };
      output = valueToString[value] ?? value.toString();
    } else {
      output = value.toString();
    }

    return output;
  }

  String _convertSuitToString() {
    const suitToString = <Suit, String>{
      Suit.clover: '♣',
      Suit.heart: '♥',
      Suit.diamond: '♦',
      Suit.spades: '♠',
      Suit.trump: '⭐',
    };
    return suitToString[card.suit];
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<engine.Card>('card', card));
  }
}
