import 'package:french_tarot/engine/core/abstract_card_phase_agent.dart';

import '../core/abstract_card.dart';
import '../core/action_per_agent_processor.dart';
import 'abstract_turn.dart';
import 'card_phase_agent.dart';
import 'playable_score_element.dart';

class Round {
  final ActionPerAgentProcessor<PlayableScoreElement> _actionPerAgentProcessor;
  final AbstractTurnFactory<AbstractCard> _abstractTurnFactory;

  Round(this._abstractTurnFactory, this._actionPerAgentProcessor);

  void play(List<AbstractCardPhaseAgent> agents) {
    while (!agents[0].isReady) {
      final turn = _abstractTurnFactory();
      for (final agent in agents) {
        final decision = agent.play(turn);
        turn.addAction(decision.action);
      }
      _actionPerAgentProcessor(turn, agents);
    }
  }
}
