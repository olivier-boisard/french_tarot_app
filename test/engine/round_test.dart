import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/deck.dart';
import 'package:french_tarot/engine/core/one_use_action_handler.dart';
import 'package:french_tarot/engine/core/score_computer.dart';
import 'package:french_tarot/engine/core/score_manager.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/phases/card/card_phase_agent.dart';
import 'package:french_tarot/engine/phases/card/round.dart';
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
      final handCards = deck.pop(nCardsPerPlayer);
      final hand = OneUseActionHandler<SuitedPlayable>(handCards);
      agents.add(CardPhaseAgent(decisionMaker.run, hand));
    }

    final taker = agents[0];
    final dog = deck.pop(nCardsInDog);
    final takerState = ScoreManager()..winScoreElements(dog);
    final oppositionState = ScoreManager();
    final scoreComputer = ScoreComputer(taker, takerState, oppositionState);

    final round = Round(() => Turn(), scoreComputer.consume);
    round.play(agents);
    final totalScore = scoreComputer.oppositionScore + scoreComputer.takerScore;
    expect(totalScore, equals(91));
  });

  //TODO add test to make sure winner of one round gets to play first after
}
