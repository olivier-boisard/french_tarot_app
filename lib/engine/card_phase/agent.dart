import '../agent.dart';
import '../core/card.dart';

class CardPhaseAgent {
  final List<Card> _hand;

  CardPhaseAgent(this._hand);

  Decision<Card> act(DecisionMaker<Card> decisionMaker) {
    if (_hand.isEmpty) {
      throw EmptyHandException();
    }
    final decision = decisionMaker(_hand);
    _hand.remove(decision.action);
    return decision;
  }
}

class EmptyHandException implements Exception {}
