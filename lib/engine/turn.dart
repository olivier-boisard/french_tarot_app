import 'package:french_tarot/engine/card.dart';

class Turn {
  final List<Card> playedCards;

  Turn() : playedCards = List<Card>();

  void addPlayedCard(Card card) {
    playedCards.add(card);
  }

  List<Card> extractAllowedCards(List<Card> cards) {
    final asked = playedCards.first.suit;
    return cards.where((cardInHand) => cardInHand.suit == asked).toList();
  }
}
