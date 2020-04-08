import 'dart:math';

import '../core/suited_playable.dart';
import '../phases/card/card_phase_agent.dart';
import 'random_decision_maker.dart';

class RandomCardPhaseAgentFacade<T extends SuitedPlayable>
    extends CardPhaseAgent<T> {
  RandomCardPhaseAgentFacade(List<SuitedPlayable> hand)
      : super(RandomDecisionMaker<T>().run, hand);

  RandomCardPhaseAgentFacade.withRandom(
    Random random,
    List<SuitedPlayable> hand,
  ) : super(RandomDecisionMaker<T>.withRandom(random).run, hand);
}
