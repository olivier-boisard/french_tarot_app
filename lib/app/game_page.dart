import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../engine/core/abstract_tarot_card.dart';
import '../engine/core/function_interfaces.dart';
import 'cards/face_up_card.dart';
import 'played_cards_area.dart';
import 'player_area/face_down_player_area.dart';
import 'player_area/face_up_player_area.dart';
import 'player_area/screen_sized.dart';

const topFaceDownAreaKey = Key('TopFaceDownArea');
const leftFaceDownArea = Key('LeftFaceDownArea');
const rightFaceDownAreaKey = Key('RightFaceDownArea');

class GamePage extends StatefulWidget {
  final List<FaceUpCard> visibleHand;
  final List<FaceUpCard> playedCards;
  final Transformer<bool, AbstractTarotCard> isCardAllowed;

  const GamePage({
    Key key,
    @required this.visibleHand,
    @required this.isCardAllowed,
    this.playedCards = const <FaceUpCard>[],
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GamePageState(
      visibleHand: visibleHand,
      playedCards: playedCards,
      isCardAllowed: isCardAllowed,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Transformer<bool, AbstractTarotCard>>.has(
      'isCardAllowed',
      isCardAllowed,
    ));
  }
}

class _GamePageState extends State<GamePage> with ScreenSized {
  final List<FaceUpCard> visibleHand;
  final List<FaceUpCard> playedCards;
  final Transformer<bool, AbstractTarotCard> isCardAllowed;

  static final List<PlayerLocation> _playerLocations = [
    PlayerLocation.left,
    PlayerLocation.top,
    PlayerLocation.right,
  ];

  _GamePageState({
    @required this.visibleHand,
    @required this.playedCards,
    @required this.isCardAllowed,
  }) {
    if (playedCards.length > _playerLocations.length) {
      throw InvalidPlayedCardsNumberException();
    }
  }

  @override
  Widget build(BuildContext context) {
    final playedCards = _createLocationToPlayedCard();

    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FaceDownPlayerArea(
              nCards: visibleHand.length,
              key: topFaceDownAreaKey,
            ),
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
                      child: FaceDownPlayerArea(
                        nCards: visibleHand.length,
                        key: leftFaceDownArea,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: PlayedCardsArea(
                    playedCards: playedCards,
                    cardIsAllowed: isCardAllowed,
                    playCard: (card) {
                      setState(() {
                        final playedCardWidget = FaceUpCard(card: card);
                        playedCards[PlayerLocation.bottom] = playedCardWidget;
                        final originalHandSize = visibleHand.length;
                        visibleHand.removeWhere((element) {
                          return element.card == playedCardWidget.card;
                        });
                        if (originalHandSize == visibleHand.length) {
                          throw CardNotFoundInHandException();
                        }
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
                      child: FaceDownPlayerArea(
                        nCards: visibleHand.length,
                        key: rightFaceDownAreaKey,
                      ),
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Transformer<bool, AbstractTarotCard>>.has(
      'isCardAllowed',
      isCardAllowed,
    ));
  }
}

class GamePageException implements Exception {}

class InvalidPlayedCardsNumberException implements GamePageException {}

class CardNotFoundInHandException implements GamePageException {}
