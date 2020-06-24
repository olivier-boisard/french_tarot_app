import 'package:flutter/widgets.dart';

import '../../engine/core/abstract_tarot_card.dart';
import '../cards/face_up_card.dart';
import 'screen_sized.dart';

class FaceUpPlayerArea extends StatelessWidget with ScreenSized {
  final Iterable<FaceUpCard> cards;

  FaceUpPlayerArea({Key key, @required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidgets = <Widget>[];
    var i = 0;
    for (final cardWidget in cards) {
      final draggableCardWidget = Draggable<AbstractTarotCard>(
        data: cardWidget.card,
        feedback: cardWidget,
        child: cardWidget,
      );
      cardWidgets.add(
        ScreenSized.padWidget(draggableCardWidget, i * offsetInPixel),
      );
      i += 1;
    }
    return Stack(children: cardWidgets);
  }
}
