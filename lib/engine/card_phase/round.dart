import '../core/abstract_card.dart';
import '../core/abstract_score_element.dart';
import '../core/action_per_agent_processor.dart';
import 'abstract_turn.dart';
import 'card_phase_agent.dart';
import 'turn.dart';

//TODO SOLID for this class and the ones it depends on
class Round {
  final ActionPerAgentProcessor<ScoreElement> _processor;

  Round(this._processor);

  void play(List<CardPhaseAgent> agents) {
    while (!agents[0].handIsEmpty) {
      //TODO depend on AbstractTurn
      final AbstractTurn<AbstractCard> turn = Turn();
      for (final agent in agents) {
        final decision = agent.play(turn);
        turn.addAction(decision.action);
      }
      _processor(turn, agents);
    }
  }
}
