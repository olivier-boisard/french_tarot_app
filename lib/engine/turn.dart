import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/exceptions.dart';

class Turn {
  final List<Card> playedCards;

  Turn() : playedCards = List<Card>();

  int get winningCardIndex {
    if (playedCards.isEmpty) {
      throw EmptyTurn();
    }
    int index = 0;
    var strongestCard = playedCards.first;
    for (int i = 1; i < playedCards.length; i++) {
      if (playedCards[i].beats(_askedSuit, strongestCard)) {
        index = i;
        strongestCard = playedCards[i];
      }
    }
    return index;
  }

  bool get _onlyExcuseWasPlayed {
    return playedCards.first == Card.excuse() && playedCards.length == 1;
  }

  Suit get _askedSuit {
    final firstPlayedCard = playedCards.first;
    final asked = firstPlayedCard != Card.excuse()
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

    List<Card> validCards = _extractCardsMatchingAskedSuit(hand);
    if (validCards.isEmpty) {
      final playedTrumps = _extractTrumps(playedCards);
      if (playedTrumps.isNotEmpty) {
        final strongestTrump = _extractStrongestTrump(playedTrumps);
        validCards = _extractTrumps(hand, lowerBound: strongestTrump.strength);
      } else {
        validCards = _extractTrumps(hand);
      }
      if (validCards.isEmpty) {
        return _copyCardList(hand);
      }
    }
    if (_containsExcuse(hand)) {
      validCards.add(Card.excuse());
    }
    return validCards;
  }

  Card _extractStrongestTrump(List<Card> playedTrumps) {
    var strongestTrump = playedTrumps.first;
    for (final trump in playedTrumps.getRange(1, playedTrumps.length)) {
      if (trump.beats(Suit.trump, strongestTrump)) {
        strongestTrump = trump;
      }
    }
    return strongestTrump;
  }

  List<Card> _copyCardList(List<Card> hand) {
    return List<Card>.from(hand);
  }

  List<Card> _extractCardsMatchingAskedSuit(List<Card> hand) {
    return hand.where((card) => card.suit == _askedSuit).toList();
  }

  List<Card> _extractTrumps(List<Card> cards, {int lowerBound = 0}) {
    return cards.where((card) => _filterTrump(card, lowerBound)).toList();
  }

  bool _filterTrump(Card card, int lowerBound) {
    return card.suit == Suit.trump && card.strength > lowerBound;
  }

  bool _containsExcuse(List<Card> hand) {
    return hand.any((card) => card == Card.excuse());
  }

}
