import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card_phase/card_phase_agent.dart';
import 'package:french_tarot/engine/card_phase/hand.dart';
import 'package:french_tarot/engine/card_phase/round.dart';
import 'package:french_tarot/engine/card_phase/score_computer.dart';
import 'package:french_tarot/engine/core/abstract_card.dart';
import 'package:french_tarot/engine/core/deck.dart';
import 'package:french_tarot/engine/core/player_state.dart';
import 'package:french_tarot/engine/random_decision_maker.dart';

void main() {
  test('Play round', () {
    final deck = Deck();
    const nPlayers = 4;
    const nCardsInDog = 6;
    final nCardsPerPlayer = (deck.size - nCardsInDog) ~/ nPlayers;

    deck.shuffle();

    final agents = <CardPhaseAgent>[];
    for (var i = 0; i < nPlayers; i++) {
      final decisionMaker = RandomDecisionMaker<AbstractCard>();
      final hand = Hand<AbstractCard>(deck.pop(nCardsPerPlayer));
      agents.add(CardPhaseAgent(decisionMaker.run, hand));
    }

    final taker = agents[0];
    final dog = deck.pop(nCardsInDog);
    final takerState = PlayerState()
      ..winScoreElements(dog);
    final oppositionState = PlayerState();
    final scoreComputer = ScoreComputer(taker, takerState, oppositionState);

    Round(scoreComputer.consume).play(agents);
    final totalScore = scoreComputer.oppositionScore + scoreComputer.takerScore;
    expect(totalScore, equals(91));
  });


  //TODO add test to make sure winner of one round gets to play first after
}
