import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:french_tarot/cards.dart';

class Area extends StatelessWidget {
  final bool visibleHand;

  const Area({this.visibleHand = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nCards = 18;
    final offsetInPixel = window.physicalSize.width / 70;
    final cards = <Widget>[];
    for (var i = 0; i < nCards; i++) {
      cards.add(
        Padding(
          padding: EdgeInsets.only(left: i * offsetInPixel),
          child: visibleHand
              ? FaceUpCard(TarotCard(Suit.heart, Value.numeric_1))
              : FaceDownCard(),
        ),
      );
    }
    return Stack(
        children: cards
    );
  }
}

