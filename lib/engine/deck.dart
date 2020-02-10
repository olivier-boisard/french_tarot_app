import 'dart:math';

import 'package:french_tarot/engine/card.dart';

class Deck {
  final List<Card> cards; //TODO make private
  final Random _random;

  Deck()
      : cards = _createCardList(),
        _random = Random();

  Deck.withRandom(this._random) : cards = _createCardList();

  void shuffle() {
    cards.shuffle(_random);
  }

  List<Card> pop(int nCards) {
    final output = List<Card>.from(cards.getRange(0, nCards));
    cards.removeRange(0, nCards);
    return output;
  }

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

}
