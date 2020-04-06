import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/application.dart';
import 'package:french_tarot/engine/core/abstract_card_phase_agent.dart';
import 'package:french_tarot/engine/core/deck.dart';
import 'package:french_tarot/engine/core/function_interfaces.dart';
import 'package:french_tarot/engine/core/round_scores_computer.dart';
import 'package:french_tarot/engine/core/score_manager.dart';
import 'package:french_tarot/engine/core/selector.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/phases/card/card_phase.dart';
import 'package:french_tarot/engine/phases/card/card_phase_agent.dart';
import 'package:french_tarot/engine/phases/card/earned_points_computer.dart';
import 'package:french_tarot/engine/phases/card/turn.dart';
import 'package:french_tarot/engine/phases/dog/dog_phase.dart';
import 'package:french_tarot/engine/random/random_bidding_phase.dart';
import 'package:french_tarot/engine/random/random_decision_maker.dart';

void main() {
  test('Run application', () {
    const minAbsEarnedScore = 25;
    final earnedPoints = runApplication();

    expect(earnedPoints[0].abs(), greaterThanOrEqualTo(minAbsEarnedScore));
    expect(earnedPoints.reduce((a, b) => a + b), equals(0));
  });

  test('Test results reproducibility', () {
    final earnedPoints = runApplication();
    const nRepetitions = 10;
    for (var i = 0; i < nRepetitions; i++) {
      expect(runApplication(), equals(earnedPoints));
    }
  });
}

List<int> runApplication() {
  const randomSeed = 1;
  const nPlayers = 4;
  const nCardsInDog = 6;

  final random = Random(randomSeed);
  final earnedPoints = <int>[];

  // Create decision makers
  final decisionMaker = RandomDecisionMaker<SuitedPlayable>.withRandom(
    random,
  ).run;
  final decisionMakers = <Selector<SuitedPlayable>>[];
  for (var i = 0; i < nPlayers; i++) {
    decisionMakers.add(decisionMaker);
  }

  // Create agents
  final deck = Deck.withRandom(random)..shuffle();
  final dog = deck.pop(nCardsInDog);
  final nCardsToDeal = deck.originalSize - dog.length;
  final agents = _createAgents(deck, decisionMakers, nCardsToDeal);

  // Create phases
  final takerScoreManager = ScoreManager();
  final oppositionScoreManager = ScoreManager();
  final roundScoresComputer = RoundScoresComputer(
    takerScoreManager.winScoreElements,
    oppositionScoreManager.winScoreElements,
  );
  final biddingPhase = RandomBiddingPhase.withRandom(agents, random);
  final dogPhase = DogPhase(dog, takerScoreManager.winScoreElements);

  final cardPhase = CardPhase(
    () => Turn(),
    roundScoresComputer.consume,
    agents,
  );
  final earnedPointsComputer = EarnedPointsComputer(agents, takerScoreManager);

  // Wiring
  biddingPhase.biddingResultsConsumers = [
    (biddingResult) => {dogPhase.biddingResult = biddingResult},
    (biddingResult) => {roundScoresComputer.taker = biddingResult.taker},
    (biddingResult) => {earnedPointsComputer.biddingResult = biddingResult},
  ];
  earnedPointsComputer.earnedPointsConsumers = [earnedPoints.addAll];

  // Prepare process list
  final processes = <Process>[
    biddingPhase.run,
    dogPhase.run,
    cardPhase.run,
    earnedPointsComputer.run,
  ];

  // Create and run application
  Application(processes).run();

  return earnedPoints;
}

List<AbstractCardPhaseAgent> _createAgents(Deck deck,
    List<Selector<SuitedPlayable>> decisionMakers, int nCardsToDeal) {
  final nCardsPerAgent = nCardsToDeal ~/ decisionMakers.length;
  if (nCardsToDeal % nCardsPerAgent != 0) {
    throw InvalidAmountOfCardsInDeckException();
  }
  final agents = <AbstractCardPhaseAgent>[];
  for (final decisionMaker in decisionMakers) {
    final handCards = deck.pop(nCardsPerAgent);
    agents.add(CardPhaseAgent(decisionMaker, handCards));
  }
  return agents;
}

class InvalidAmountOfCardsInDeckException implements Exception {}
