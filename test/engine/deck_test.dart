import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/deck.dart';

void main() {
  test('Construct deck without random object', () {
    const nCardsInDeck = 78;
    expect(Deck().cards.length, nCardsInDeck);
  });

  test('Construct deck with random object', () {
    expect(() => Deck.withRandom(Random()), returnsNormally);
  });

  test('Shuffle deck', () {
    final shuffledDeck = Deck()
      ..shuffle();
    expect(shuffledDeck.cards, isNot(orderedEquals(Deck().cards)));
    expect(shuffledDeck.cards, unorderedEquals(Deck().cards));
  });

  test('Pop 10 cards from deck', () {
    final deck = Deck();
    const nCardsToPop = 10;
    final nCardsInDeck = deck.cards.length;
    final poppedCards = deck.pop(nCardsToPop);
    expect(poppedCards.length, equals(nCardsToPop));
    expect(deck.cards.length, equals(nCardsInDeck - nCardsToPop));
    expect(deck.cards, isNot(contains(poppedCards[0])));
  });
}
