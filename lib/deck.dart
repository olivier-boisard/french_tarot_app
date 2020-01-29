import 'package:french_tarot/cards.dart';

class Deck {
  final List<TarotCard> cards;

  Deck() : cards = <TarotCard>[] {
    for (Suit suit in Suit.values) {
      for (Value value in Value.values) {
        cards.add(TarotCard(suit, value));
      }
    }
  }
}
