import '../core/decision_maker_wrapper.dart';
import '../core/environment_state.dart';
import '../core/suited_playable.dart';
import '../decision_maker.dart';
import 'one_use_action_handler.dart';

class CardPhaseAgent {
  final OneUseActionHandler<SuitedPlayable> _hand;
  final DecisionMaker<SuitedPlayable> _decisionMaker;

  CardPhaseAgent(this._decisionMaker, this._hand);

  Decision<SuitedPlayable> play(State<SuitedPlayable> turn) {
    return _hand.pickAction(wrapDecisionMaker(turn, _decisionMaker));
  }

  bool get handIsEmpty => _hand.isEmpty;
}
