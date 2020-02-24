import 'dart:math';

import 'behavior.dart';

class RandomBehavior<A> {
  final Random _random;

  RandomBehavior() : _random = Random();

  RandomBehavior.withRandom(this._random);

  Action<A> run(State<A> state) {
    final allowedActions = state.allowedActions;
    final probability = 1.0 / state.allowedActions.length;
    final value = allowedActions[_random.nextInt(allowedActions.length)];
    return Action(probability, value);
  }
}