import 'dart:math';

import 'package:french_tarot/engine/card.dart';

class Deck {
  final Random random;

  final List<Card> cards;

  Deck()
      : random = Random(),
        cards = _createCardList();

  Deck.withRandom(this.random) : cards = _createCardList();

  static List<Card> _createCardList() {
    final cards = List<Card>();
    _addRegularCards(cards);
    _addTrumps(cards);
    _addExcuse(cards);
    return cards;
  }

  static void _addExcuse(List<Card> cards) {
    cards.add(Card.excuse());
  }

  static void _addTrumps(List<Card> cards) {
    final maxTrumpStrength = 21;
    for (var strength = 1; strength <= maxTrumpStrength; strength++) {
      cards.add(Card.trump(strength));
    }
  }

  static void _addRegularCards(List<Card> cards) {
    for (final suit in Card.standardSuits) {
      for (var strength = 1; strength <= CardStrengths.KING; strength++) {
        cards.add(Card.coloredCard(suit, strength));
      }
    }
  }

  void shuffle() {
    cards.shuffle(random);
  }
}
