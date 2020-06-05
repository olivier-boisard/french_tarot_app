import 'dart:collection';

import 'package:flutter/material.dart';

import 'app/cards/face_up_card.dart';
import 'app/core/dimensions.dart';
import 'app/french_tarot_app.dart';
import 'app/game_page.dart';
import 'app/played_cards_area.dart';
import 'app/player_area/face_down_player_area.dart';
import 'app/player_area/face_up_player_area.dart';
import 'engine/core/tarot_deck_facade.dart';

//TODO replace List with Iterable everywhere possible in the code

void main() {
  final deck = TarotDeckFacade()..shuffle();
  const nCards = 18;

  final cards = deck.pop(nCards);
  final playedCards = LinkedHashMap<PlayerLocation, Widget>();
  final app = FrenchTarotApp(
    gameWidget: GamePage(
      playerAreas: <Widget>[
        FaceUpPlayerArea(cards: cards),
        FaceDownPlayerArea(nCards: nCards),
        FaceDownPlayerArea(nCards: nCards),
        FaceDownPlayerArea(nCards: nCards),
      ],
      playedCardsArea: PlayedCardsArea(
        playedCards: playedCards,
        cardIsAllowed: (card) => true,
        playCard: (card) {
          playedCards[PlayerLocation.bottom] = FaceUpCard(
            card: card,
            dimensions: Dimensions.fromScreen(),
          );
        },
      ),
    ),
  );

  runApp(app);
}
