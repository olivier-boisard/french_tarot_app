import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/abstract_agent.dart';
import 'package:french_tarot/engine/core/abstract_card.dart';
import 'package:french_tarot/engine/core/function_interfaces.dart';
import 'package:french_tarot/engine/core/score_manager.dart';
import 'package:french_tarot/engine/core/selector.dart';
import 'package:french_tarot/engine/core/tarot_deck_facade.dart';
import 'package:french_tarot/engine/phases/card/card_phase.dart';
import 'package:french_tarot/engine/phases/card/card_phase_agent.dart';
import 'package:french_tarot/engine/phases/card/card_phase_turn.dart';
import 'package:french_tarot/engine/phases/card/earned_points_computer.dart';
import 'package:french_tarot/engine/phases/dog/dog_phase.dart';
import 'package:french_tarot/engine/random/random_bidding_phase.dart';
import 'package:french_tarot/engine/random/random_decision_maker.dart';
import 'package:french_tarot/game/round_scores_computer_wrapper.dart';

void main() {
  test('Run application', () {
    const minAbsEarnedScore = 25;
    final earnedPoints = runApplication();

    expect(earnedPoints.first.abs(), greaterThanOrEqualTo(minAbsEarnedScore));
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
  final decisionMaker = RandomDecisionMaker<AbstractCard>.withRandom(
    random,
  ).run;
  final decisionMakers = <Selector<AbstractCard>>[];
  for (var i = 0; i < nPlayers; i++) {
    decisionMakers.add(decisionMaker);
  }

  // Create agents
  final deck = TarotDeckFacade.withRandom(random)..shuffle();
  final dog = deck.pop(nCardsInDog);
  final nCardsToDeal = deck.originalSize - dog.length;
  final agents = _createCardAgents(deck, decisionMakers, nCardsToDeal);

  // Create phases
  final takerScoreManager = ScoreManager();
  final oppositionScoreManager = ScoreManager();
  final roundScoresComputerWrapper = RoundScoresComputerWrapper(
    takerScoreManager.winScoreElements,
    oppositionScoreManager.winScoreElements,
  );
  final biddingPhase = RandomBiddingPhase.withRandom(agents, random);
  final dogPhase = DogPhase(dog, takerScoreManager.winScoreElements);

  final cardPhase = CardPhase(
    () => CardPhaseTurn(),
    roundScoresComputerWrapper.consume,
    agents,
  );
  final earnedPointsComputer = EarnedPointsComputer(agents, takerScoreManager);

  // Wiring
  biddingPhase.biddingResultsConsumers = [
    (biddingResult) => {dogPhase.biddingResult = biddingResult},
    (biddingResult) => {roundScoresComputerWrapper.taker = biddingResult.taker},
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

List<AbstractAgent<AbstractCard>> _createCardAgents(
  TarotDeckFacade deck,
  List<Selector<AbstractCard>> decisionMakers,
  int nCardsToDeal,
) {
  final nCardsPerAgent = nCardsToDeal ~/ decisionMakers.length;
  if (nCardsToDeal % nCardsPerAgent != 0) {
    throw InvalidAmountOfCardsInDeckException();
  }
  final agents = <AbstractAgent<AbstractCard>>[];
  for (final decisionMaker in decisionMakers) {
    final hand = deck.pop(nCardsPerAgent);
    agents.add(CardPhaseAgent(decisionMaker, hand));
  }
  return agents;
}

class InvalidAmountOfCardsInDeckException implements Exception {}
