import 'package:flutter/widgets.dart';

import '../../engine/core/abstract_tarot_card.dart';
import '../cards/face_up_card.dart';
import 'screen_sized.dart';

class FaceUpPlayerArea extends StatelessWidget with ScreenSized {
  final List<FaceUpCard> cards;

  FaceUpPlayerArea({Key key, @required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidgets = <Widget>[];
    for (var i = 0; i < cards.length; i++) {
      final card = cards[i].card;
      final cardWidget = FaceUpCard(card: card, dimensions: dimensions);
      final draggableCardWidget = Draggable<AbstractTarotCard>(
        data: card,
        feedback: cardWidget,
        child: cardWidget,
      );
      cardWidgets.add(
        ScreenSized.padWidget(draggableCardWidget, i * offsetInPixel),
      );
    }
    return Stack(children: cardWidgets);
  }
}
