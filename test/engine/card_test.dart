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
    expect(() => Card.coloredCard(Suit.heart, CardStrengths.KING),
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
    final card = Card.coloredCard(Suit.diamond, 1);
    expect(card.score, equals(0.5));
  });
  test("Standard card score jack", () {
    final card = Card.coloredCard(Suit.diamond, CardStrengths.JACK);
    expect(card.score, equals(1.5));
  });
  test("Standard card score knight", () {
    final card = Card.coloredCard(Suit.diamond, CardStrengths.KNIGHT);
    expect(card.score, equals(2.5));
  });
  test("Standard card score queen", () {
    final card = Card.coloredCard(Suit.diamond, CardStrengths.QUEEN);
    expect(card.score, equals(3.5));
  });
  test("Standard card score king", () {
    final card = Card.coloredCard(Suit.diamond, CardStrengths.KING);
    expect(card.score, equals(4.5));
  });
  test("Construct trump", () {
    expect(() => Card.trump(1), returnsNormally);
  });
  test("Construct trump wrong value", () {
    expect(() => Card.trump(22), returnsNormally);
  });
  test("Construct 1 of trump", () {
    final card = Card.trump(1);
    expect(card.isOudler, equals(true));
  });
  test("Construct 21 of trump", () {
    final card = Card.trump(21);
    expect(card.isOudler, equals(true));
  });
  test("Construct excuse", () {
    final card = Card.excuse();
    expect(card.isOudler, equals(true));
  });
  test("Construct ace of spaces not oudler", () {
    final card = Card.coloredCard(Suit.spades, 1);
    expect(card.isOudler, equals(false));
  });
  test("4 of spades is beaten by 10 of spades", () {
    final weakerCard = Card.coloredCard(Suit.spades, 4);
    final strongerCard = Card.coloredCard(Suit.spades, 10);
    expect(weakerCard.beats(Suit.none, strongerCard), false);
  });
  test("10 of spades beats by 4 of spades", () {
    final weakerCard = Card.coloredCard(Suit.spades, 4);
    final strongerCard = Card.coloredCard(Suit.spades, 10);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });
  //TODO test beats
}
