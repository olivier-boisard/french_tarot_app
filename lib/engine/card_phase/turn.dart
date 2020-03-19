import '../core/abstract_card.dart';
import '../core/environment_state.dart';
import 'abstract_turn.dart';

class Turn
    implements EnvironmentState<AbstractCard>, AbstractTurn<AbstractCard> {
  @override
  final List<AbstractCard> playedCards;

  Turn() : playedCards = <AbstractCard>[];

  int get winningCardIndex {
    if (playedCards.isEmpty) {
      throw EmptyTurn();
    }
    var index = 0;
    var strongestCard = playedCards.first;
    for (var i = 1; i < playedCards.length; i++) {
      if (playedCards[i].beats(_askedSuit, strongestCard)) {
        index = i;
        strongestCard = playedCards[i];
      }
    }
    return index;
  }

  bool get _suitIsDetermined {
    if (playedCards.isEmpty) {
      return false;
    }
    return playedCards.first.suit != Suit.none || playedCards.length != 1;
  }

  Suit get _askedSuit {
    final firstPlayedCard = playedCards.first;
    final asked = firstPlayedCard.suit != Suit.none
        ? firstPlayedCard.suit
        : playedCards[1].suit;
    return asked;
  }

  void addPlayedCard(AbstractCard card) {
    playedCards.add(card);
  }

  @override
  List<AbstractCard> extractAllowedActions(List<AbstractCard> hand) {
    if (!_suitIsDetermined) {
      return _copyCardList(hand);
    }

    var validCards = _extractCardsMatchingAskedSuit(hand);
    if (validCards.isEmpty) {
      final playedTrumps = _extractTrumps(playedCards);
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

  List<AbstractCard> _extractCardsMatchingAskedSuit(List<AbstractCard> hand) {
    return hand.where((card) => card.suit == _askedSuit).toList();
  }

  static AbstractCard _extractStrongestTrump(List<AbstractCard> playedTrumps) {
    var strongestTrump = playedTrumps.first;
    for (final trump in playedTrumps.getRange(1, playedTrumps.length)) {
      if (trump.beats(Suit.trump, strongestTrump)) {
        strongestTrump = trump;
      }
    }
    return strongestTrump;
  }

  static List<AbstractCard> _copyCardList(List<AbstractCard> hand) {
    return hand.toList();
  }

  static List<AbstractCard> _extractTrumps(List<AbstractCard> cards, {int lowerBound = 0}) {
    return cards.where((card) => _filterTrumps(card, lowerBound)).toList();
  }

  static bool _filterTrumps(AbstractCard card, int lowerBound) {
    return card.suit == Suit.trump && card.strength > lowerBound;
  }

  @override
  AbstractCard extractGreedyAction(List<AbstractCard> actions) {
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
