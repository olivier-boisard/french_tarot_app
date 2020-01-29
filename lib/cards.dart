import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Suit {
  diamond,
  heart,
  spades,
  club,
  trump
}

enum Value {
  numeric_1,
  numeric_2,
  numeric_3,
  numeric_4,
  numeric_5,
  numeric_6,
  numeric_7,
  numeric_8,
  numeric_9,
  numeric_10,
  numeric_11,
  numeric_12,
  numeric_13,
  numeric_14,
  numeric_15,
  numeric_16,
  numeric_17,
  numeric_18,
  numeric_19,
  numeric_20,
  numeric_21,
  jack,
  knight,
  queen,
  king
}

final _cardWidgetHeight = (0.04 * window.physicalSize.height);
final _cardWidgetWidth = _cardWidgetHeight / 2;
final _cardWidgetBorderRadius = _cardWidgetHeight / 20;

class BadSuitValueCombinationException implements Exception {}

class TarotCard {
  final Suit suit;
  final Value value;

  TarotCard(this.suit, this.value);
}


class FaceDownCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardWidgetHeight,
      width: _cardWidgetWidth,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(_cardWidgetBorderRadius),
      ),
    );
  }
}

class FaceUpCard extends StatelessWidget {
  static const Map<Suit, String> _suitToString = {
    Suit.club: "♣",
    Suit.heart: "♥",
    Suit.diamond: "♦",
    Suit.spades: "♠"
  };

  static const Map<Value, String> _valueToString = {
    Value.numeric_1: "1",
    Value.numeric_2: "2",
    Value.numeric_3: "3",
    Value.numeric_4: "4",
    Value.numeric_5: "5",
    Value.numeric_6: "6",
    Value.numeric_7: "7",
    Value.numeric_8: "8",
    Value.numeric_9: "9",
    Value.numeric_10: "10",
    Value.king: "♔",
    Value.queen: "♕",
    Value.knight: "♘",
    Value.jack: "♗",
  };

  final TarotCard card;


  const FaceUpCard(this.card, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final valueAsString = _valueToString[card.value];
    final suitAsString = _suitToString[card.suit];
    final smallTextWidget = Text(
      "$valueAsString\n$suitAsString",
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
      height: _cardWidgetHeight,
      width: _cardWidgetWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardWidgetBorderRadius),
      ),
      child: Column(
        children: <Widget>[
          row,
          Expanded(
            child: Align(
              child: Text(
                  "$valueAsString$suitAsString",
                  textAlign: TextAlign.center
              ),
              alignment: Alignment.center,
            ),
          ),
          row,
        ],
      ),
    );
  }
}
