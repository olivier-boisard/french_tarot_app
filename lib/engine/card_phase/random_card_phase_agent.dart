import 'package:french_tarot/engine/card_phase/hand.dart';
import 'package:french_tarot/engine/card_phase/turn.dart';
import 'package:french_tarot/engine/core/card.dart';
import 'package:french_tarot/engine/core/decision_maker_wrapper.dart';
import 'package:french_tarot/engine/decision_maker.dart';
import 'package:french_tarot/engine/random_decision_maker.dart';

class RandomCardPhaseAgent {
  final RandomDecisionMaker<Card> _decisionMaker;
  final Hand _hand;

  RandomCardPhaseAgent(this._hand) : _decisionMaker = RandomDecisionMaker();

  Decision<Card> play(Turn turn) {
    return _hand.selectCard(wrapDecisionMaker(turn, _decisionMaker.run));
  }
}
