import 'dart:math';

import 'card_phase/card_phase_agent.dart';
import 'card_phase/one_use_action_handler.dart';
import 'card_phase/round.dart';
import 'card_phase/score_computer.dart';
import 'card_phase/turn.dart';
import 'core/consumer.dart';
import 'core/deck.dart';
import 'core/player_score_manager.dart';
import 'core/suited_playable.dart';
import 'decision_maker.dart';

class Application {
  final ConfiguredObject _configuredObject;

  Application(this._configuredObject);

  void run() {
    const randomSeed = 1;
    final random = Random(randomSeed);

    // Create agents
    final deck = Deck.withRandom(random)..shuffle();
    const nCardsInDog = 6;
    final nPlayers = _configuredObject.agentDecisionMakers.length;
    final nCardsToDealToPlayers = deck.size - nCardsInDog;
    final nCardsPerAgent = nCardsToDealToPlayers ~/ nPlayers;
    if (nCardsToDealToPlayers % nCardsPerAgent != 0) {
      throw InvalidAmountOfCardsInDeckException();
    }
    final agents = <CardPhaseAgent>[];
    for (final agentDecisionMaker in _configuredObject.agentDecisionMakers) {
      final cardsInHand = deck.pop(nCardsPerAgent);
      final hand = OneUseActionHandler<SuitedPlayable>(cardsInHand);
      agents.add(CardPhaseAgent(agentDecisionMaker, hand));
    }
    final dog = deck.pop(nCardsInDog);

    final takerState = _configuredObject.takerScoreManager
      ..winScoreElements(dog);
    final oppositionState = _configuredObject.oppositionScoreManager;

    // Determine taker
    final taker = agents[random.nextInt(agents.length)];

    // Play round
    final scoreComputer = ScoreComputer(taker, takerState, oppositionState);
    Round(() => Turn(), scoreComputer.consume).play(agents);

    // Evaluate earned and lost points per player for this round
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

    // Compute earned points
    final earnedPoints = <int>[];
    for (final agent in agents) {
      if (identical(agent, taker)) {
        earnedPoints.add(takerEarnedPoints);
      } else {
        earnedPoints.add(opponentsEarnedPoints);
      }
    }

    // Consume earned points
    _configuredObject.earnedPointsConsumer(earnedPoints);
  }
}

class ConfiguredObject {
  final List<DecisionMaker<SuitedPlayable>> agentDecisionMakers;
  final PlayerScoreManager takerScoreManager;
  final PlayerScoreManager oppositionScoreManager;
  final Consumer<List<int>> earnedPointsConsumer;

  ConfiguredObject(this.agentDecisionMakers, this.takerScoreManager,
      this.oppositionScoreManager, this.earnedPointsConsumer);
}

class InvalidAmountOfCardsInDeckException implements Exception {}
