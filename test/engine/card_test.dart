import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';

void main() {
  test('Construct card succeeded', () {
    expect(() => TarotCard.coloredCard(Suit.heart, 5), returnsNormally);
  });

  test('Construct ace succeeded', () {
    expect(() => TarotCard.coloredCard(Suit.heart, 1), returnsNormally);
  });

  test('Construct king succeeded', () {
    expect(() => TarotCard.coloredCard(Suit.heart, CardStrengths.king),
        returnsNormally);
  });

  test('Construct colored card wrong strength', () {
    expect(() => TarotCard.coloredCard(Suit.heart, 21),
        throwsA(isInstanceOf<IllegalCardStrengthException>()));
  });

  test('Construct colored card wrong suit', () {
    expect(() => TarotCard.coloredCard(Suit.trump, 1),
        throwsA(isInstanceOf<IllegalCardStrengthException>()));
  });

  test('Standard card score no figure', () {
    final card = TarotCard.coloredCard(Suit.diamond, 1);
    expect(card.score, equals(0.5));
  });

  test('Standard card score jack', () {
    final card = TarotCard.coloredCard(Suit.diamond, CardStrengths.jack);
    expect(card.score, equals(1.5));
  });

  test('Standard card score knight', () {
    final card = TarotCard.coloredCard(Suit.diamond, CardStrengths.knight);
    expect(card.score, equals(2.5));
  });

  test('Standard card score queen', () {
    final card = TarotCard.coloredCard(Suit.diamond, CardStrengths.queen);
    expect(card.score, equals(3.5));
  });

  test('Standard card score king', () {
    final card = TarotCard.coloredCard(Suit.diamond, CardStrengths.king);
    expect(card.score, equals(4.5));
  });

  test('Oudler card score', () {
    expect(const TarotCard.excuse().score, equals(4.5));
    expect(TarotCard
        .trump(1)
        .score, equals(4.5));
    expect(TarotCard
        .trump(21)
        .score, equals(4.5));
  });

  test('Trump from 2 to 20 score', () {
    for (var strength = 2; strength <= 20; strength++) {
      expect(TarotCard
          .trump(strength)
          .score, equals(0.5));
    }
  });

  test('Construct trump', () {
    expect(() => TarotCard.trump(1), returnsNormally);
  });

  test('Construct trump wrong value', () {
    expect(() => TarotCard.trump(22),
        throwsA(isInstanceOf<IllegalCardStrengthException>()));
  });

  test('Construct 1 of trump', () {
    final card = TarotCard.trump(1);
    expect(card.isOudler, equals(true));
  });

  test('Construct 21 of trump', () {
    final card = TarotCard.trump(21);
    expect(card.isOudler, equals(true));
  });

  test('Construct excuse', () {
    const card = TarotCard.excuse();
    expect(card.isOudler, equals(true));
  });

  test('Construct ace of spaces not oudler', () {
    final card = TarotCard.coloredCard(Suit.spades, 1);
    expect(card.isOudler, equals(false));
  });

  test('4 is beaten by 10', () {
    final weakerCard = TarotCard.coloredCard(Suit.spades, 4);
    final strongerCard = TarotCard.coloredCard(Suit.spades, 10);
    expect(weakerCard.beats(Suit.none, strongerCard), false);
  });

  test('10 beats 4', () {
    final weakerCard = TarotCard.coloredCard(Suit.spades, 4);
    final strongerCard = TarotCard.coloredCard(Suit.spades, 10);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('king beats queen', () {
    final weakerCard = TarotCard.coloredCard(Suit.spades, CardStrengths.queen);
    final strongerCard = TarotCard.coloredCard(Suit.spades, CardStrengths.king);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('queen beats knight', () {
    final weakerCard = TarotCard.coloredCard(Suit.spades, CardStrengths.knight);
    final strongerCard =
    TarotCard.coloredCard(Suit.spades, CardStrengths.queen);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('knight beats jack', () {
    final weakerCard = TarotCard.coloredCard(Suit.spades, CardStrengths.jack);
    final strongerCard =
    TarotCard.coloredCard(Suit.spades, CardStrengths.knight);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('jack beats 10', () {
    final weakerCard = TarotCard.coloredCard(Suit.spades, 10);
    final strongerCard = TarotCard.coloredCard(Suit.spades, CardStrengths.jack);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('1 beats excuse', () {
    const weakerCard = TarotCard.excuse();
    final strongerCard = TarotCard.coloredCard(Suit.spades, 1);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('1 of trump beats king', () {
    final weakerCard = TarotCard.coloredCard(Suit.spades, CardStrengths.king);
    final strongerCard = TarotCard.trump(1);
    expect(strongerCard.beats(Suit.none, weakerCard), true);
  });

  test('king is beaten by 1 of trump', () {
    final weakerCard = TarotCard.coloredCard(Suit.spades, CardStrengths.king);
    final strongerCard = TarotCard.trump(1);
    expect(weakerCard.beats(Suit.none, strongerCard), false);
  });

  test('21 of trump beats 10 of trump', () {
    final weakerCard = TarotCard.trump(10);
    final strongerCard = TarotCard.trump(21);
    expect(weakerCard.beats(Suit.none, strongerCard), false);
  });

  test('1 of spades beats king of heart if spades is demanded', () {
    final weakerCard = TarotCard.coloredCard(Suit.heart, CardStrengths.king);
    final strongerCard = TarotCard.coloredCard(Suit.spades, 1);
    expect(strongerCard.beats(Suit.spades, weakerCard), true);
  });

  test('king of heart is beaten by 1 of spades if spades is demanded', () {
    final weakerCard = TarotCard.coloredCard(Suit.heart, CardStrengths.king);
    final strongerCard = TarotCard.coloredCard(Suit.spades, 1);
    expect(weakerCard.beats(Suit.spades, strongerCard), false);
  });
}
