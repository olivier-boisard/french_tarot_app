import '../core/card.dart';
import '../decision_maker.dart';

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

  bool get isEmpty => _cards.isEmpty;
}

class EmptyHandException implements Exception {}
