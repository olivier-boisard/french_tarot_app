import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card_phase/card_phase_agent.dart';
import 'package:french_tarot/engine/card_phase/score_computer.dart';
import 'package:french_tarot/engine/card_phase/turn.dart';
import 'package:french_tarot/engine/core/card.dart';
import 'package:french_tarot/engine/random_decision_maker.dart';

void main() {
  test('Evaluate score', () {
    final turn1 = Turn();
    turn1.addPlayedCard(Card.coloredCard(Suit.diamond, 1));
    turn1.addPlayedCard(Card.coloredCard(Suit.diamond, 2));
    turn1.addPlayedCard(Card.coloredCard(Suit.diamond, 3));
    turn1.addPlayedCard(Card.coloredCard(Suit.diamond, 4));

    final turn2 = Turn();
    turn2.addPlayedCard(Card.coloredCard(Suit.diamond, CardStrengths.jack));
    turn2.addPlayedCard(Card.coloredCard(Suit.diamond, 7));
    turn2.addPlayedCard(Card.coloredCard(Suit.diamond, 6));
    turn2.addPlayedCard(Card.coloredCard(Suit.diamond, 5));

    final taker = _createCardPhaseAgent();
    final opposition = [
      _createCardPhaseAgent(),
      _createCardPhaseAgent(),
      _createCardPhaseAgent()
    ];
    final orderedPlayer = [taker] + opposition;

    final scoreComputer = ScoreComputer(taker);
    scoreComputer..consume(turn1, orderedPlayer)..consume(turn2, orderedPlayer);

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
