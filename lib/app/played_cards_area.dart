import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../engine/core/abstract_tarot_card.dart';
import 'cards/face_up_card.dart';
import 'core/dimensions.dart';

class PlayedCardsArea extends StatelessWidget {
  final LinkedHashMap<int, Widget> playedCards;

  const PlayedCardsArea({Key key, @required this.playedCards})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget <AbstractTarotCard>(
      //TODO onWillAccept should check the card is allowed
      //TODO onAccept should update app state
      builder: (context, candidates, rejects) {
        return candidates.isNotEmpty ?
        FaceUpCard(
          card: candidates.first,
          dimensions: Dimensions.fromScreen(),
        ) :
        Container();
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Map<int, Widget>>('playedCards', playedCards),
    );
  }
}
