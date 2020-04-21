import 'dart:ui';

import 'package:flutter/widgets.dart';

class PlayerArea extends StatelessWidget {
  final List<Widget> cards;

  const PlayerArea({Key key, @required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offsetInPixel = window.physicalSize.width / 70;
    final cardWidgets = <Widget>[];
    for (var i = 0; i < cards.length; i++) {
      cardWidgets.add(
        Padding(
          padding: EdgeInsets.only(left: i * offsetInPixel),
          child: cards[i],
        ),
      );
    }
    return Stack(children: cardWidgets);
  }
}
