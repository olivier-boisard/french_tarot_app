import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';
import 'package:french_tarot/engine/phases/card/card_phase_turn.dart';

void main() {
  test('Construct Turn object', () {
    expect(() => CardPhaseTurn(), returnsNormally);
  });

  test('Add card', () {
    final turn = CardPhaseTurn();
    final playedCard = TarotCard.trump(2);
    turn.addAction(playedCard);
    expect(turn.actionHistory.first, equals(playedCard));
  });

  test('Spades is asked, all cards in hand are allowed', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.spades, 1));
    final Iterable<SuitedPlayable> cards = [
      TarotCard.coloredCard(Suit.spades, 2),
      TarotCard.coloredCard(Suit.spades, 3),
      TarotCard.coloredCard(Suit.spades, 4)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, equals(cards));
  });

  test('Spades is asked, some cards in hand are allowed', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.spades, 1));
    final Iterable<SuitedPlayable> cards = [
      TarotCard.coloredCard(Suit.spades, 2),
      TarotCard.coloredCard(Suit.heart, 3),
      TarotCard.coloredCard(Suit.spades, 4)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards.length, equals(2));
  });

  test('Spades is asked, peeing', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.spades, 1));
    final cards = [
      TarotCard.coloredCard(Suit.diamond, 2),
      TarotCard.coloredCard(Suit.heart, 3),
      TarotCard.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, equals(cards));
  });

  test('Spades is asked, trump', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.spades, 1));
    final cards = [
      TarotCard.trump(2),
      TarotCard.coloredCard(Suit.heart, 3),
      TarotCard.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards.length, equals(1));
  });

  test('Spades is asked, trump and excuse', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.spades, 1));
    final cards = [
      TarotCard.trump(2),
      const TarotCard.excuse(),
      TarotCard.coloredCard(Suit.clover, 4)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards.length, equals(2));
  });

  test('No played cards', () {
    final turn = CardPhaseTurn();
    final Iterable<SuitedPlayable> cards = [
      TarotCard.trump(2),
      const TarotCard.excuse(),
      TarotCard.coloredCard(Suit.clover, 4),
      TarotCard.coloredCard(Suit.spades, 5),
      TarotCard.coloredCard(Suit.heart, 6),
      TarotCard.coloredCard(Suit.diamond, 7)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, cards);
  });

  test('First played card is excuse', () {
    final turn = CardPhaseTurn()
      ..addAction(const TarotCard.excuse());
    final Iterable<SuitedPlayable> cards = [
      TarotCard.trump(1),
      TarotCard.coloredCard(Suit.clover, 4),
      TarotCard.coloredCard(Suit.spades, 5),
      TarotCard.coloredCard(Suit.heart, 6),
      TarotCard.coloredCard(Suit.diamond, 7)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, cards);
  });

  test('Two played cards, first card is excuse', () {
    final turn = CardPhaseTurn()
      ..addAction(const TarotCard.excuse())..addAction(
          TarotCard.coloredCard(Suit.clover, 3));
    final Iterable<SuitedPlayable> cards = [
      TarotCard.trump(1),
      TarotCard.coloredCard(Suit.clover, 4),
      TarotCard.coloredCard(Suit.spades, 5),
      TarotCard.coloredCard(Suit.heart, 6),
      TarotCard.coloredCard(Suit.diamond, 7)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, [TarotCard.coloredCard(Suit.clover, 4)]);
  });

  test('Trump needed, need to go higher', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.diamond, 1))..addAction(
          TarotCard.trump(5));
    final cards = [
      TarotCard.coloredCard(Suit.clover, 1),
      TarotCard.trump(4),
      TarotCard.trump(6)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, [TarotCard.trump(6)]);
  });

  test('Trump needed, need to go lower', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.diamond, 1))..addAction(
          TarotCard.trump(7));
    final cards = [
      TarotCard.coloredCard(Suit.clover, 1),
      TarotCard.trump(4),
      TarotCard.trump(6)
    ];
    final allowedCards = turn.extractAllowedActions(cards);
    expect(allowedCards, [TarotCard.trump(4), TarotCard.trump(6)]);
  });

  test('Winning card index, all cards of same suit', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.clover, 1))..addAction(
          TarotCard.coloredCard(Suit.clover, 4))..addAction(
          TarotCard.coloredCard(Suit.clover, 2))..addAction(
          TarotCard.coloredCard(Suit.clover, 3));
    expect(turn.winningActionIndex, equals(1));
  });

  test('Winning card index, with trump', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.trump(1))..addAction(
          TarotCard.coloredCard(Suit.clover, 4))..addAction(
          TarotCard.coloredCard(Suit.clover, 2))..addAction(
          TarotCard.coloredCard(Suit.clover, 3));
    expect(turn.winningActionIndex, equals(0));
  });

  test('Winning card index, with excuse', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.trump(1))..addAction(
          TarotCard.coloredCard(Suit.clover, 4))..addAction(
          const TarotCard.excuse())..addAction(
          TarotCard.coloredCard(Suit.clover, 3));
    expect(turn.winningActionIndex, equals(0));
  });

  test('Winning card index, with peeing', () {
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.spades, 1))..addAction(
          TarotCard.coloredCard(Suit.clover, 4))..addAction(
          TarotCard.coloredCard(Suit.clover, 2))..addAction(
          TarotCard.coloredCard(Suit.clover, 3));
    expect(turn.winningActionIndex, equals(0));
  });

  test('Winning card index, no cards', () {
    expect(
      () => CardPhaseTurn().winningActionIndex,
      throwsA(isInstanceOf<EmptyTurn>()),
    );
  });
}
