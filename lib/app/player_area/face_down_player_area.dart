import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../cards/face_down_card.dart';
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('nCards', nCards));
  }
}
