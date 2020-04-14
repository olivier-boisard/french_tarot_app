import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../engine/core/card.dart';
import '../cards/face_up_card.dart';

class FaceUpArea extends StatelessWidget {
  //TODO should depend on abstraction of Card
  final List<Card> _hand;

  const FaceUpArea(this._hand, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offsetInPixel = window.physicalSize.width / 70;
    final cardWidgets = <Widget>[];
    for (var i = 0; i < _hand.length; i++) {
      cardWidgets.add(
        Padding(
          padding: EdgeInsets.only(left: i * offsetInPixel),
          child: FaceUpCard(_hand[i]),
        ),
      );
    }
    return Stack(children: cardWidgets);
  }
}
