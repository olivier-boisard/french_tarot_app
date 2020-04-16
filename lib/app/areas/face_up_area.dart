import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../engine/core/card.dart';
import '../cards/face_up_card.dart';

class FaceUpArea extends StatefulWidget {
  final List<Card> _hand;

  //TODO convention says: use named argument only
  //TODO first argument should by key, last should be child (if needed)
  //TODO apply this convention everywhere
  const FaceUpArea(this._hand, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FaceUpAreaState(_hand);
}

class _FaceUpAreaState extends State<FaceUpArea>{
  final List<Card> _hand;

  _FaceUpAreaState(this._hand);

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
