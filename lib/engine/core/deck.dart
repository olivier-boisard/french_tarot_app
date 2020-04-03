import 'dart:math';

import 'card.dart';

//TODO externalize cards instantiation responsibility
class Deck {
  final List<Card> _cards;
  final Random _random;
  int _originalSize;

  /* _originalSize can't be set in the constructors' initializer list. Hence
  we have to use a getter to make it read-only */
  int get originalSize => _originalSize;

  Deck()
      : _cards = _createCardList(),
        _random = Random() {
    _originalSize = _cards.length;
  }

  Deck.withRandom(this._random) : _cards = _createCardList() {
    _originalSize = _cards.length;
  }

  int get nRemainingCards {
    return _cards.length;
  }

  void shuffle() {
    _cards.shuffle(_random);
  }

  List<Card> pop(int nCards) {
    final output = _cards.getRange(0, nCards).toList();
    _cards.removeRange(0, nCards);
    return output;
  }

  static List<Card> _createCardList() {
    final cards = <Card>[];
    _addRegularCards(cards);
    _addTrumps(cards);
    _addExcuse(cards);
    return cards;
  }

  static void _addExcuse(List<Card> cards) {
    cards.add(const Card.excuse());
  }

  static void _addTrumps(List<Card> cards) {
    const maxTrumpStrength = 21;
    for (var strength = 1; strength <= maxTrumpStrength; strength++) {
      cards.add(Card.trump(strength));
    }
  }

  static void _addRegularCards(List<Card> cards) {
    for (final suit in Card.standardSuits) {
      for (var strength = 1; strength <= CardStrengths.king; strength++) {
        cards.add(Card.coloredCard(suit, strength));
      }
    }
  }
}
