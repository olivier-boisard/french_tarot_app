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
    expect(allowedCards, equals(cards));
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

  test("Spades is asked, peeing", () {
    final turn = Turn();
    turn.addPlayedCard(Card.coloredCard(Suit.spades, 1));
    final Iterable<Card> cards = [
      Card.coloredCard(Suit.diamond, 2),
      Card.coloredCard(Suit.heart, 3),
      Card.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards, equals(cards));
  });

  test("Spades is asked, trump", () {
    final turn = Turn();
    turn.addPlayedCard(Card.coloredCard(Suit.spades, 1));
    final Iterable<Card> cards = [
      Card.trump(2),
      Card.coloredCard(Suit.heart, 3),
      Card.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards.length, equals(1));
  });

  test("Spades is asked, trump and excuse", () {
    final turn = Turn();
    turn.addPlayedCard(Card.coloredCard(Suit.spades, 1));
    final Iterable<Card> cards = [
      Card.trump(2),
      Card.excuse(),
      Card.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards.length, equals(2));
  });

  test("No played cards", () {
    final turn = Turn();
    final Iterable<Card> cards = [
      Card.trump(2),
      Card.excuse(),
      Card.coloredCard(Suit.clover, 4),
      Card.coloredCard(Suit.spades, 5),
      Card.coloredCard(Suit.heart, 6),
      Card.coloredCard(Suit.diamond, 7)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards, cards);
  });

  test("First played card is excuse", () {
    final turn = Turn();
    turn.addPlayedCard(Card.excuse());
    final Iterable<Card> cards = [
      Card.trump(1),
      Card.coloredCard(Suit.clover, 4),
      Card.coloredCard(Suit.spades, 5),
      Card.coloredCard(Suit.heart, 6),
      Card.coloredCard(Suit.diamond, 7)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards, cards);
  });

  test("Two played cards, first card is excuse", () {
    final turn = Turn();
    turn.addPlayedCard(Card.excuse());
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 3));
    final Iterable<Card> cards = [
      Card.trump(1),
      Card.coloredCard(Suit.clover, 4),
      Card.coloredCard(Suit.spades, 5),
      Card.coloredCard(Suit.heart, 6),
      Card.coloredCard(Suit.diamond, 7)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards, [Card.coloredCard(Suit.clover, 4)]);
  });

  test("Winning card index, all cards of same suit", () {
    final turn = Turn();
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 1));
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 4));
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 2));
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 3));
    expect(turn.winningCardIndex, equals(1));
  });

  test("Winning card index, with trump", () {
    final turn = Turn();
    turn.addPlayedCard(Card.trump(1));
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 4));
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 2));
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 3));
    expect(turn.winningCardIndex, equals(0));
  });

  test("Winning card index, with excuse", () {
    final turn = Turn();
    turn.addPlayedCard(Card.trump(1));
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 4));
    turn.addPlayedCard(Card.excuse());
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 3));
    expect(turn.winningCardIndex, equals(0));
  });

  test("Winning card index, with peeing", () {
    final turn = Turn();
    turn.addPlayedCard(Card.coloredCard(Suit.spades, 1));
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 4));
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 2));
    turn.addPlayedCard(Card.coloredCard(Suit.clover, 3));
    expect(turn.winningCardIndex, equals(0));
  });
}
