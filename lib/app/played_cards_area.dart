import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../engine/core/abstract_tarot_card.dart';
import 'cards/face_up_card.dart';
import 'core/dimensions.dart';

class PlayedCardsArea extends StatelessWidget {
  final LinkedHashMap<PlayerLocation, Widget> playedCards;

  Dimensions get cardDimensions {
    return Dimensions.fromScreen();
  }

  const PlayedCardsArea({Key key, @required this.playedCards})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    final cardPlaceHolder = Container(
      width: cardDimensions.width,
      height: cardDimensions.height,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: playedCards[PlayerLocation.top] ?? cardPlaceHolder,
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(),
              ),
              playedCards[PlayerLocation.left] ?? cardPlaceHolder,
              playedCards[PlayerLocation.right] ?? cardPlaceHolder,
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.topCenter,
            child: playedCards[PlayerLocation.bottom]
                ?? _buildPlayedCardDraggableTarget(),
          ),
        )
      ],
    );
  }

  DragTarget<AbstractTarotCard> _buildPlayedCardDraggableTarget() {
    return DragTarget<AbstractTarotCard>(
      //TODO onWillAccept should check the card is allowed
      //TODO onAccept should update app state
      builder: (context, candidates, rejects) {
        return candidates.isNotEmpty
            ? _buildFaceUpCard(candidates)
            : Container();
      },
    );
  }

  FaceUpCard _buildFaceUpCard(List<AbstractTarotCard> candidates) {
    return FaceUpCard(
      card: candidates.first,
      dimensions: cardDimensions,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(
        DiagnosticsProperty<Dimensions>(
          'cardDimensions',
          cardDimensions,
        )
    )..add(
        DiagnosticsProperty<LinkedHashMap<PlayerLocation, Widget>>(
          'playedCards',
          playedCards,
        )
    );
  }
}

enum PlayerLocation {
  top,
  left,
  right,
  bottom
}
