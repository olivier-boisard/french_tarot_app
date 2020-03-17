import '../core/card.dart';
import '../core/decision_maker_wrapper.dart';
import '../decision_maker.dart';
import 'hand.dart';
import 'turn.dart';

class CardPhaseAgent {
  final Hand _hand;
  final DecisionMaker<Card> _decisionMaker;

  CardPhaseAgent(this._decisionMaker, this._hand);

  Decision<Card> play(Turn turn) {
    return _hand.selectCard(wrapDecisionMaker(turn, _decisionMaker));
  }

  bool get handIsEmpty => _hand.isEmpty;
}
