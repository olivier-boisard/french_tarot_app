import '../decision_maker.dart';

class Hand<T> {
  final List<T> _cards;

  Hand(this._cards);

  Decision<T> selectCard(DecisionMaker<T> decisionMaker) {
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
