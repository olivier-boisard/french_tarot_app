import 'package:flutter/material.dart';

import 'app/cards/face_down_card.dart';
import 'app/cards/face_up_card.dart';
import 'app/french_tarot_app.dart';
import 'app/game_page.dart';
import 'app/player_area.dart';
import 'engine/core/card.dart' as engine;
import 'engine/core/tarot_deck_facade.dart';

void main() {
  final visibleCards = <FaceUpCard>[];
  final deck = TarotDeckFacade()..shuffle();
  for (final card in deck.pop(18)) {
    visibleCards.add(FaceUpCard(card: card as engine.Card));
  }

  final faceDownCards = <FaceDownCard>[];
  const nCards = 18;
  for (var i = 0; i < nCards; i++) {
    faceDownCards.add(FaceDownCard());
  }

  final app = FrenchTarotApp(
    gameWidget: GamePage(
      playerAreas: <Widget>[
        PlayerArea(cards: visibleCards),
        PlayerArea(cards: faceDownCards),
        PlayerArea(cards: faceDownCards),
        PlayerArea(cards: faceDownCards),
      ],
    ),
  );

  runApp(app);
}
