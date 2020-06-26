import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../engine/core/suits.dart';
import '../player_area/screen_sized.dart';
import 'card_widget.dart';

class FaceUpCard extends AbstractCardWidget with ScreenSized {
  FaceUpCard({
    Key key,
    @required card,
  }) : super(key: key, card: card);

  @override
  Widget build(BuildContext context) {
    final valueAsString = _convertStrengthToString(card.value);
    final suitAsString = _convertSuitToString();
    const excuseString = '🎸';
    final text = card.isExcuse ? excuseString : '$valueAsString\n$suitAsString';
    final smallTextWidget = Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: window.physicalSize.width / 150),
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
      height: dimensions.height,
      width: dimensions.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.white,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
      ),
      child: Column(
        children: <Widget>[
          row,
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                card.isExcuse ? excuseString : '$valueAsString$suitAsString',
                textAlign: TextAlign.center,
              ),
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
    final valueAsString = value.toString();
    if (standardSuits.contains(card.suit)) {
      final valueToString = {11: '♗', 12: '♕', 13: '♘', 14: '♔'};
      output = valueToString[value] ?? valueAsString;
    } else {
      output = valueAsString;
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
}
