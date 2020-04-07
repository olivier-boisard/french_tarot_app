import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/card.dart';
import 'package:french_tarot/engine/core/decision.dart';
import 'package:french_tarot/engine/core/round_scores_computer.dart';
import 'package:french_tarot/engine/core/score_manager.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/core/tarot_deck_facade.dart';
import 'package:french_tarot/engine/phases/card/card_phase.dart';
import 'package:french_tarot/engine/phases/card/card_phase_agent.dart';
import 'package:french_tarot/engine/phases/card/turn.dart';
import 'package:french_tarot/engine/random/random_card_phase_agent_facade.dart';

void main() {
  test('Play round', () {
    final deck = TarotDeckFacade()..shuffle();

    const nPlayers = 4;
    const nCardsInDog = 6;
    final nCardsPerPlayer = (deck.nRemainingCards - nCardsInDog) ~/ nPlayers;

    final agents = <CardPhaseAgent>[];
    for (var i = 0; i < nPlayers; i++) {
      final hand = deck.pop(nCardsPerPlayer);
      agents.add(RandomCardPhaseAgentFacade(hand));
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
  test('Winner plays first next round', () {
    final agents = [
      CardPhaseAgent(pickFirst, [
        Card.coloredCard(Suit.spades, 1),
        Card.coloredCard(Suit.spades, 2),
      ]),
      CardPhaseAgent(pickFirst, [
        Card.coloredCard(Suit.spades, 3),
        Card.coloredCard(Suit.heart, 1),
      ])
    ];

    final takerScoreManager = ScoreManager();
    final oppositionScoreManager = ScoreManager();

    //TODO not very satisfying to create an object that is not ready
    final roundScoresComputer = RoundScoresComputer(
      takerScoreManager.winScoreElements,
      oppositionScoreManager.winScoreElements,
    );
    roundScoresComputer.taker = agents[0];

    CardPhase(() => Turn(), roundScoresComputer.consume, agents).run();

    expect(takerScoreManager, equals(0));
    expect(oppositionScoreManager, equals(1));
  });
}

Decision<SuitedPlayable> pickFirst(List<SuitedPlayable> allowedActions) {
  const probability = 1.0;
  return Decision(probability, allowedActions.first);
}
