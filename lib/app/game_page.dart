import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'cards/face_up_card.dart';
import 'played_cards_area.dart';
import 'player_area/face_down_player_area.dart';
import 'player_area/face_up_player_area.dart';
import 'player_area/screen_sized.dart';

class GamePage extends StatefulWidget {
  final List<FaceUpCard> visibleHand;
  final List<FaceUpCard> playedCards;

  const GamePage({
    Key key,
    @required this.visibleHand,
    this.playedCards = const <FaceUpCard>[],
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
  final List<FaceUpCard> visibleHand;
  final List<FaceUpCard> playedCards;
  static final List<PlayerLocation> _playerLocations = [
    PlayerLocation.left,
    PlayerLocation.top,
    PlayerLocation.right,
  ];

  _GamePageState({@required this.visibleHand, @required this.playedCards}) {
    if (playedCards.length > _playerLocations.length) {
      throw InvalidPlayedCardsNumberException();
    }
  }

  @override
  Widget build(BuildContext context) {
    final faceDownPlayerArea = FaceDownPlayerArea(nCards: visibleHand.length);
    final locatedPlayedCard = _createLocationToPlayedCard();

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
                    playedCards: locatedPlayedCard,
                    cardIsAllowed: (card) => true,
                    playCard: (card) {
                      setState(() {
                        locatedPlayedCard[PlayerLocation.bottom] = FaceUpCard(
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

  Map<PlayerLocation, Widget> _createLocationToPlayedCard() {
    final playedCardsMappedToLocations = <PlayerLocation, Widget>{};
    for (var i = playedCards.length - 1; i >= 0; i--) {
      playedCardsMappedToLocations[_playerLocations[i]] = playedCards[i];
    }
    return playedCardsMappedToLocations;
  }
}

class GamePageException implements Exception {}

class InvalidPlayedCardsNumberException implements GamePageException {}
