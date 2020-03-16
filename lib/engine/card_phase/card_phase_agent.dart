import '../core/card.dart';
import '../core/decision_maker_wrapper.dart';
import '../decision_maker.dart';
import 'hand.dart';
import 'turn.dart';

class CardPhaseAgent {
  final DecisionMaker<Card> _decisionMaker;
  final Hand _hand;

  CardPhaseAgent(this._hand, this._decisionMaker);

  Decision<Card> play(Turn turn) {
    return _hand.selectCard(wrapDecisionMaker(turn, _decisionMaker));
  }
}
