import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/application.dart';
import 'package:french_tarot/engine/card_phase/card_phase_agent.dart';
import 'package:french_tarot/engine/card_phase/one_use_action_handler.dart';
import 'package:french_tarot/engine/core/abstract_card_phase_agent.dart';
import 'package:french_tarot/engine/core/deck.dart';
import 'package:french_tarot/engine/core/score_manager.dart';
import 'package:french_tarot/engine/core/selector.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/random_decision_maker.dart';

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
  final decisionMaker = RandomDecisionMaker<SuitedPlayable>.withRandom(
    random,
  ).run;
  final decisionMakers = <Selector<SuitedPlayable>>[];
  for (var i = 0; i < nPlayers; i++) {
    decisionMakers.add(decisionMaker);
  }

  final earnedPoints = <int>[];
  final takerScoreManager = ScoreManager();
  final oppositionScoreManager = ScoreManager();
  final deck = Deck.withRandom(random)..shuffle();
  final dog = deck.pop(nCardsInDog);
  final configuredObject = ConfiguredObject(
      _createAgents(deck, decisionMakers, deck.originalSize - dog.length),
      dog,
      takerScoreManager,
      oppositionScoreManager,
      earnedPoints.addAll,
      random);
  Application(configuredObject).run();
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
