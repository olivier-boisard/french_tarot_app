import 'package:flutter/material.dart';

import 'app/french_tarot_app.dart';
import 'app/game_page.dart';
import 'engine/core/card.dart' as engine;
import 'engine/core/tarot_deck_facade.dart';

void main() {
  final cards = <engine.Card>[];
  final deck = TarotDeckFacade()..shuffle();
  for (final card in deck.pop(18)) {
    cards.add(card as engine.Card);
  }
  final app = FrenchTarotApp(
    gameWidget: GamePage(cards),
  );

  runApp(app);
}
