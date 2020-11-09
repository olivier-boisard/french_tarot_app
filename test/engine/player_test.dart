import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/score_manager.dart';
import 'package:french_tarot/engine/core/suits.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';

void main() {
  test('Player has won cards, evaluate score and number of oudlers', () {
    final player = ScoreManager();
    const expectedScore = 14;

    _makePlayerWinsNonOudlerCards(player);
    _makePlayerWinTwoOudlers(player);

    expect(player.score, equals(expectedScore));
    expect(player.nOudlers, equals(2));
  });

  test('Compute score on odd number of cards fails', () {
    final player = ScoreManager();
    final wonCards = [TarotCard.coloredCard(Suit.spades, 1)];
    player.winScoreElements(wonCards);
    expect(
      () => player.score,
      throwsA(isInstanceOf<OddNumberOfCardsException>()),
    );
  });
}

void _makePlayerWinTwoOudlers(ScoreManager player) {
  final oudlers = [const TarotCard.excuse(), TarotCard.trump(21)];
  player.winScoreElements(oudlers);
}

void _makePlayerWinsNonOudlerCards(ScoreManager player) {
  final wonCards = <TarotCard>[
    TarotCard.coloredCard(Suit.spades, 1),
    TarotCard.coloredCard(Suit.heart, CardStrengths.queen),
    TarotCard.trump(2),
    TarotCard.trump(3),
  ];
  player.winScoreElements(wonCards);
}
