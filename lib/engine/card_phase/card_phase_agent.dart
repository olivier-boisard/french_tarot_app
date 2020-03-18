import '../core/abstract_card.dart';
import '../core/decision_maker_wrapper.dart';
import '../core/environment_state.dart';
import '../decision_maker.dart';
import 'hand.dart';

class CardPhaseAgent {
  final Hand<AbstractCard> _hand;
  final DecisionMaker<AbstractCard> _decisionMaker;

  CardPhaseAgent(this._decisionMaker, this._hand);

  Decision<AbstractCard> play(EnvironmentState<AbstractCard> turn) {
    return _hand.selectCard(wrapDecisionMaker(turn, _decisionMaker));
  }

  bool get handIsEmpty => _hand.isEmpty;
}
