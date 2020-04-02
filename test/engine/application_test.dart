import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/application.dart';
import 'package:french_tarot/engine/core/abstract_card_phase_agent.dart';
import 'package:french_tarot/engine/core/deck.dart';
import 'package:french_tarot/engine/core/function_interfaces.dart';
import 'package:french_tarot/engine/core/one_use_action_handler.dart';
import 'package:french_tarot/engine/core/score_manager.dart';
import 'package:french_tarot/engine/core/selector.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/phases/card/card_phase.dart';
import 'package:french_tarot/engine/phases/card/card_phase_agent.dart';
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
  final biddingPhase = RandomBiddingPhase.withRandom(agents, random);
  final dogPhase = DogPhase(dog, takerScoreManager);
  final cardPhase = CardPhase(
    agents,
    takerScoreManager,
    oppositionScoreManager,
  );

  // Wiring
  biddingPhase.biddingResultsConsumers = [
    (biddingResult) => {dogPhase.biddingResult = biddingResult},
    (biddingResult) => {cardPhase.biddingResult = biddingResult},
  ];
  cardPhase.earnedPointsConsumers = [earnedPoints.addAll];

  // Prepare process list
  final processes = <Process>[
    biddingPhase.run,
    dogPhase.run,
    cardPhase.run,
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
    final cardsInHand = deck.pop(nCardsPerAgent);
    final hand = OneUseActionHandler<SuitedPlayable>(cardsInHand);
    agents.add(CardPhaseAgent(decisionMaker, hand));
  }
  return agents;
}

class InvalidAmountOfCardsInDeckException implements Exception {}
