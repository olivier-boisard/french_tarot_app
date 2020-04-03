import '../../core/abstract_card_phase_agent.dart';
import '../../core/decision.dart';
import '../../core/environment_state.dart';
import '../../core/one_use_action_handler.dart';
import '../../core/selector.dart';
import '../../core/selector_wrapper.dart';
import '../../core/suited_playable.dart';

//TODO break dependency to OneUseActionHandler
class CardPhaseAgent implements AbstractCardPhaseAgent {
  final OneUseActionHandler<SuitedPlayable> _hand;
  final Selector<SuitedPlayable> _decisionMaker;

  CardPhaseAgent(this._decisionMaker, this._hand);

  @override
  Decision<SuitedPlayable> play(State<SuitedPlayable> turn) {
    return _hand.pickAction(wrapSelector(turn, _decisionMaker));
  }

  @override
  bool get isReady => _hand.isEmpty;
}
