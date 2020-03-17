import 'package:french_tarot/engine/core/turn_consumer.dart';

import 'card_phase_agent.dart';
import 'turn.dart';

//TODO SOLID for this class and the ones it depends on
class Round {

  final TurnConsumer _turnConsumer;

  Round(this._turnConsumer);

  void play(List<CardPhaseAgent> agents) {
    while (!agents[0].handIsEmpty) {
      final turn = Turn();
      for (final agent in agents) {
        final decision = agent.play(turn);
        turn.addPlayedCard(decision.action);
      }
      _turnConsumer(turn, agents);
    }
  }
}
