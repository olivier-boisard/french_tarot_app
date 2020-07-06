import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../engine/core/abstract_tarot_card.dart';
import '../engine/core/function_interfaces.dart' as interfaces;
import 'cards/face_up_card.dart';
import 'played_cards_area.dart';
import 'player_area/face_down_player_area.dart';
import 'player_area/face_up_player_area.dart';
import 'player_area/screen_sized.dart';

//TODO refactor
class GamePage extends StatefulWidget {
  final List<FaceUpCard> visibleHand;
  final List<FaceUpCard> playedCards;
  final interfaces.Transformer<bool, AbstractTarotCard> isCardAllowed;
  final FaceDownPlayerArea faceDownPlayerArea;

  const GamePage({
    Key key,
    @required this.visibleHand,
    @required this.isCardAllowed,
    @required this.faceDownPlayerArea,
    this.playedCards = const <FaceUpCard>[],
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GamePageState(
      visibleHand: visibleHand,
      playedCards: playedCards,
      isCardAllowed: isCardAllowed,
      faceDownPlayerArea: faceDownPlayerArea,
    );
  }
}

class _GamePageState extends State<GamePage> with ScreenSized {
  final List<FaceUpCard> visibleHand;
  final List<FaceUpCard> playedCards;
  final interfaces.Transformer<bool, AbstractTarotCard> isCardAllowed;
  final FaceDownPlayerArea faceDownPlayerArea;

  _GamePageState({
    @required this.visibleHand,
    @required this.isCardAllowed,
    @required this.faceDownPlayerArea,
    this.playedCards = const <FaceUpCard>[],
  });

  @override
  Widget build(BuildContext context) {
    final playedCards = _createLocationToPlayedCard();

    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(flex: 1, child: faceDownPlayerArea),
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
                    playTarget: DragTarget<AbstractTarotCard>(
                      key: const Key('AbstractTarotCardDragTarget'),
                      onWillAccept: isCardAllowed,
                      onAccept: (card) {
                        setState(() {
                          _onPlayedCardAccept(card, playedCards);
                        });
                      },
                      builder: (context, candidates, rejects) {
                        return candidates.isNotEmpty &&
                                isCardAllowed(candidates.first)
                            ? FaceUpCard(card: candidates.first)
                            : Container();
                      },
                    ),
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
              child: FaceUpPlayerArea(cards: visibleHand),
            ),
          ),
        ],
      ),
    );
  }

  void _onPlayedCardAccept(AbstractTarotCard card, Map<PlayerLocation, Widget> playedCards) {
    final playedCardWidget = FaceUpCard(card: card);
    playedCards[PlayerLocation.bottom] = playedCardWidget;
    final originalHandSize = visibleHand.length;
    visibleHand.removeWhere((element) {
      return element.card == playedCardWidget.card;
    });
    if (originalHandSize == visibleHand.length) {
      throw CardNotFoundInHandException();
    }
  }

  Map<PlayerLocation, Widget> _createLocationToPlayedCard() {
    final playedCardsMappedToLocations = <PlayerLocation, Widget>{};
    final  playerLocations = <PlayerLocation>[
      PlayerLocation.left,
      PlayerLocation.top,
      PlayerLocation.right,
    ];
    for (var i = playedCards.length - 1; i >= 0; i--) {
      playedCardsMappedToLocations[playerLocations[i]] = playedCards[i];
    }
    return playedCardsMappedToLocations;
  }
}

class GamePageException implements Exception {}

class InvalidPlayedCardsNumberException implements GamePageException {}

class CardNotFoundInHandException implements GamePageException {}
