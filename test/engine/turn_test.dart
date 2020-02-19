import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/turn.dart';

void main() {
  test('Construct Turn object', () {
    expect(() => Turn(), returnsNormally);
  });

  test('Add card', () {
    final turn = Turn();
    final playedCard = Card.trump(2);
    turn.addPlayedCard(playedCard);
    expect(turn.playedCards.first, equals(playedCard));
  });

  test('Spades is asked, all cards in hand are allowed', () {
    final turn = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.spades, 1));
    final Iterable<Card> cards = [
      Card.coloredCard(Suit.spades, 2),
      Card.coloredCard(Suit.spades, 3),
      Card.coloredCard(Suit.spades, 4)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards, equals(cards));
  });

  test('Spades is asked, some cards in hand are allowed', () {
    final turn = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.spades, 1));
    final Iterable<Card> cards = [
      Card.coloredCard(Suit.spades, 2),
      Card.coloredCard(Suit.heart, 3),
      Card.coloredCard(Suit.spades, 4)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards.length, equals(2));
  });

  test('Spades is asked, peeing', () {
    final turn = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.spades, 1));
    final cards = [
      Card.coloredCard(Suit.diamond, 2),
      Card.coloredCard(Suit.heart, 3),
      Card.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards, equals(cards));
  });

  test('Spades is asked, trump', () {
    final turn = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.spades, 1));
    final cards = [
      Card.trump(2),
      Card.coloredCard(Suit.heart, 3),
      Card.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards.length, equals(1));
  });

  test('Spades is asked, trump and excuse', () {
    final turn = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.spades, 1));
    final cards = [
      Card.trump(2),
      const Card.excuse(),
      Card.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards.length, equals(2));
  });

  test('No played cards', () {
    final turn = Turn();
    final Iterable<Card> cards = [
      Card.trump(2),
      const Card.excuse(),
      Card.coloredCard(Suit.clover, 4),
      Card.coloredCard(Suit.spades, 5),
      Card.coloredCard(Suit.heart, 6),
      Card.coloredCard(Suit.diamond, 7)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards, cards);
  });

  test('First played card is excuse', () {
    final turn = Turn()
      ..addPlayedCard(const Card.excuse());
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

  test('Two played cards, first card is excuse', () {
    final turn = Turn()
      ..addPlayedCard(const Card.excuse())..addPlayedCard(
          Card.coloredCard(Suit.clover, 3));
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

  test('Trump needed, need to go higher', () {
    final turn = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.diamond, 1))..addPlayedCard(
          Card.trump(5));
    final cards = [
      Card.coloredCard(Suit.clover, 1),
      Card.trump(4),
      Card.trump(6)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards, [Card.trump(6)]);
  });

  test('Trump needed, need to go lower', () {
    final turn = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.diamond, 1))..addPlayedCard(
          Card.trump(7));
    final cards = [
      Card.coloredCard(Suit.clover, 1),
      Card.trump(4),
      Card.trump(6)
    ];
    final allowedCards = turn.extractAllowedCards(cards);
    expect(allowedCards, [Card.trump(4), Card.trump(6)]);
  });

  test('Winning card index, all cards of same suit', () {
    final turn = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.clover, 1))..addPlayedCard(
          Card.coloredCard(Suit.clover, 4))..addPlayedCard(
          Card.coloredCard(Suit.clover, 2))..addPlayedCard(
          Card.coloredCard(Suit.clover, 3));
    expect(turn.winningCardIndex, equals(1));
  });

  test('Winning card index, with trump', () {
    final turn = Turn()
      ..addPlayedCard(Card.trump(1))..addPlayedCard(
          Card.coloredCard(Suit.clover, 4))..addPlayedCard(
          Card.coloredCard(Suit.clover, 2))..addPlayedCard(
          Card.coloredCard(Suit.clover, 3));
    expect(turn.winningCardIndex, equals(0));
  });

  test('Winning card index, with excuse', () {
    final turn = Turn()
      ..addPlayedCard(Card.trump(1))..addPlayedCard(
          Card.coloredCard(Suit.clover, 4))..addPlayedCard(
          const Card.excuse())..addPlayedCard(Card.coloredCard(Suit.clover, 3));
    expect(turn.winningCardIndex, equals(0));
  });

  test('Winning card index, with peeing', () {
    final turn = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.spades, 1))..addPlayedCard(
          Card.coloredCard(Suit.clover, 4))..addPlayedCard(
          Card.coloredCard(Suit.clover, 2))..addPlayedCard(
          Card.coloredCard(Suit.clover, 3));
    expect(turn.winningCardIndex, equals(0));
  });

  test('Winning card index, no cards', () {
    expect(() => Turn().winningCardIndex, throwsA(isInstanceOf<EmptyTurn>()));
  });
}
