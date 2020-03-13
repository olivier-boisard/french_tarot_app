import 'dart:math';

import 'agent.dart';

class RandomBehavior<A> {
  final Random _random;

  RandomBehavior() : _random = Random();

  RandomBehavior.withRandom(this._random);

  Decision<A> run(List<A> allowedActions) {
    final probability = 1.0 / allowedActions.length;
    final value = allowedActions[_random.nextInt(allowedActions.length)];
    return Decision(probability, value);
  }
}
