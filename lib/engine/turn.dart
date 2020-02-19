import 'card.dart';

class Turn {
  final List<Card> playedCards;

  Turn() : playedCards = <Card>[];

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

  bool get _onlyExcuseWasPlayed {
    return playedCards.first == const Card.excuse() && playedCards.length == 1;
  }

  Suit get _askedSuit {
    final firstPlayedCard = playedCards.first;
    final asked = firstPlayedCard != const Card.excuse()
        ? firstPlayedCard.suit
        : playedCards[1].suit;
    return asked;
  }

  void addPlayedCard(Card card) {
    playedCards.add(card);
  }

  List<Card> extractAllowedCards(List<Card> hand) {
    if (playedCards.isEmpty) {
      return _copyCardList(hand);
    }

    if (_onlyExcuseWasPlayed) {
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
    if (_containsExcuse(hand)) {
      validCards.add(const Card.excuse());
    }
    return validCards;
  }

  List<Card> _extractCardsMatchingAskedSuit(List<Card> hand) {
    return hand.where((card) => card.suit == _askedSuit).toList();
  }

  static Card _extractStrongestTrump(List<Card> playedTrumps) {
    var strongestTrump = playedTrumps.first;
    for (final trump in playedTrumps.getRange(1, playedTrumps.length)) {
      if (trump.beats(Suit.trump, strongestTrump)) {
        strongestTrump = trump;
      }
    }
    return strongestTrump;
  }

  static List<Card> _copyCardList(List<Card> hand) {
    return hand.toList();
  }

  static List<Card> _extractTrumps(List<Card> cards, {int lowerBound = 0}) {
    return cards.where((card) => _filterTrumps(card, lowerBound)).toList();
  }

  static bool _filterTrumps(Card card, int lowerBound) {
    return card.suit == Suit.trump && card.strength > lowerBound;
  }

  static bool _containsExcuse(List<Card> hand) {
    return hand.any((card) => card == const Card.excuse());
  }
}

class EmptyTurn implements Exception {}
