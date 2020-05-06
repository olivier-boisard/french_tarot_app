import 'package:flutter/material.dart';

import 'app/cards/face_down_card.dart';
import 'app/cards/face_up_card.dart';
import 'app/core/dimensions.dart';
import 'app/french_tarot_app.dart';
import 'app/game_page.dart';
import 'app/player_area.dart';
import 'engine/core/abstract_tarot_card.dart';
import 'engine/core/tarot_deck_facade.dart';

void main() {
  final visibleCards = <Draggable<AbstractTarotCard>>[];
  final deck = TarotDeckFacade()..shuffle();
  final cardDimensions = Dimensions.fromScreen();
  for (final card in deck.pop(18)) {
    final faceUpCard = FaceUpCard(
      card: card,
      dimensions: cardDimensions,
    );

    visibleCards.add(
        Draggable<AbstractTarotCard>(
          data: card,
          feedback: faceUpCard,
          child: faceUpCard,
        )
    );
  }

  final faceDownCards = <FaceDownCard>[];
  const nCards = 18;
  for (var i = 0; i < nCards; i++) {
    faceDownCards.add(FaceDownCard(dimensions: cardDimensions));
  }

  final app = FrenchTarotApp(
    gameWidget: GamePage(
      playerAreas: <Widget>[
        PlayerArea(cards: visibleCards),
        PlayerArea(cards: faceDownCards),
        PlayerArea(cards: faceDownCards),
        PlayerArea(cards: faceDownCards),
      ],
      playedCardsArea: Container(),
    ),
  );

  runApp(app);
}
