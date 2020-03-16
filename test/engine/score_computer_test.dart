import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card_phase/card_phase_agent.dart';
import 'package:french_tarot/engine/card_phase/score_computer.dart';
import 'package:french_tarot/engine/card_phase/turn.dart';
import 'package:french_tarot/engine/core/card.dart';
import 'package:french_tarot/engine/random_decision_maker.dart';

void main() {
  test('Evaluate score', () {
    final turn1 = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.diamond, 1))..addPlayedCard(
          Card.coloredCard(Suit.diamond, 2))..addPlayedCard(
          Card.coloredCard(Suit.diamond, 3))..addPlayedCard(
          Card.coloredCard(Suit.diamond, 4));

    final turn2 = Turn()
      ..addPlayedCard(
          Card.coloredCard(Suit.diamond, CardStrengths.jack))..addPlayedCard(
          Card.coloredCard(Suit.diamond, 7))..addPlayedCard(
          Card.coloredCard(Suit.diamond, 6))..addPlayedCard(
          Card.coloredCard(Suit.diamond, 5));

    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayer = [taker] + opposition;

    final scoreComputer = ScoreComputer(taker)
      ..consume(turn1, orderedPlayer)..consume(turn2, orderedPlayer);

    expect(scoreComputer.takerScore, equals(3));
    expect(scoreComputer.oppositionScore, equals(2));
  });

  //TODO test with unknown player

  //TODO handle excuse
}

CardPhaseAgent _createCardPhaseAgent() {
  // For the sake of this unit test, passing a null hand to the CardPhaseAgent
  // is fine. In reality however, it's important to give the agent a proper
  // instance of Hand.
  return CardPhaseAgent(RandomDecisionMaker<Card>().run, null);
}
