import '../../core/abstract_card.dart';
import '../../core/abstract_card_phase_agent.dart';
import '../../core/action_per_agent_processor.dart';
import '../../core/function_interfaces.dart';
import '../../core/playable_score_element.dart';
import 'abstract_turn.dart';

class CardPhase {
  final ActionPerAgentProcessor<PlayableScoreElement> _actionPerAgentProcessor;
  final Factory<AbstractTurn<AbstractCard>> _abstractTurnFactory;
  final List<AbstractCardPhaseAgent> _agents;

  CardPhase(
    this._abstractTurnFactory,
    this._actionPerAgentProcessor,
    this._agents,
  );

  void run() {
    while (_agents[0].isReady) {
      final turn = _abstractTurnFactory();
      for (final agent in _agents) {
        final decision = agent.play(turn);
        turn.addAction(decision.action);
      }
      _actionPerAgentProcessor(turn, _agents);
    }
  }
}
