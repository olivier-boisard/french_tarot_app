import '../core/abstract_card.dart';
import 'abstract_turn.dart';

class Turn<T extends AbstractCard> implements AbstractTurn<T> {
  @override
  final List<T> actionHistory;

  Turn() : actionHistory = <T>[];

  int get winningActionIndex {
    if (actionHistory.isEmpty) {
      throw EmptyTurn();
    }
    var index = 0;
    var strongestCard = actionHistory.first;
    for (var i = 1; i < actionHistory.length; i++) {
      if (actionHistory[i].beats(_askedSuit, strongestCard)) {
        index = i;
        strongestCard = actionHistory[i];
      }
    }
    return index;
  }

  bool get _suitIsDetermined {
    if (actionHistory.isEmpty) {
      return false;
    }
    return actionHistory.first.suit != Suit.none || actionHistory.length != 1;
  }

  Suit get _askedSuit {
    final firstPlayedCard = actionHistory.first;
    final asked = firstPlayedCard.suit != Suit.none
        ? firstPlayedCard.suit
        : actionHistory[1].suit;
    return asked;
  }

  @override
  void addAction(T action) {
    actionHistory.add(action);
  }

  @override
  List<T> extractAllowedActions(List<T> actions) {
    if (!_suitIsDetermined) {
      return _copyCardList(actions);
    }

    var validCards = _extractCardsMatchingAskedSuit(actions);
    if (validCards.isEmpty) {
      final playedTrumps = _extractTrumps(actionHistory);
      if (playedTrumps.isNotEmpty) {
        final strongestTrump = _extractStrongestTrump(playedTrumps);
        validCards =
            _extractTrumps(actions, lowerBound: strongestTrump.strength);
        if (validCards.isEmpty) {
          validCards = _extractTrumps(actions);
        }
      } else {
        validCards = _extractTrumps(actions);
      }
      if (validCards.isEmpty) {
        return _copyCardList(actions);
      }
    }
    final cardsWithoutSuit = actions.where((card) => card.suit == Suit.none);
    validCards.addAll(cardsWithoutSuit);
    return validCards;
  }

  List<T> _extractCardsMatchingAskedSuit(List<T> hand) {
    return hand.where((card) => card.suit == _askedSuit).toList();
  }

  T _extractStrongestTrump(List<T> playedTrumps) {
    var strongestTrump = playedTrumps.first;
    for (final trump in playedTrumps.getRange(1, playedTrumps.length)) {
      if (trump.beats(Suit.trump, strongestTrump)) {
        strongestTrump = trump;
      }
    }
    return strongestTrump;
  }

  List<T> _copyCardList(List<T> hand) {
    return hand.toList();
  }

  List<T> _extractTrumps(List<T> cards, {int lowerBound = 0}) {
    return cards.where((card) => _filterTrumps(card, lowerBound)).toList();
  }

  bool _filterTrumps(T card, int lowerBound) {
    return card.suit == Suit.trump && card.strength > lowerBound;
  }

  @override
  T extractGreedyAction(List<T> actions) {
    // TODO: implement extractGreedyAction
    throw UnimplementedError();
  }

  @override
  List<double> get featureVector {
    // TODO: implement featureVector
    throw UnimplementedError();
  }
}

class EmptyTurn implements Exception {}
