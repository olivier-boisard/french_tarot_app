import '../core/abstract_score_element.dart';
import '../core/card.dart';
import '../core/turn_consumer.dart';
import 'abstract_turn.dart';
import 'card_phase_agent.dart';
import 'turn.dart';

//TODO SOLID for this class and the ones it depends on
class Round {
  final TurnConsumer<ScoreElement> _turnConsumer;

  Round(this._turnConsumer);

  void play(List<CardPhaseAgent> agents) {
    while (!agents[0].handIsEmpty) {
      //TODO depend on AbstractTurn
      //TODO depend on an abstraction of Card
      final AbstractTurn<Card> turn = Turn();
      for (final agent in agents) {
        final decision = agent.play(turn);
        turn.addAction(decision.action);
      }
      _turnConsumer(turn, agents);
    }
  }
}
