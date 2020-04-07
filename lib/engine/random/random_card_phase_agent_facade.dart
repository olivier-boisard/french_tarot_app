import 'dart:math';

import '../core/suited_playable.dart';
import '../phases/card/card_phase_agent.dart';
import 'random_decision_maker.dart';

class RandomCardPhaseAgentFacade extends CardPhaseAgent {
  RandomCardPhaseAgentFacade(List<SuitedPlayable> hand)
      : super(RandomDecisionMaker<SuitedPlayable>().run, hand);

  RandomCardPhaseAgentFacade.withRandom(
    Random random,
    List<SuitedPlayable> hand,
  ) : super(RandomDecisionMaker<SuitedPlayable>.withRandom(random).run, hand);
}
