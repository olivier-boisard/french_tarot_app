import 'behavior.dart';
import 'card.dart';

typedef DecisionMaker<A> = Action<A> Function(List<A> possibleActions);

class CardPhaseAgent {
  final List<Card> _hand;

  CardPhaseAgent(this._hand);

  Action<Card> act(DecisionMaker<Card> decisionMaker) {
    if (_hand.isEmpty) {
      throw EmptyHandException();
    }
    final action = decisionMaker(_hand);
    _hand.remove(action.value);
    return action;
  }
}

class EmptyHandException implements Exception {}
