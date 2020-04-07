import 'dart:math';

class Deck<T> {
  final List<T> _cards;
  final Random _random;
  int _originalSize;

  Deck(this._cards) : _random = Random() {
    _originalSize = _cards.length;
  }

  Deck.withRandom(this._cards, this._random) {
    _originalSize = _cards.length;
  }

  /* _originalSize can't be set in the constructors' initializer list. Hence
  we have to use a getter to make it read-only */
  int get originalSize => _originalSize;

  int get nRemainingCards {
    return _cards.length;
  }

  void shuffle() {
    _cards.shuffle(_random);
  }

  List<T> pop(int nCards) {
    final output = _cards.getRange(0, nCards).toList();
    _cards.removeRange(0, nCards);
    return output;
  }
}
