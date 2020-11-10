import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/round_scores_computer.dart';
import 'package:french_tarot/engine/core/score_manager.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';
import 'package:french_tarot/engine/phases/card/card_phase_agent.dart';
import 'package:french_tarot/engine/phases/card/card_phase_turn.dart';
import 'package:french_tarot/engine/random/random_card_phase_agent_facade.dart';

void main() {
  test('Evaluate score', () {
    final turn1 = CardPhaseTurn<TarotCard>()
      ..addAction(TarotCard.coloredCard(Suit.diamond, 1))..addAction(
          TarotCard.coloredCard(Suit.diamond, 2))..addAction(
          TarotCard.coloredCard(Suit.diamond, 3))..addAction(
          TarotCard.coloredCard(Suit.diamond, 4));

    final turn2 = CardPhaseTurn<TarotCard>()
      ..addAction(
          TarotCard.coloredCard(Suit.diamond, CardStrengths.jack))..addAction(
          TarotCard.coloredCard(Suit.diamond, 7))..addAction(
          TarotCard.coloredCard(Suit.diamond, 6))..addAction(
          TarotCard.coloredCard(Suit.diamond, 5));

    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;

    final takerScoreManager = ScoreManager();
    final oppositionScoreManager = ScoreManager();

    RoundScoresComputer(
      taker,
      takerScoreManager.winScoreElements,
      oppositionScoreManager.winScoreElements,
    )
      ..consume(turn1, orderedPlayers)..consume(turn2, orderedPlayers);

    expect(takerScoreManager.score, equals(3));
    expect(oppositionScoreManager.score, equals(2));
  });

  test('Opposition plays excuse and wins', () {
    final turn = CardPhaseTurn<TarotCard>()
      ..addAction(TarotCard.coloredCard(Suit.diamond, 1))..addAction(
          TarotCard.coloredCard(Suit.diamond, 2))..addAction(
          const TarotCard.excuse())..addAction(
          TarotCard.coloredCard(Suit.diamond, 3));
    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;
    final takerScoreManager = ScoreManager();
    final oppositionScoreManager = ScoreManager();

    RoundScoresComputer(
      taker,
      takerScoreManager.winScoreElements,
      oppositionScoreManager.winScoreElements,
    ).consume(turn, orderedPlayers);
    expect(takerScoreManager.score, equals(0));
    expect(oppositionScoreManager.score, equals(6));
  });

  test('Oppotion plays excuse and looses', () {
    final turn = CardPhaseTurn<TarotCard>()
      ..addAction(TarotCard.coloredCard(Suit.diamond, 3))..addAction(
          TarotCard.coloredCard(Suit.diamond, 2))..addAction(
          const TarotCard.excuse())..addAction(
          TarotCard.coloredCard(Suit.diamond, 1));
    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;
    final takerScoreManager = ScoreManager();
    final oppositionScoreManager = ScoreManager();

    RoundScoresComputer(
      taker,
      takerScoreManager.winScoreElements,
      oppositionScoreManager.winScoreElements,
    ).consume(turn, orderedPlayers);

    expect(takerScoreManager.score, equals(2));
    expect(oppositionScoreManager.score, equals(4));
  });

  test('Taker plays excuse', () {
    final turn = CardPhaseTurn<TarotCard>()
      ..addAction(const TarotCard.excuse())..addAction(
          TarotCard.coloredCard(Suit.diamond, 1))..addAction(
          TarotCard.coloredCard(Suit.diamond, 2))..addAction(
          TarotCard.coloredCard(Suit.diamond, 3));
    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;
    final takerScoreManager = ScoreManager();
    final oppositionScoreManager = ScoreManager();

    RoundScoresComputer(
      taker,
      takerScoreManager.winScoreElements,
      oppositionScoreManager.winScoreElements,
    ).consume(turn, orderedPlayers);

    expect(takerScoreManager.score, equals(4));
    expect(oppositionScoreManager.score, equals(2));
  });
}

CardPhaseAgent _createCardPhaseAgent() {
  // For the sake of this unit test, passing a null hand to the CardPhaseAgent
  // is fine. In reality however, it's important to give the agent a proper
  // instance of Hand.
  return RandomCardPhaseAgentFacade(null);
}
