import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:french_tarot/card.dart';

class Area extends StatelessWidget {
  final String areaName;

  const Area(this.areaName, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nCards = 18;
    final offsetInPixel = window.physicalSize.width / 70;
    final cards = <Widget>[];
    for (var i = 0; i < nCards; i++) {
      cards.add(
        Positioned(
          child: FaceDownCard(),
          left: i * offsetInPixel,
        ),
      );
    }
    return Stack(
        children: cards
    );
  }
}
