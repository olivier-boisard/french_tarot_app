import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../engine/core/abstract_tarot_card.dart';
import 'cards/face_up_card.dart';
import 'played_cards_area.dart';
import 'player_area/face_down_player_area.dart';
import 'player_area/face_up_player_area.dart';
import 'player_area/screen_sized.dart';

class GamePage extends StatefulWidget {
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
  State<StatefulWidget> createState() {
    return _GamePageState(
      visibleHand: visibleHand,
      visibleCardKeys: visibleCardKeys,
      cardDraggableTargetKey: cardDraggableTargetKey,
      playerHandKey: playerHandKey,
    );
  }
}

class _GamePageState extends State<GamePage> with ScreenSized {
  final List<AbstractTarotCard> visibleHand;

  //TODO is there a way to get rid of this?
  final List<Key> visibleCardKeys;
  final Key cardDraggableTargetKey;
  final Key playerHandKey;

  _GamePageState({
    @required this.visibleHand,
    this.cardDraggableTargetKey,
    this.visibleCardKeys,
    this.playerHandKey,
  });

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

  void _updateVisibleHand(
    Iterable<AbstractTarotCard> newHand,
    Iterable<Key> newKeys,
  ) {
    setState(() {
      _replaceListElements(visibleHand, newHand);
      _replaceListElements(visibleCardKeys, newKeys);
    });
  }

  static void _replaceListElements(List list, Iterable newElements) {
    list
      ..clear()
      ..addAll(newElements);
  }
}

class Game implements Exception {}
