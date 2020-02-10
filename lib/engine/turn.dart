import 'package:french_tarot/engine/card.dart';

class Turn {
  final List<Card> playedCards;

  Turn() : playedCards = List<Card>();

  void addPlayedCard(Card card) {
    playedCards.add(card);
  }

  List<Card> extractAllowedCards(List<Card> hand) {
    if (playedCards.isEmpty) {
      return List<Card>.from(hand);
    }

    if (playedCards.length == 1 && playedCards.first == Card.excuse()) {
      return List<Card>.from(hand);
    }
    

    final asked = playedCards.first.suit;
    var validCards = hand.where((card) => card.suit == asked).toList();
    if (validCards.isEmpty) {
      validCards = hand.where((card) => card.suit == Suit.trump).toList();
      if (validCards.isEmpty) {
        validCards = List<Card>.from(hand);
      }
    }
    if (hand.any((card) => card == Card.excuse())) {
      validCards.add(Card.excuse());
    }
    return validCards;
  }
}
