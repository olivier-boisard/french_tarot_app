import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/turn.dart';

void main() {
  test("Construct Turn object", () {
    expect(() => Turn(), returnsNormally);
  });
  test("Add card", () {
    final turn = Turn();
    final playedCard = Card.trump(2);
    turn.addPlayedCard(playedCard);
    expect(turn.playedCards.first, equals(playedCard));
  });
  test("Spades is asked, all cards in hand are allowed", () {
    final turn = Turn();
    turn.addPlayedCard(Card.coloredCard(Suit.spades, 1));
    final Iterable<Card> cards = [
      Card.coloredCard(Suit.spades, 2),
      Card.coloredCard(Suit.spades, 3),
      Card.coloredCard(Suit.spades, 4)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards.length, equals(cards.length));
  });
  test("Spades is asked, some cards in hand are allowed", () {
    final turn = Turn();
    turn.addPlayedCard(Card.coloredCard(Suit.spades, 1));
    final Iterable<Card> cards = [
      Card.coloredCard(Suit.spades, 2),
      Card.coloredCard(Suit.heart, 3),
      Card.coloredCard(Suit.spades, 4)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards.length, equals(2));
  });
}
