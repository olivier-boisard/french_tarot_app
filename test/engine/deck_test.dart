import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/deck.dart';

void main() {
  const nCardsInDeck = 78;

  test('Constructed deck has correct number of cards', () {
    final deck = Deck()
      ..pop(nCardsInDeck);
    expect(() => deck.pop(1), throwsA(isInstanceOf<RangeError>()));
  });

  test('Shuffle deck', () {
    const randomSeed = 1;
    final shuffledDeck = Deck.withRandom(Random(randomSeed))
      ..shuffle();
    final shuffledCard = shuffledDeck.pop(nCardsInDeck);
    final orderedCard = Deck().pop(nCardsInDeck);
    expect(shuffledCard, isNot(orderedEquals(orderedCard)));
    expect(shuffledCard, unorderedEquals(orderedCard));
  });

  test('Results are reproducible', () {
    const randomSeed = 1;
    final deck1 = Deck.withRandom(Random(randomSeed));
    final deck2 = Deck.withRandom(Random(randomSeed));
    expect(deck1.pop(nCardsInDeck), orderedEquals(deck2.pop(nCardsInDeck)));
  });

  test('Different random seeds produce different results', () {
    const randomSeed1 = 1;
    const randomSeed2 = 2;
    final deck1 = Deck.withRandom(Random(randomSeed1))
      ..shuffle();
    final deck2 = Deck.withRandom(Random(randomSeed2))
      ..shuffle();
    final cards1 = deck1.pop(nCardsInDeck);
    final cards2 = deck2.pop(nCardsInDeck);
    expect(cards1, isNot(orderedEquals(cards2)));
    expect(cards1, unorderedEquals(cards2));
  });

  test('Pop 10 cards from deck, 68 are remaining', () {
    final deck = Deck();
    const nCardsToPop = 10;
    final firstlyPoppedCards = deck.pop(nCardsToPop);
    expect(firstlyPoppedCards.length, equals(nCardsToPop));

    final remainingCards = deck.pop(nCardsInDeck - nCardsToPop);
    final allPoppedCards = firstlyPoppedCards + remainingCards;
    expect(allPoppedCards, unorderedEquals(Deck().pop(nCardsInDeck)));
  });
}
