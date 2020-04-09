import 'cards.dart';

class Deck {
  final List<TarotCard> cards;

  Deck() : cards = <TarotCard>[] {
    final suitValues = [
      Value.numeric_1,
      Value.numeric_2,
      Value.numeric_3,
      Value.numeric_4,
      Value.numeric_5,
      Value.numeric_6,
      Value.numeric_7,
      Value.numeric_8,
      Value.numeric_9,
      Value.numeric_10,
      Value.jack,
      Value.knight,
      Value.queen,
      Value.king,
    ];
    final trumpValues = [
      Value.numeric_1,
      Value.numeric_2,
      Value.numeric_3,
      Value.numeric_4,
      Value.numeric_5,
      Value.numeric_6,
      Value.numeric_7,
      Value.numeric_8,
      Value.numeric_9,
      Value.numeric_10,
      Value.numeric_11,
      Value.numeric_12,
      Value.numeric_13,
      Value.numeric_14,
      Value.numeric_15,
      Value.numeric_16,
      Value.numeric_17,
      Value.numeric_18,
      Value.numeric_19,
      Value.numeric_20,
      Value.numeric_21,
      Value.excuse
    ];
    final standardSuits = [Suit.heart, Suit.spades, Suit.diamond, Suit.club];
    for (final suit in standardSuits) {
      for (final value in suitValues) {
        cards.add(TarotCard(suit, value));
      }
    }

    for (final value in trumpValues) {
      cards.add(TarotCard(Suit.trump, value));
    }

    cards.shuffle();
  }
}
