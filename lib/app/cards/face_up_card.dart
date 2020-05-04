import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../engine/core/abstract_tarot_card.dart';
import '../../engine/core/suited_playable.dart';
import '../../engine/core/tarot_card.dart' as engine;
import 'abstract_card_widget.dart';
import 'dimensions.dart';

class FaceUpCard extends AbstractCardWidget {
  final AbstractTarotCard card;

  const FaceUpCard({ Key key, @required this.card, @required dimensions})
      : super(key: key, dimensions: dimensions);

  @override
  Widget build(BuildContext context) {
    final valueAsString = _convertStrengthToString(card.value);
    final suitAsString = _convertSuitToString();
    const excuseAsString = '🎸';
    final smallTextWidget = Text(
      card != const engine.TarotCard.excuse()
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
                  card.isExcuse
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
    if (engine.TarotCard.standardSuits.contains(card.suit)) {
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
    properties..add(DiagnosticsProperty<engine.TarotCard>('card', card))..add(
      DiagnosticsProperty<Dimensions>('dimensions', dimensions),
    );
  }
}
