import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';

void main() {
  test('Construct card succeeded', () {
    expect(() => Card.coloredCard(Suit.heart, 5), returnsNormally);
  });

  test('Construct ace succeeded', () {
    expect(() => Card.coloredCard(Suit.heart, 1), returnsNormally);
  });

  test('Construct king succeeded', () {
    expect(() => Card.coloredCard(Suit.heart, CardStrengths.king),
        returnsNormally);
  });

  test('Construct colored card wrong strength', () {
    expect(() => Card.coloredCard(Suit.heart, 21),
        throwsA(isInstanceOf<IllegalCardStrengthException>()));
  });

  test('Construct colored card wrong suit', () {
    expect(() => Card.coloredCard(Suit.trump, 1),
        throwsA(isInstanceOf<IllegalCardStrengthException>()));
  });

  test('Standard card score no figure', () {
    final card = Card.coloredCard(Suit.diamond, 1);
    expect(card.score, equals(0.5));
  });

  test('Standard card score jack', () {
    final card = Card.coloredCard(Suit.diamond, CardStrengths.jack);
    expect(card.score, equals(1.5));
  });

  test('Standard card score knight', () {
    final card = Card.coloredCard(Suit.diamond, CardStrengths.knight);
    expect(card.score, equals(2.5));
  });

  test('Standard card score queen', () {
    final card = Card.coloredCard(Suit.diamond, CardStrengths.queen);
    expect(card.score, equals(3.5));
  });

  test('Standard card score king', () {
    final card = Card.coloredCard(Suit.diamond, CardStrengths.king);
    expect(card.score, equals(4.5));
  });

  test('Oudler card score', () {
    expect(const Card
        .excuse()
        .score, equals(4.5));
    expect(Card
        .trump(1)
        .score, equals(4.5));
    expect(Card
        .trump(21)
        .score, equals(4.5));
  });

  test('Construct trump', () {
    expect(() => Card.trump(1), returnsNormally);
  });

  test('Construct trump wrong value', () {
    expect(() => Card.trump(22),
        throwsA(isInstanceOf<IllegalCardStrengthException>()));
  });

  test('Construct 1 of trump', () {
    final card = Card.trump(1);
    expect(card.isOudler, equals(true));
  });

  test('Construct 21 of trump', () {
    final card = Card.trump(21);
    expect(card.isOudler, equals(true));
  });

  test('Construct excuse', () {
    const card = Card.excuse();
    expect(card.isOudler, equals(true));
  });

  test('Construct ace of spaces not oudler', () {
    final card = Card.coloredCard(Suit.spades, 1);
    expect(card.isOudler, equals(false));
  });

  test('4 is beaten by 10', () {
    final weakerCard = Card.coloredCard(Suit.spades, 4);
    final strongerCard = Card.coloredCard(Suit.spades, 10);
    expect(weakerCard.beats(Suit.none, strongerCard), false);
  });

  test('10 beats 4', () {
    final weakerCard = Card.coloredCard(Suit.spades, 4);
    final strongerCard = Card.coloredCard(Suit.spades, 10);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('king beats queen', () {
    final weakerCard = Card.coloredCard(Suit.spades, CardStrengths.queen);
    final strongerCard = Card.coloredCard(Suit.spades, CardStrengths.king);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('queen beats knight', () {
    final weakerCard = Card.coloredCard(Suit.spades, CardStrengths.knight);
    final strongerCard = Card.coloredCard(Suit.spades, CardStrengths.queen);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('knight beats jack', () {
    final weakerCard = Card.coloredCard(Suit.spades, CardStrengths.jack);
    final strongerCard = Card.coloredCard(Suit.spades, CardStrengths.knight);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('jack beats 10', () {
    final weakerCard = Card.coloredCard(Suit.spades, 10);
    final strongerCard = Card.coloredCard(Suit.spades, CardStrengths.jack);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('1 beats excuse', () {
    const weakerCard = Card.excuse();
    final strongerCard = Card.coloredCard(Suit.spades, 1);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('1 of trump beats king', () {
    final weakerCard = Card.coloredCard(Suit.spades, CardStrengths.king);
    final strongerCard = Card.trump(1);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('king is beaten by 1 of trump', () {
    final weakerCard = Card.coloredCard(Suit.spades, CardStrengths.king);
    final strongerCard = Card.trump(1);
    expect(weakerCard.beats(Suit.none, strongerCard), false);
  });

  test('21 of trump beats 10 of trump', () {
    final weakerCard = Card.trump(10);
    final strongerCard = Card.trump(21);
    expect(weakerCard.beats(Suit.none, strongerCard), false);
  });

  test('1 of spades beats king of heart if spades is demanded', () {
    final weakerCard = Card.coloredCard(Suit.heart, CardStrengths.king);
    final strongerCard = Card.coloredCard(Suit.spades, 1);
    expect(strongerCard.beats(Suit.spades, weakerCard), true);
  });

  test('king of heart is beaten by 1 of spades if spades is demanded', () {
    final weakerCard = Card.coloredCard(Suit.heart, CardStrengths.king);
    final strongerCard = Card.coloredCard(Suit.spades, 1);
    expect(weakerCard.beats(Suit.spades, strongerCard), false);
  });
}
