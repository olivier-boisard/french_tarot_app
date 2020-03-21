import '../core/abstract_card.dart';
import '../core/action_per_agent_processor.dart';
import 'abstract_turn.dart';
import 'card_phase_agent.dart';
import 'playable_score_element.dart';

class Round {
  final ActionPerAgentProcessor<PlayableScoreElement> _processor;
  final AbstractTurnFactory<AbstractCard> _abstractTurnFactory;

  Round(this._abstractTurnFactory, this._processor);

  void play(List<CardPhaseAgent> agents) {
    while (!agents[0].handIsEmpty) {
      final turn = _abstractTurnFactory();
      for (final agent in agents) {
        final decision = agent.play(turn);
        turn.addAction(decision.action);
      }
      _processor(turn, agents);
    }
  }
}
