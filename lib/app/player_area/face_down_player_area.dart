import 'package:flutter/widgets.dart';

import '../../engine/core/function_interfaces.dart';
import 'screen_sized.dart';

class FaceDownPlayerArea extends StatelessWidget with ScreenSized {
  final int nCards;

  FaceDownPlayerArea({Key key, @required this.nCards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidgets = <Widget>[];
    for (var i = 0; i < nCards; i++) {
      final cardWidget = FaceDownCard();
      cardWidgets.add(ScreenSized.padWidget(cardWidget, i * offsetInPixel));
    }
    return Stack(children: cardWidgets);
  }
}
