import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../cards.dart';

//TODO organize by "FaceUp*" and "FaceDown*"
class FaceDownArea extends StatelessWidget {
  final int _nCards;

  const FaceDownArea(this._nCards, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offsetInPixel = window.physicalSize.width / 70;
    final cardWidgets = <Widget>[];
    for (var i = 0; i < _nCards; i++) {
      cardWidgets.add(
        Padding(
          padding: EdgeInsets.only(left: i * offsetInPixel),
          child: FaceDownCard(),
        ),
      );
    }
    return Stack(children: cardWidgets);
  }
}
