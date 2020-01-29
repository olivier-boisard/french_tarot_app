import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AbstractCard extends StatelessWidget {
  static final height = (0.04 * window.physicalSize.height);
  static final width = height / 2;
  static final borderRadius = height / 20;
}

class FaceDownCard extends AbstractCard {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AbstractCard.height,
      width: AbstractCard.width,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(AbstractCard.borderRadius),
      ),
    );
  }
}

class FaceUpCard extends StatelessWidget {
  final suit = "♠";
  final value = "R";
  static final cardValueToEmoji = {
    "R": "♔",
    "D": "♕",
    "C": "♘",
    "V": "♗",
  };

  @override
  Widget build(BuildContext context) {
    var centerValueText = (cardValueToEmoji.containsKey(value)
        ? cardValueToEmoji[value]
        : value);
    final smallTextWidget = Text(
      "$value\n$suit",
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
      height: AbstractCard.height,
      width: AbstractCard.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.white,
        borderRadius: BorderRadius.circular(AbstractCard.borderRadius),
      ),
      child: Column(
        children: <Widget>[
          row,
          Expanded(
            child: Align(
              child: Text("$centerValueText$suit", textAlign: TextAlign.center),
              alignment: Alignment.center,
            ),
          ),
          row,
        ],
      ),
    );
  }
}
