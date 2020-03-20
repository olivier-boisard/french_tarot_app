import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card_phase/turn.dart';
import 'package:french_tarot/engine/core/abstract_card.dart';
import 'package:french_tarot/engine/core/card.dart';

void main() {
  test('Construct Turn object', () {
    expect(() => Turn(), returnsNormally);
  });

  test('Add card', () {
    final turn = Turn();
    final playedCard = Card.trump(2);
    turn.addAction(playedCard);
    expect(turn.actionHistory.first, equals(playedCard));
  });

  test('Spades is asked, all cards in hand are allowed', () {
    final turn = Turn()
      ..addAction(Card.coloredCard(Suit.spades, 1));
    final Iterable<AbstractCard> cards = [
      Card.coloredCard(Suit.spades, 2),
      Card.coloredCard(Suit.spades, 3),
      Card.coloredCard(Suit.spades, 4)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, equals(cards));
  });

  test('Spades is asked, some cards in hand are allowed', () {
    final turn = Turn()
      ..addAction(Card.coloredCard(Suit.spades, 1));
    final Iterable<AbstractCard> cards = [
      Card.coloredCard(Suit.spades, 2),
      Card.coloredCard(Suit.heart, 3),
      Card.coloredCard(Suit.spades, 4)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards.length, equals(2));
  });

  test('Spades is asked, peeing', () {
    final turn = Turn()
      ..addAction(Card.coloredCard(Suit.spades, 1));
    final cards = [
      Card.coloredCard(Suit.diamond, 2),
      Card.coloredCard(Suit.heart, 3),
      Card.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, equals(cards));
  });

  test('Spades is asked, trump', () {
    final turn = Turn()
      ..addAction(Card.coloredCard(Suit.spades, 1));
    final cards = [
      Card.trump(2),
      Card.coloredCard(Suit.heart, 3),
      Card.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards.length, equals(1));
  });

  test('Spades is asked, trump and excuse', () {
    final turn = Turn()
      ..addAction(Card.coloredCard(Suit.spades, 1));
    final cards = [
      Card.trump(2),
      const Card.excuse(),
      Card.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards.length, equals(2));
  });

  test('No played cards', () {
    final turn = Turn();
    final Iterable<AbstractCard> cards = [
      Card.trump(2),
      const Card.excuse(),
      Card.coloredCard(Suit.clover, 4),
      Card.coloredCard(Suit.spades, 5),
      Card.coloredCard(Suit.heart, 6),
      Card.coloredCard(Suit.diamond, 7)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, cards);
  });

  test('First played card is excuse', () {
    final turn = Turn()
      ..addAction(const Card.excuse());
    final Iterable<AbstractCard> cards = [
      Card.trump(1),
      Card.coloredCard(Suit.clover, 4),
      Card.coloredCard(Suit.spades, 5),
      Card.coloredCard(Suit.heart, 6),
      Card.coloredCard(Suit.diamond, 7)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, cards);
  });

  test('Two played cards, first card is excuse', () {
    final turn = Turn()
      ..addAction(const Card.excuse())..addAction(
          Card.coloredCard(Suit.clover, 3));
    final Iterable<AbstractCard> cards = [
      Card.trump(1),
      Card.coloredCard(Suit.clover, 4),
      Card.coloredCard(Suit.spades, 5),
      Card.coloredCard(Suit.heart, 6),
      Card.coloredCard(Suit.diamond, 7)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, [Card.coloredCard(Suit.clover, 4)]);
  });

  test('Trump needed, need to go higher', () {
    final turn = Turn()
      ..addAction(Card.coloredCard(Suit.diamond, 1))..addAction(
          Card.trump(5));
    final cards = [
      Card.coloredCard(Suit.clover, 1),
      Card.trump(4),
      Card.trump(6)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, [Card.trump(6)]);
  });

  test('Trump needed, need to go lower', () {
    final turn = Turn()
      ..addAction(Card.coloredCard(Suit.diamond, 1))..addAction(
          Card.trump(7));
    final cards = [
      Card.coloredCard(Suit.clover, 1),
      Card.trump(4),
      Card.trump(6)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, [Card.trump(4), Card.trump(6)]);
  });

  test('Winning card index, all cards of same suit', () {
    final turn = Turn()
      ..addAction(Card.coloredCard(Suit.clover, 1))..addAction(
          Card.coloredCard(Suit.clover, 4))..addAction(
          Card.coloredCard(Suit.clover, 2))..addAction(
          Card.coloredCard(Suit.clover, 3));
    expect(turn.winningActionIndex, equals(1));
  });

  test('Winning card index, with trump', () {
    final turn = Turn()
      ..addAction(Card.trump(1))..addAction(
          Card.coloredCard(Suit.clover, 4))..addAction(
          Card.coloredCard(Suit.clover, 2))..addAction(
          Card.coloredCard(Suit.clover, 3));
    expect(turn.winningActionIndex, equals(0));
  });

  test('Winning card index, with excuse', () {
    final turn = Turn()
      ..addAction(Card.trump(1))..addAction(
          Card.coloredCard(Suit.clover, 4))..addAction(
          const Card.excuse())..addAction(Card.coloredCard(Suit.clover, 3));
    expect(turn.winningActionIndex, equals(0));
  });

  test('Winning card index, with peeing', () {
    final turn = Turn()
      ..addAction(Card.coloredCard(Suit.spades, 1))..addAction(
          Card.coloredCard(Suit.clover, 4))..addAction(
          Card.coloredCard(Suit.clover, 2))..addAction(
          Card.coloredCard(Suit.clover, 3));
    expect(turn.winningActionIndex, equals(0));
  });

  test('Winning card index, no cards', () {
    expect(() => Turn().winningActionIndex, throwsA(isInstanceOf<EmptyTurn>()));
  });
}
