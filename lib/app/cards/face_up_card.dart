import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../engine/core/card.dart'as engine;
import '../../engine/core/suited_playable.dart';

class FaceUpCard extends StatelessWidget {
  //TODO should depend on abstraction of card
  final engine.Card _card;

  const FaceUpCard(this._card, {Key key}) : super(key: key);

  //TODO abstract strength
  String convertStrengthToString(int value) {
    String output;
    if (engine.Card.standardSuits.contains(_card.suit)) {
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

  @override
  Widget build(BuildContext context) {
    const suitToString = <Suit, String>{
      Suit.clover: '♣',
      Suit.heart: '♥',
      Suit.diamond: '♦',
      Suit.spades: '♠',
      Suit.trump: '⭐',
    };
    final valueAsString = convertStrengthToString(_card.value);
    final suitAsString = suitToString[_card.suit];
    const excuseAsString = '🎸';
    final smallTextWidget = Text(
      _card != const engine.Card.excuse()
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

    final cardWidgetHeight = 0.04 * window.physicalSize.height;
    final cardWidgetWidth = cardWidgetHeight / 2;
    final cardWidgetBorderRadius = cardWidgetHeight / 20;

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
                  _card == const engine.Card.excuse()
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
}
