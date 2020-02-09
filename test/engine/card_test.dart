import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/exceptions.dart';

void main() {
  test("Construct card succeeded", () {
    expect(() => Card.createColoredCard(Suit.heart, 5), returnsNormally);
  });
  test("Construct ace succeeded", () {
    expect(() => Card.createColoredCard(Suit.heart, 1), returnsNormally);
  });
  test("Construct king succeeded", () {
    expect(() => Card.createColoredCard(Suit.heart, FigureValues.KING),
        returnsNormally);
  });
  test("Construct colored card failed", () {
    expect(() => Card.createColoredCard(Suit.heart, 21),
        throwsA(isInstanceOf<IllegalCardValueException>()));
  });
}
