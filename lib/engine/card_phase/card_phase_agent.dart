import '../core/abstract_card.dart';
import '../core/decision_maker_wrapper.dart';
import '../core/environment_state.dart';
import '../decision_maker.dart';
import 'one_use_action_handler.dart';

class CardPhaseAgent {
  final OneUseActionHandler<AbstractCard> _hand;
  final DecisionMaker<AbstractCard> _decisionMaker;

  CardPhaseAgent(this._decisionMaker, this._hand);

  Decision<AbstractCard> play(State<AbstractCard> turn) {
    return _hand.pickAction(wrapDecisionMaker(turn, _decisionMaker));
  }

  bool get handIsEmpty => _hand.isEmpty;
}
