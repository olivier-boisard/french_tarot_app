import 'package:flutter/widgets.dart';

import '../../engine/core/abstract_tarot_card.dart';
import '../cards/face_up_card.dart';
import 'screen_sized.dart';

class FaceUpPlayerArea extends StatelessWidget with ScreenSized {
  final List<AbstractTarotCard> cards;

  //TODO is there a way to get rid of this?
  final List<Key> cardWidgetKeys;

  FaceUpPlayerArea({Key key, @required this.cards, this.cardWidgetKeys})
      : super(key: key) {
    if (cardWidgetKeys != null) {
      if (cards.length != cardWidgetKeys.length) {
        throw _InvalidNumberOfKeysException();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardWidgets = <Widget>[];
    for (var i = 0; i < cards.length; i++) {
      final cardPlayedByUser = cards[i];
      final cardWidget = Draggable<AbstractTarotCard>(
        data: cardPlayedByUser,
        key: cardWidgetKeys?.elementAt(i),
        feedback: FaceUpCard(card: cardPlayedByUser, dimensions: dimensions),
        child: FaceUpCard(card: cardPlayedByUser, dimensions: dimensions),
      );
      cardWidgets.add(padWidget(cardWidget, i * offsetInPixel));
    }
    return Stack(children: cardWidgets);
  }
}

class _InvalidNumberOfKeysException implements Exception {}
