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
