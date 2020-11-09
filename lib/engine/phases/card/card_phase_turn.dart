import '../../core/suited_playable.dart';
import '../../core/suits.dart';
import 'abstract_turn.dart';

class CardPhaseTurn<T extends SuitedPlayable> implements AbstractTurn<T> {
  @override
  final List<T> actionHistory;

  CardPhaseTurn() : actionHistory = <T>[];

  @override
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

  @override
  void addAction(T action) {
    actionHistory.add(action);
  }

  @override
  List<T> extractAllowedActions(List<T> actions) {
    if (!_suitIsDetermined) {
      return _copyList(actions);
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
        return _copyList(actions);
      }
    }
    final cardsWithoutSuit = actions.where((card) => card.suit == Suit.none);
    validCards.addAll(cardsWithoutSuit);
    return validCards;
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

  bool get _suitIsDetermined {
    if (actionHistory.isEmpty) {
      return false;
    }
    return actionHistory.first.suit != Suit.none || actionHistory.length != 1;
  }

  List<T> _extractCardsMatchingAskedSuit(List<T> hand) {
    return hand.where((card) => card.suit == _askedSuit).toList();
  }

  Suit get _askedSuit {
    final firstPlayedCard = actionHistory.first;
    final asked = firstPlayedCard.suit != Suit.none
        ? firstPlayedCard.suit
        : actionHistory[1].suit;
    return asked;
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

  List<T> _copyList(List<T> hand) {
    return hand.toList();
  }

  List<T> _extractTrumps(List<T> cards, {int lowerBound = 0}) {
    return cards.where((card) => _filterTrumps(card, lowerBound)).toList();
  }

  bool _filterTrumps(T card, int lowerBound) {
    return card.suit == Suit.trump && card.strength > lowerBound;
  }
}

class EmptyTurn implements Exception {}
