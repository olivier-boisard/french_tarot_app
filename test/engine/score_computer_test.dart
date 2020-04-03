import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/card.dart';
import 'package:french_tarot/engine/core/round_scores_computer.dart';
import 'package:french_tarot/engine/core/score_manager.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/phases/card/card_phase_agent.dart';
import 'package:french_tarot/engine/phases/card/turn.dart';
import 'package:french_tarot/engine/random/random_decision_maker.dart';

void main() {
  test('Evaluate score', () {
    final turn1 = Turn<Card>()
      ..addAction(Card.coloredCard(Suit.diamond, 1))
      ..addAction(Card.coloredCard(Suit.diamond, 2))
      ..addAction(Card.coloredCard(Suit.diamond, 3))
      ..addAction(Card.coloredCard(Suit.diamond, 4));

    final turn2 = Turn<Card>()
      ..addAction(Card.coloredCard(Suit.diamond, CardStrengths.jack))
      ..addAction(Card.coloredCard(Suit.diamond, 7))
      ..addAction(Card.coloredCard(Suit.diamond, 6))
      ..addAction(Card.coloredCard(Suit.diamond, 5));

    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;

    final takerScoreManager = ScoreManager();
    final oppositionScoreManager = ScoreManager();

    //TODO not very satisfying to create an object that is not ready
    final roundScoresComputer = RoundScoresComputer(
      takerScoreManager.winScoreElements,
      oppositionScoreManager.winScoreElements,
    );
    roundScoresComputer.taker = taker;

    roundScoresComputer
      ..consume(turn1, orderedPlayers)
      ..consume(turn2, orderedPlayers);

    expect(takerScoreManager.score, equals(3));
    expect(oppositionScoreManager.score, equals(2));
  });

  test('Opposition plays excuse and wins', () {
    final turn = Turn<Card>()
      ..addAction(Card.coloredCard(Suit.diamond, 1))
      ..addAction(Card.coloredCard(Suit.diamond, 2))
      ..addAction(const Card.excuse())
      ..addAction(Card.coloredCard(Suit.diamond, 3));
    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;
    final takerScoreManager = ScoreManager();
    final oppositionScoreManager = ScoreManager();

    //TODO not very satisfying to create an object that is not ready
    final roundScoresComputer = RoundScoresComputer(
      takerScoreManager.winScoreElements,
      oppositionScoreManager.winScoreElements,
    );
    roundScoresComputer.taker = taker;

    roundScoresComputer.consume(turn, orderedPlayers);
    expect(takerScoreManager.score, equals(0));
    expect(oppositionScoreManager.score, equals(6));
  });

  test('Oppotion plays excuse and looses', () {
    final turn = Turn<Card>()
      ..addAction(Card.coloredCard(Suit.diamond, 3))
      ..addAction(Card.coloredCard(Suit.diamond, 2))
      ..addAction(const Card.excuse())
      ..addAction(Card.coloredCard(Suit.diamond, 1));
    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;
    final takerScoreManager = ScoreManager();
    final oppositionScoreManager = ScoreManager();

    //TODO not very satisfying to create an object that is not ready
    final roundScoresComputer = RoundScoresComputer(
      takerScoreManager.winScoreElements,
      oppositionScoreManager.winScoreElements,
    );
    roundScoresComputer.taker = taker;

    roundScoresComputer.consume(turn, orderedPlayers);

    expect(takerScoreManager.score, equals(2));
    expect(oppositionScoreManager.score, equals(4));
  });

  test('Taker plays excuse', () {
    final turn = Turn<Card>()
      ..addAction(const Card.excuse())
      ..addAction(Card.coloredCard(Suit.diamond, 1))
      ..addAction(Card.coloredCard(Suit.diamond, 2))
      ..addAction(Card.coloredCard(Suit.diamond, 3));
    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;
    final takerScoreManager = ScoreManager();
    final oppositionScoreManager = ScoreManager();

    //TODO not very satisfying to create an object that is not ready
    final roundScoresComputer = RoundScoresComputer(
      takerScoreManager.winScoreElements,
      oppositionScoreManager.winScoreElements,
    );
    roundScoresComputer.taker = taker;

    roundScoresComputer.consume(turn, orderedPlayers);

    expect(takerScoreManager.score, equals(4));
    expect(oppositionScoreManager.score, equals(2));
  });
}

CardPhaseAgent _createCardPhaseAgent() {
  // For the sake of this unit test, passing a null hand to the CardPhaseAgent
  // is fine. In reality however, it's important to give the agent a proper
  // instance of Hand.
  return CardPhaseAgent(RandomDecisionMaker<SuitedPlayable>().run, null);
}
