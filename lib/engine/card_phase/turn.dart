import '../core/abstract_card.dart';
import 'abstract_turn.dart';

class Turn<T extends AbstractCard> implements AbstractTurn<T> {
  @override
  final List<T> actions;

  Turn() : actions = <T>[];

  int get winningActionIndex {
    if (actions.isEmpty) {
      throw EmptyTurn();
    }
    var index = 0;
    var strongestCard = actions.first;
    for (var i = 1; i < actions.length; i++) {
      if (actions[i].beats(_askedSuit, strongestCard)) {
        index = i;
        strongestCard = actions[i];
      }
    }
    return index;
  }

  bool get _suitIsDetermined {
    if (actions.isEmpty) {
      return false;
    }
    return actions.first.suit != Suit.none || actions.length != 1;
  }

  Suit get _askedSuit {
    final firstPlayedCard = actions.first;
    final asked = firstPlayedCard.suit != Suit.none
        ? firstPlayedCard.suit
        : actions[1].suit;
    return asked;
  }

  @override
  void addAction(T action) {
    actions.add(action);
  }

  @override
  List<T> extractAllowedActions(List<T> hand) {
    if (!_suitIsDetermined) {
      return _copyCardList(hand);
    }

    var validCards = _extractCardsMatchingAskedSuit(hand);
    if (validCards.isEmpty) {
      final playedTrumps = _extractTrumps(actions);
      if (playedTrumps.isNotEmpty) {
        final strongestTrump = _extractStrongestTrump(playedTrumps);
        validCards = _extractTrumps(hand, lowerBound: strongestTrump.strength);
        if (validCards.isEmpty) {
          validCards = _extractTrumps(hand);
        }
      } else {
        validCards = _extractTrumps(hand);
      }
      if (validCards.isEmpty) {
        return _copyCardList(hand);
      }
    }
    final cardsWithoutSuit = validCards.where((card) => card.suit == Suit.none);
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
