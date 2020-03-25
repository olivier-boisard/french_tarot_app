import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/application.dart';
import 'package:french_tarot/engine/core/player_score_manager.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/decision_maker.dart';
import 'package:french_tarot/engine/random_decision_maker.dart';

void main() {
  test('Run application', () {
    const randomSeed = 1;
    const minAbsEarnedScore = 25;
    const nPlayers = 4;

    final random = Random(randomSeed);
    final decisionMaker =
        RandomDecisionMaker<SuitedPlayable>.withRandom(random).run;
    final agentDecisionMakers = <DecisionMaker<SuitedPlayable>>[];
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

    expect(earnedPoints[0].abs(), greaterThanOrEqualTo(minAbsEarnedScore));
    expect(earnedPoints.reduce((a, b) => a + b), equals(0));
  });
}
