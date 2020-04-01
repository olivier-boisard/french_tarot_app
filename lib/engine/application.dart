import 'dart:math';

import 'card_phase/round.dart';
import 'card_phase/score_computer.dart';
import 'card_phase/turn.dart';
import 'core/abstract_card.dart';
import 'core/abstract_card_phase_agent.dart';
import 'core/function_interfaces.dart';
import 'core/score_manager.dart';
import 'dog_phase/bidding_result.dart';

class RandomBiddingPhase {
  final List<AbstractCardPhaseAgent> _agents;
  final Random _random;
  List<Consumer<BiddingResult>> biddingResultsConsumers;

  RandomBiddingPhase(this._agents) : _random = Random();

  RandomBiddingPhase.withRandom(this._agents, this._random);

  void run() {
    final result = BiddingResult(
      _agents[_random.nextInt(_agents.length)],
      Bid.PETITE,
    );
    _notifyConsumers(result);
  }

  void _notifyConsumers(BiddingResult result) {
    if (biddingResultsConsumers != null) {
      for (final consumer in biddingResultsConsumers) {
        consumer(result);
      }
    }
  }
}

class DogPhase {
  final List<AbstractCard> _dog;
  final ScoreManager _takerScoreManager;
  BiddingResult biddingResult;

  DogPhase(this._dog, this._takerScoreManager);

  void run() {
    _takerScoreManager.winScoreElements(_dog);
  }
}

class CardPhase {
  final List<AbstractCardPhaseAgent> _agents;
  final ScoreManager _takerScoreManager;
  final ScoreManager _oppositionScoreManager;
  List<Consumer<List<int>>> earnedPointsConsumers;
  BiddingResult biddingResult;

  CardPhase(this._agents,
      this._takerScoreManager,
      this._oppositionScoreManager,);

  void run() {
    final scoreComputer = _createScoreComputer(biddingResult.taker);
    _playRound(scoreComputer, _agents);
    _distributePoints(_agents, biddingResult.taker);
  }

  void _playRound(ScoreComputer scoreComputer,
      List<AbstractCardPhaseAgent> agents,) {
    Round(() => Turn(), scoreComputer.consume).play(agents);
  }

  void _distributePoints(
    List<AbstractCardPhaseAgent> agents,
    AbstractCardPhaseAgent taker,
  ) {
    final earnedPoints = _computeEarnedPoints(agents, taker);
    _notifyConsumers(earnedPoints);
  }

  void _notifyConsumers(List<int> values) {
    if (earnedPointsConsumers != null) {
      for (final consumer in earnedPointsConsumers) {
        consumer(values);
      }
    }
  }

  ScoreComputer _createScoreComputer(AbstractCardPhaseAgent taker) {
    return ScoreComputer(taker, _takerScoreManager, _oppositionScoreManager);
  }

  List<int> _computeEarnedPoints(
    List<AbstractCardPhaseAgent> agents,
    AbstractCardPhaseAgent taker,
  ) {
    final contract = [56, 51, 41, 36][_takerScoreManager.nOudlers];
    var takerEarnedPoints = 0;
    var opponentsEarnedPoints = 0;
    final nOpponents = agents.length - 1;
    final score = _takerScoreManager.score;
    if (score >= contract) {
      final basePoint = score - contract + 25;
      takerEarnedPoints = nOpponents * basePoint;
      opponentsEarnedPoints = -basePoint;
    } else {
      final basePoint = contract - score + 25;
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
}


class Application {
  final ConfiguredObject _configuredObject;

  Application(this._configuredObject);

  void run() {
    //TODO externalize object creation and wiring
    final agents = _configuredObject.agents;

    final biddingPhase = RandomBiddingPhase.withRandom(
      agents,
      _configuredObject.random,
    );
    final dogPhase = DogPhase(
      _configuredObject.dog,
      _configuredObject.takerScoreManager,
    );
    final cardPhase = CardPhase(
      agents,
      _configuredObject.takerScoreManager,
      _configuredObject.oppositionScoreManager,
    );

    biddingPhase.biddingResultsConsumers = [
          (biddingResult) => {dogPhase.biddingResult = biddingResult},
          (biddingResult) => {cardPhase.biddingResult = biddingResult},
    ];
    cardPhase.earnedPointsConsumers = [ _configuredObject.earnedPointsConsumer];

    final processes = <Process>[
      biddingPhase.run,
      dogPhase.run,
      cardPhase.run,
    ];

    for (final process in processes) {
      process();
    }
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
