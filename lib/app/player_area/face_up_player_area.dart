import 'package:flutter/widgets.dart';

import '../../engine/core/abstract_tarot_card.dart';
import '../cards/face_up_card.dart';
import 'screen_sized.dart';

class FaceUpPlayerArea extends StatelessWidget with ScreenSized {
  final List<AbstractTarotCard> cards;

  FaceUpPlayerArea({Key key, @required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidgets = <Widget>[];
    for (var i = 0; i < cards.length; i++) {
      final cardPlayedByUser = cards[i];
      final cardWidget = Draggable<AbstractTarotCard>(
        data: cardPlayedByUser,
        feedback: FaceUpCard(card: cardPlayedByUser, dimensions: dimensions),
        child: FaceUpCard(card: cardPlayedByUser, dimensions: dimensions),
      );
      cardWidgets.add(ScreenSized.padWidget(cardWidget, i * offsetInPixel));
    }
    return Stack(children: cardWidgets);
  }
}
