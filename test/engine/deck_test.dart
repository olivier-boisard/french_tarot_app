import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/deck.dart';

void main() {
  test("Construct deck without random object", () {
    final nCardsInDeck = 78;
    expect(Deck().cards.length, nCardsInDeck);
  });
  test("Construct deck with random object", () {
    expect(() => Deck.withRandom(Random()), returnsNormally);
  });
  test("Shuffle deck", () {
    final shuffledDeck = Deck();
    shuffledDeck.shuffle();
    expect(shuffledDeck.cards, isNot(orderedEquals(Deck().cards)));
    expect(shuffledDeck.cards, unorderedEquals(Deck().cards));
  });
}
