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
  test("Standard card score no figure", () {
    var card = Card.coloredCard(Suit.diamond, 1);
    expect(card.score, equals(0.5));
  });
  test("Standard card score jack", () {
    var card = Card.coloredCard(Suit.diamond, FigureValues.JACK);
    expect(card.score, equals(1.5));
  });
  test("Standard card score knight", () {
    var card = Card.coloredCard(Suit.diamond, FigureValues.KNIGHT);
    expect(card.score, equals(2.5));
  });
  test("Standard card score queen", () {
    var card = Card.coloredCard(Suit.diamond, FigureValues.QUEEN);
    expect(card.score, equals(3.5));
  });
  test("Standard card score king", () {
    var card = Card.coloredCard(Suit.diamond, FigureValues.KING);
    expect(card.score, equals(4.5));
  });
  test("Construct trump", () {
    expect(() => Card.trump(1), returnsNormally);
  });
  test("Construct trump wrong value", () {
    expect(() => Card.trump(22), returnsNormally);
  });
  //TODO excuse
  //TODO test get card isOudler
  //TODO create creation of trump and excuse
  //TODO test beats
}
