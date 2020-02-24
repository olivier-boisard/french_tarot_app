import 'dart:math';

import 'behavior.dart';

class RandomBehavior<A> {
  final Random _random;

  RandomBehavior() : _random = Random();

  RandomBehavior.withRandom(this._random);

  Decision<A> run(List<A> actions) {
    final allowedActions = actions;
    final probability = 1.0 / actions.length;
    final value = allowedActions[_random.nextInt(actions.length)];
    return Decision(probability, value);
  }
}
