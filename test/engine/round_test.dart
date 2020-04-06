import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/deck.dart';
import 'package:french_tarot/engine/core/round_scores_computer.dart';
import 'package:french_tarot/engine/core/score_manager.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/phases/card/card_phase.dart';
import 'package:french_tarot/engine/phases/card/card_phase_agent.dart';
import 'package:french_tarot/engine/phases/card/turn.dart';
import 'package:french_tarot/engine/random/random_decision_maker.dart';

void main() {
  test('Play round', () {
    final deck = Deck()..shuffle();

    const nPlayers = 4;
    const nCardsInDog = 6;
    final nCardsPerPlayer = (deck.nRemainingCards - nCardsInDog) ~/ nPlayers;

    final agents = <CardPhaseAgent>[];
    for (var i = 0; i < nPlayers; i++) {
      final decisionMaker = RandomDecisionMaker<SuitedPlayable>();
      final hand = deck.pop(nCardsPerPlayer);
      agents.add(CardPhaseAgent(decisionMaker.run, hand));
    }

    final dog = deck.pop(nCardsInDog);
    final takerScoreManager = ScoreManager()..winScoreElements(dog);
    final oppositionScoreManager = ScoreManager();

    //TODO not very satisfying to create an object that is not ready
    final roundScoresComputer = RoundScoresComputer(
      takerScoreManager.winScoreElements,
      oppositionScoreManager.winScoreElements,
    );
    roundScoresComputer.taker = agents[0];

    CardPhase(() => Turn(), roundScoresComputer.consume, agents).run();
    final totalScore = takerScoreManager.score + oppositionScoreManager.score;
    expect(totalScore, equals(91));
  });

  //TODO add test to make sure winner of one round gets to play first after
}
