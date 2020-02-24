import 'card.dart';
import 'decision.dart';

class CardPhaseAgent {
  final List<Card> _hand;

  CardPhaseAgent(this._hand);

  Decision<Card> act(DecisionMaker<Card> decisionMaker) {
    if (_hand.isEmpty) {
      throw EmptyHandException();
    }
    final action = decisionMaker(_hand);
    _hand.remove(action.action);
    return action;
  }
}

class EmptyHandException implements Exception {}
