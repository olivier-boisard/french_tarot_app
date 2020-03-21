import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card_phase/card_phase_agent.dart';
import 'package:french_tarot/engine/card_phase/one_use_action_handler.dart';
import 'package:french_tarot/engine/card_phase/round.dart';
import 'package:french_tarot/engine/card_phase/score_computer.dart';
import 'package:french_tarot/engine/card_phase/turn.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/core/deck.dart';
import 'package:french_tarot/engine/core/player_score_manager.dart';
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
      final decisionMaker = RandomDecisionMaker<SuitedPlayable>();
      final hand =
          OneUseActionHandler<SuitedPlayable>(deck.pop(nCardsPerPlayer));
      agents.add(CardPhaseAgent(decisionMaker.run, hand));
    }

    final taker = agents[0];
    final dog = deck.pop(nCardsInDog);
    final takerState = PlayerScoreManager()..winScoreElements(dog);
    final oppositionState = PlayerScoreManager();
    final scoreComputer = ScoreComputer(taker, takerState, oppositionState);

    Round(() => Turn(), scoreComputer.consume).play(agents);
    final totalScore = scoreComputer.oppositionScore + scoreComputer.takerScore;
    expect(totalScore, equals(91));
  });

  //TODO add test to make sure winner of one round gets to play first after
}
