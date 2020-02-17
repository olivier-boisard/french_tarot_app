import 'dart:math';

import 'card.dart';
import 'player.dart';
import 'turn.dart';

class RandomPlayer extends Player {
  final Random _random;

  RandomPlayer() : _random = Random();

  RandomPlayer.withRandom(this._random);

  @override
  Card play(Turn turn) {
    return null;
  }
}
