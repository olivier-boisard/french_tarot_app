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
      validCards = _extractTrumps(hand);
      if (validCards.isEmpty) {
        return _copyCardList(hand);
      }
    }
    if (_containsExcuse(hand)) {
      validCards.add(Card.excuse());
    }
    return validCards;
  }

  List<Card> _copyCardList(List<Card> hand) {
    return List<Card>.from(hand);
  }

  List<Card> _extractCardsMatchingAskedSuit(List<Card> hand) {
    var validCards = hand.where((card) => card.suit == _askedSuit).toList();
    return validCards;
  }

  List<Card> _extractTrumps(List<Card> hand) {
    return hand.where((card) => card.suit == Suit.trump).toList();
  }

  bool _containsExcuse(List<Card> hand) {
    return hand.any((card) => card == Card.excuse());
  }

}
