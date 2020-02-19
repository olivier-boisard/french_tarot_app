import 'dart:math';

class RandomBehavior<S, A> {
  final Random _random;

  RandomBehavior() : _random = Random();

  RandomBehavior.withRandom(this._random);

  A run(S state, List<A> possibleActions) {
    return possibleActions[_random.nextInt(possibleActions.length)];
  }
}
