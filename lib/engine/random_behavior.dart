import 'dart:math';

import 'package:french_tarot/engine/state.dart';

class RandomBehavior<S, A> {
  final Random _random;

  RandomBehavior() : _random = Random();

  RandomBehavior.withRandom(this._random);

  A run(State state) {
    final allowedActions = state.allowedActions;
    return allowedActions[_random.nextInt(allowedActions.length)];
  }
}
