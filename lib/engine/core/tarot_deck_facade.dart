import 'dart:math';

import 'abstract_card.dart';
import 'abstract_tarot_card.dart';
import 'deck.dart';
import 'tarot_card.dart';

class TarotDeckFacade extends Deck<AbstractTarotCard> {
  TarotDeckFacade() : super(_createCardList());

  TarotDeckFacade.withRandom(Random random)
      : super.withRandom(_createCardList(), random);

  static List<AbstractCard> _createCardList() {
    final cards = <AbstractCard>[];
    _addRegularCards(cards);
    _addTrumps(cards);
    _addExcuse(cards);
    return cards;
  }

  static void _addExcuse(List<AbstractCard> cards) {
    cards.add(const TarotCard.excuse());
  }

  static void _addTrumps(List<AbstractCard> cards) {
    const maxTrumpStrength = 21;
    for (var strength = 1; strength <= maxTrumpStrength; strength++) {
      cards.add(TarotCard.trump(strength));
    }
  }

  static void _addRegularCards(List<AbstractCard> cards) {
    for (final suit in TarotCard.standardSuits) {
      for (var strength = 1; strength <= CardStrengths.king; strength++) {
        cards.add(TarotCard.coloredCard(suit, strength));
      }
    }
  }
}
