import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../engine/core/abstract_tarot_card.dart';
import '../engine/core/function_interfaces.dart';
import 'cards/face_up_card.dart';
import 'core/dimensions.dart';

class PlayedCardsArea extends StatelessWidget {
  final LinkedHashMap<PlayerLocation, Widget> playedCards;
  final Transformer<bool, AbstractTarotCard> cardIsAllowed;

  Dimensions get cardDimensions {
    return Dimensions.fromScreen();
  }

  const PlayedCardsArea({
    Key key,
    @required this.playedCards,
    @required this.cardIsAllowed,
  }) : super(key: key);


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
      onWillAccept: cardIsAllowed,
      //TODO onAccept should play card
      builder: (context, candidates, rejects) {
        return candidates.isNotEmpty && cardIsAllowed(candidates.first)
            ? FaceUpCard(card: candidates.first, dimensions: cardDimensions)
            : Container();
      },
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
    )..add(
        ObjectFlagProperty<Transformer<bool, AbstractTarotCard>>.has(
            'cardIsAllowed',
            cardIsAllowed
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
