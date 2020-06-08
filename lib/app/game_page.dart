import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../engine/core/abstract_tarot_card.dart';
import 'cards/face_up_card.dart';
import 'played_cards_area.dart';
import 'player_area/face_down_player_area.dart';
import 'player_area/face_up_player_area.dart';
import 'player_area/screen_sized.dart';

class GamePage extends StatelessWidget with ScreenSized {
  final List<AbstractTarotCard> visibleHand;

  //TODO is there a way to get rid of this?
  final List<Key> visibleCardKeys;
  final Key cardDraggableTargetKey;
  final Key playerHandKey;

  GamePage({
    Key key,
    @required this.visibleHand,
    this.visibleCardKeys,
    this.cardDraggableTargetKey,
    this.playerHandKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final faceDownPlayerArea = FaceDownPlayerArea(nCards: visibleHand.length);
    final playedCards = LinkedHashMap<PlayerLocation, Widget>();
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: faceDownPlayerArea,
          ),
          Expanded(
            // Screen middle (left player, play area, right player)
            flex: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: faceDownPlayerArea,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: PlayedCardsArea(
                    playedCards: playedCards,
                    cardIsAllowed: (card) => true,
                    playCard: (card) {
                      // Display card that was played by user
                      playedCards[PlayerLocation.bottom] = FaceUpCard(
                        card: card,
                        dimensions: dimensions,
                      );
                    },
                    cardDraggableTargetKey: cardDraggableTargetKey,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: faceDownPlayerArea,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // Human Player
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FaceUpPlayerArea(
                cards: visibleHand,
                cardWidgetKeys: visibleCardKeys,
                key: playerHandKey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvalidNumberOfPlayerAreasException implements Exception {}
