import 'package:flutter/widgets.dart';

import '../../engine/core/function_interfaces.dart';
import 'screen_sized.dart';

class FaceDownPlayerArea extends StatelessWidget with ScreenSized {
  final int nCards;
  final Factory<Widget> faceDownCardFactory;

  FaceDownPlayerArea({
    Key key,
    @required this.nCards,
    @required this.faceDownCardFactory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidgets = <Widget>[];
    for (var i = 0; i < nCards; i++) {
      cardWidgets.add(ScreenSized.padWidget(
        faceDownCardFactory(),
        i * offsetInPixel,
      ));
    }
    return Stack(children: cardWidgets);
  }
}
