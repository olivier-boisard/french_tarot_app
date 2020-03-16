import '../core/card.dart';
import '../core/decision_maker_wrapper.dart';
import '../decision_maker.dart';
import '../random_decision_maker.dart';
import 'hand.dart';
import 'turn.dart';

class RandomCardPhaseAgent {
  final RandomDecisionMaker<Card> _decisionMaker;
  final Hand _hand;

  RandomCardPhaseAgent(this._hand) : _decisionMaker = RandomDecisionMaker();

  Decision<Card> play(Turn turn) {
    return _hand.selectCard(wrapDecisionMaker(turn, _decisionMaker.run));
  }
}
