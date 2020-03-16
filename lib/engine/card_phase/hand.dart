import '../agent.dart';
import '../core/card.dart';

class Hand {
  final List<Card> _cards;

  Hand(this._cards);

  Decision<Card> selectCard(DecisionMaker<Card> decisionMaker) {
    if (_cards.isEmpty) {
      throw EmptyHandException();
    }
    final decision = decisionMaker(_cards);
    _cards.remove(decision.action);
    return decision;
  }
}

class EmptyHandException implements Exception {}
