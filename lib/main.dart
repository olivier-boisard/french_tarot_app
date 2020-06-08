import 'package:flutter/material.dart';

import 'app/french_tarot_app.dart';
import 'app/game_page.dart';
import 'engine/core/tarot_deck_facade.dart';

//TODO replace List with Iterable everywhere possible in the code

void main() {
  final deck = TarotDeckFacade()..shuffle();
  const nCards = 18;

  final cards = deck.pop(nCards);
  final app = FrenchTarotApp(
    gameWidget: GamePage(
      visibleHand: cards,
    ),
  );

  runApp(app);
}
