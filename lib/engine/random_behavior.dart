import 'dart:math';

import 'card.dart';

class RandomBehavior {
  final Random _random;

  RandomBehavior() : _random = Random();

  RandomBehavior.withRandom(this._random);

  Card run(List<Card> allowedCards) {
    return allowedCards[_random.nextInt(allowedCards.length)];
  }
}

