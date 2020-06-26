import 'dart:math';

import 'abstract_tarot_card.dart';
import 'deck.dart';
import 'suits.dart';
import 'tarot_card.dart';

class TarotDeckFacade extends Deck<AbstractTarotCard> {
  TarotDeckFacade() : super(_createCardList());

  TarotDeckFacade.withRandom(Random random)
      : super.withRandom(_createCardList(), random);

  static List<AbstractTarotCard> _createCardList() {
    final cards = <AbstractTarotCard>[];
    _addRegularCards(cards);
    _addTrumps(cards);
    _addExcuse(cards);
    return cards;
  }

  static void _addExcuse(List<AbstractTarotCard> cards) {
    cards.add(const TarotCard.excuse());
  }

  static void _addTrumps(List<AbstractTarotCard> cards) {
    const maxTrumpStrength = 21;
    for (var strength = 1; strength <= maxTrumpStrength; strength++) {
      cards.add(TarotCard.trump(strength));
    }
  }

  static void _addRegularCards(List<AbstractTarotCard> cards) {
    for (final suit in standardSuits) {
      for (var strength = 1; strength <= CardStrengths.king; strength++) {
        cards.add(TarotCard.coloredCard(suit, strength));
      }
    }
  }
}
