import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/exceptions.dart';

void main() {
  test("Construct card succeeded", () {
    expect(() => Card.coloredCard(Suit.heart, 5), returnsNormally);
  });
  test("Construct ace succeeded", () {
    expect(() => Card.coloredCard(Suit.heart, 1), returnsNormally);
  });
  test("Construct king succeeded", () {
    expect(() => Card.coloredCard(Suit.heart, FigureValues.KING),
        returnsNormally);
  });
  test("Construct colored card wrong strength", () {
    expect(() => Card.coloredCard(Suit.heart, 21),
        throwsA(isInstanceOf<IllegalCardStrengthException>()));
  });
  test("Construct colored card wrong suit", () {
    expect(() => Card.coloredCard(Suit.trump, 1),
        throwsA(isInstanceOf<IllegalCardStrengthException>()));
  });
  test("Standard card score", () {
    var card = Card.coloredCard(Suit.diamond, 1);
    expect(card.score, equals(0.5));
  });
  //TODO test get card score
  //TODO test get card isOudler
  //TODO create creation of trump and excuse
  //TODO test beats
}
