import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/application.dart';
import 'package:french_tarot/engine/core/player_score_manager.dart';
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

  final random = Random(randomSeed);
  final decisionMaker =
      RandomDecisionMaker<SuitedPlayable>.withRandom(random).run;
  final agentDecisionMakers = <Selector<SuitedPlayable>>[];
  for (var i = 0; i < nPlayers; i++) {
    agentDecisionMakers.add(decisionMaker);
  }

  final takerScoreManager = PlayerScoreManager();
  final oppositionScoreManager = PlayerScoreManager();
  final earnedPoints = <int>[];
  final configuredObject = ConfiguredObject(
    agentDecisionMakers,
    takerScoreManager,
    oppositionScoreManager,
    earnedPoints.addAll,
  );
  Application(configuredObject).run();
  return earnedPoints;
}
