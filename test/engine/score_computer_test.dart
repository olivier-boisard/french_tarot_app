import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card_phase/card_phase_agent.dart';
import 'package:french_tarot/engine/card_phase/score_computer.dart';
import 'package:french_tarot/engine/card_phase/turn.dart';
import 'package:french_tarot/engine/core/abstract_card.dart';
import 'package:french_tarot/engine/core/card.dart';
import 'package:french_tarot/engine/core/player_score_manager.dart';
import 'package:french_tarot/engine/random_decision_maker.dart';

void main() {
  test('Evaluate score', () {
    final turn1 = Turn<Card>()
      ..addAction(Card.coloredCard(Suit.diamond, 1))..addAction(
          Card.coloredCard(Suit.diamond, 2))..addAction(
          Card.coloredCard(Suit.diamond, 3))..addAction(
          Card.coloredCard(Suit.diamond, 4));

    final turn2 = Turn<Card>()
      ..addAction(
          Card.coloredCard(Suit.diamond, CardStrengths.jack))..addAction(
          Card.coloredCard(Suit.diamond, 7))..addAction(
          Card.coloredCard(Suit.diamond, 6))..addAction(
          Card.coloredCard(Suit.diamond, 5));

    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayer = [taker] + opposition;

    final scoreComputer = _createScoreComputer(taker)
      ..consume(turn1, orderedPlayer)..consume(turn2, orderedPlayer);

    expect(scoreComputer.takerScore, equals(3));
    expect(scoreComputer.oppositionScore, equals(2));
  });

  test('Opposition plays excuse and wins', () {
    final turn = Turn<Card>()
      ..addAction(Card.coloredCard(Suit.diamond, 1))..addAction(
          Card.coloredCard(Suit.diamond, 2))..addAction(
          Card.excuse())..addAction(Card.coloredCard(Suit.diamond, 3));
    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;

    final scoreComputer = _createScoreComputer(taker)
      ..consume(turn, orderedPlayers);
    expect(scoreComputer.takerScore, equals(0));
    expect(scoreComputer.oppositionScore, equals(6));
  });

  test('Oppotion plays excuse and looses', () {
    final turn = Turn<Card>()
      ..addAction(Card.coloredCard(Suit.diamond, 3))..addAction(
          Card.coloredCard(Suit.diamond, 2))..addAction(
          Card.excuse())..addAction(Card.coloredCard(Suit.diamond, 1));
    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;
    final scoreComputer = _createScoreComputer(taker)
      ..consume(turn, orderedPlayers);

    expect(scoreComputer.takerScore, equals(2));
    expect(scoreComputer.oppositionScore, equals(4));
  });

  test('Taker plays excuse', () {
    final turn = Turn<Card>()
      ..addAction(Card.excuse())..addAction(
          Card.coloredCard(Suit.diamond, 1))..addAction(
          Card.coloredCard(Suit.diamond, 2))..addAction(
          Card.coloredCard(Suit.diamond, 3));
    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayers = [taker] + opposition;
    final scoreComputer = _createScoreComputer(taker)
      ..consume(turn, orderedPlayers);

    expect(scoreComputer.takerScore, equals(4));
    expect(scoreComputer.oppositionScore, equals(2));
  });

}

ScoreComputer _createScoreComputer(CardPhaseAgent taker) {
  final takerState = PlayerScoreManager();
  final oppositionState = PlayerScoreManager();
  final scoreComputer = ScoreComputer(taker, takerState, oppositionState);
  return scoreComputer;
}

CardPhaseAgent _createCardPhaseAgent() {
  // For the sake of this unit test, passing a null hand to the CardPhaseAgent
  // is fine. In reality however, it's important to give the agent a proper
  // instance of Hand.
  return CardPhaseAgent(RandomDecisionMaker<AbstractCard>().run, null);
}
