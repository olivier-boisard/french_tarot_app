import 'dart:math';

import '../core/decision.dart';

class RandomDecisionMaker<T> {
  final Random _random;

  RandomDecisionMaker() : _random = Random();

  RandomDecisionMaker.withRandom(this._random);

  Decision<T> run(List<T> allowedActions) {
    final probability = 1.0 / allowedActions.length;
    final value = allowedActions[_random.nextInt(allowedActions.length)];
    return Decision(probability, value);
  }
}
