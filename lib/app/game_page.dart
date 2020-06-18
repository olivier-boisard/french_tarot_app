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
  final Map<PlayerLocation, Widget> playedCards;

  const GamePage({
    Key key,
    @required this.visibleHand,
    this.playedCards = const <PlayerLocation, Widget>{},
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GamePageState(
      visibleHand: visibleHand,
      playedCards: playedCards,
    );
  }
}

class _GamePageState extends State<GamePage> with ScreenSized {
  final List<AbstractTarotCard> visibleHand;
  final Map<PlayerLocation, Widget> playedCards;

  _GamePageState({@required this.visibleHand, @required this.playedCards});

  @override
  Widget build(BuildContext context) {
    final faceDownPlayerArea = FaceDownPlayerArea(nCards: visibleHand.length);
    final playedCardsMutable = Map<PlayerLocation, Widget>.from(playedCards);
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
                    playedCards: playedCardsMutable,
                    cardIsAllowed: (card) => true,
                    playCard: (card) {
                      setState(() {
                        playedCardsMutable[PlayerLocation.bottom] = FaceUpCard(
                          card: card,
                          dimensions: dimensions,
                        );
                        visibleHand.remove(card);
                      });
                    },
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Game implements Exception {}
