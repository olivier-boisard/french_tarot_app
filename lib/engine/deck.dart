import 'dart:math';

class Deck {
  final Random random;

  Deck() : random = Random();

  Deck.withRandom(this.random);
}
