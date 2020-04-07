import 'dart:math';

import 'abstract_card.dart';
import 'card.dart';
import 'deck.dart';

class TarotDeckFacade extends Deck<AbstractCard> {
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
    cards.add(const Card.excuse());
  }

  static void _addTrumps(List<AbstractCard> cards) {
    const maxTrumpStrength = 21;
    for (var strength = 1; strength <= maxTrumpStrength; strength++) {
      cards.add(Card.trump(strength));
    }
  }

  static void _addRegularCards(List<AbstractCard> cards) {
    for (final suit in Card.standardSuits) {
      for (var strength = 1; strength <= CardStrengths.king; strength++) {
        cards.add(Card.coloredCard(suit, strength));
      }
    }
  }
}
