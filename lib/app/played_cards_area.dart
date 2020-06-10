import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../engine/core/abstract_tarot_card.dart';
import '../engine/core/function_interfaces.dart';
import 'cards/face_up_card.dart';
import 'core/dimensions.dart';

class PlayedCardsArea extends StatefulWidget {
  final LinkedHashMap<PlayerLocation, Widget> playedCards;
  final Transformer<bool, AbstractTarotCard> cardIsAllowed;
  final Consumer<AbstractTarotCard> playCard;

  // TODO is there a way to get rid of this?
  final Key cardDraggableTargetKey;

  const PlayedCardsArea({
    Key key,
    @required this.playedCards,
    @required this.cardIsAllowed,
    @required this.playCard,
    this.cardDraggableTargetKey,
  }) : super(key: key);

  @override
  _PlayerCardsAreaState createState() {
    return _PlayerCardsAreaState(
      playedCards,
      cardIsAllowed,
      playCard,
    );
  }
}

enum PlayerLocation {
  top,
  left,
  right,
  bottom
}

class _PlayerCardsAreaState extends State<PlayedCardsArea> {
  final LinkedHashMap<PlayerLocation, Widget> playedCards;
  final Transformer<bool, AbstractTarotCard> cardIsAllowed;
  final Consumer<AbstractTarotCard> playCard;
  final Dimensions _cardDimensions;

  _PlayerCardsAreaState(
    this.playedCards,
    this.cardIsAllowed,
    this.playCard,
  ) : _cardDimensions = Dimensions.fromScreen();

  @override
  Widget build(BuildContext context) {
    final cardPlaceHolder = Container(
      width: _cardDimensions.width,
      height: _cardDimensions.height,
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
      onAccept: (cardToPlay) {
        setState(() {
          playCard(cardToPlay);
        });
      },
      builder: (context, candidates, rejects) {
        return candidates.isNotEmpty && cardIsAllowed(candidates.first)
            ? FaceUpCard(card: candidates.first, dimensions: _cardDimensions)
            : Container();
      },
    );
  }
}
