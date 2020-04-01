import 'dart:math';

import 'card_phase/round.dart';
import 'card_phase/score_computer.dart';
import 'card_phase/turn.dart';
import 'core/abstract_card.dart';
import 'core/abstract_card_phase_agent.dart';
import 'core/function_interfaces.dart';
import 'core/score_manager.dart';
import 'dog_phase/dog_dealer.dart';

class Application {
  final ConfiguredObject _configuredObject;

  Application(this._configuredObject);

  void run() {
    final agents = _configuredObject.agents;

    final biddingResult = _runBiddingPhase(agents);
    _runDogPhase(biddingResult);
    _runCardPhase(biddingResult, agents);
  }

  void _runCardPhase(
    BiddingResult biddingResult,
    List<AbstractCardPhaseAgent> agents,
  ) {
    final scoreComputer = _createScoreComputer(biddingResult.taker);
    _playRound(scoreComputer, agents);
    _distributePoints(agents, biddingResult.taker);
  }

  void _runDogPhase(BiddingResult biddingResult) {
    final takerScoreManager = _configuredObject.takerScoreManager;
    final dog = _configuredObject.dog;
    DogDealer(takerScoreManager).deal(biddingResult, dog);
  }

  void _distributePoints(
    List<AbstractCardPhaseAgent> agents,
    AbstractCardPhaseAgent taker,
  ) {
    final earnedPoints = _computeEarnedPoints(agents, taker);
    _configuredObject.earnedPointsConsumer(earnedPoints);
  }

  ScoreComputer _createScoreComputer(AbstractCardPhaseAgent taker) {
    final scoreComputer = ScoreComputer(
      taker,
      _configuredObject.takerScoreManager,
      _configuredObject.oppositionScoreManager,
    );
    return scoreComputer;
  }

  List<int> _computeEarnedPoints(
    List<AbstractCardPhaseAgent> agents,
    AbstractCardPhaseAgent taker,
  ) {
    final takerState = _configuredObject.takerScoreManager;
    final contract = [56, 51, 41, 36][takerState.nOudlers];
    var takerEarnedPoints = 0;
    var opponentsEarnedPoints = 0;
    final nOpponents = agents.length - 1;
    if (takerState.score >= contract) {
      final basePoint = takerState.score - contract + 25;
      takerEarnedPoints = nOpponents * basePoint;
      opponentsEarnedPoints = -basePoint;
    } else {
      final basePoint = contract - takerState.score + 25;
      takerEarnedPoints = -nOpponents * basePoint;
      opponentsEarnedPoints = basePoint;
    }

    final earnedPoints = <int>[];
    for (final agent in agents) {
      if (identical(agent, taker)) {
        earnedPoints.add(takerEarnedPoints);
      } else {
        earnedPoints.add(opponentsEarnedPoints);
      }
    }
    return earnedPoints;
  }

  void _playRound(
    ScoreComputer scoreComputer,
    List<AbstractCardPhaseAgent> agents,
  ) {
    Round(() => Turn(), scoreComputer.consume).play(agents);
  }

  BiddingResult _runBiddingPhase(List<AbstractCardPhaseAgent> agents) {
    return BiddingResult(
      agents[_configuredObject.random.nextInt(agents.length)],
      Bid.PETITE,
    );
  }
}

class ConfiguredObject {
  final List<AbstractCardPhaseAgent> agents;
  final List<AbstractCard> dog;
  final ScoreManager takerScoreManager;
  final ScoreManager oppositionScoreManager;
  final Consumer<List<int>> earnedPointsConsumer;
  final Random random;

  ConfiguredObject(
    this.agents,
    this.dog,
    this.takerScoreManager,
    this.oppositionScoreManager,
    this.earnedPointsConsumer,
    this.random,
  );
}

class Bid {
  static const PASS = 0;
  static const PETITE = 1;
  static const GUARD = 2;
  static const GUARD_WITHOUT = 3;
  static const GUARD_AGAINST = 4;
}

class InvalidAmountOfCardsInDeckException implements Exception {}
