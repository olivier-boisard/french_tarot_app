import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../cards/face_down_card.dart';

//TODO organize by "FaceUp*" and "FaceDown*"
class FaceDownArea extends StatefulWidget {
  final int _nCards;

  const FaceDownArea(this._nCards, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FaceDownAreaState(_nCards);
}

class _FaceDownAreaState extends State<FaceDownArea> {
  final int _nCards;

  _FaceDownAreaState(this._nCards);

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
