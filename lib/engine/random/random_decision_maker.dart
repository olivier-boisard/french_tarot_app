import 'dart:math';

import '../core/decision_maker.dart';

class RandomDecisionMaker<A> {
  final Random _random;

  RandomDecisionMaker() : _random = Random();

  RandomDecisionMaker.withRandom(this._random);

  Decision<A> run(List<A> allowedActions) {
    final probability = 1.0 / allowedActions.length;
    final value = allowedActions[_random.nextInt(allowedActions.length)];
    return Decision(probability, value);
  }
}
