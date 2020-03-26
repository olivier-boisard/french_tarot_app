import 'dart:math';

import 'card_phase/card_phase_agent.dart';
import 'card_phase/one_use_action_handler.dart';
import 'card_phase/round.dart';
import 'card_phase/score_computer.dart';
import 'card_phase/turn.dart';
import 'core/abstract_card_phase_agent.dart';
import 'core/card.dart';
import 'core/deck.dart';
import 'core/function_interfaces.dart';
import 'core/score_manager.dart';
import 'core/selector.dart';
import 'core/suited_playable.dart';

class Application {
  final ConfiguredObject _configuredObject;

  Application(this._configuredObject);

  void run() {
    const randomSeed = 1;
    const nCardsInDog = 6;
    final random = Random(randomSeed);

    final deck = _createDeck(random);
    final agents = _createAgents(deck, nCardsInDog);
    final dog = _createDog(deck, nCardsInDog);

    final taker = _determineTaker(agents, random);
    final oppositionScoreManager = _configuredObject.scoreManagerFactory();
    final takerScoreManager = _configuredObject.scoreManagerFactory()
      ..winScoreElements(dog);
    final scoreComputer = ScoreComputer(
      taker,
      takerScoreManager,
      oppositionScoreManager,
    );
    _playRound(scoreComputer, agents);
    final earnedPoints = _computeEarnedPoints(takerScoreManager, agents, taker);

    _configuredObject.earnedPointsConsumer(earnedPoints);
  }

  Deck _createDeck(Random random) {
    return Deck.withRandom(random)..shuffle();
  }

  List<int> _computeEarnedPoints(
    ScoreManager takerState,
    List<AbstractCardPhaseAgent> agents,
    AbstractCardPhaseAgent taker,
  ) {
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

  AbstractCardPhaseAgent _determineTaker(
      List<AbstractCardPhaseAgent> agents, Random random) {
    final taker = agents[random.nextInt(agents.length)];
    return taker;
  }

  List<Card> _createDog(Deck deck, int nCardsInDog) {
    final dog = deck.pop(nCardsInDog);
    return dog;
  }

  List<AbstractCardPhaseAgent> _createAgents(Deck deck, int nCardsInDog) {
    final nPlayers = _configuredObject.agentDecisionMakers.length;
    final nCardsToDealToPlayers = deck.size - nCardsInDog;
    final nCardsPerAgent = nCardsToDealToPlayers ~/ nPlayers;
    if (nCardsToDealToPlayers % nCardsPerAgent != 0) {
      throw InvalidAmountOfCardsInDeckException();
    }
    final agents = <AbstractCardPhaseAgent>[];
    for (final agentDecisionMaker in _configuredObject.agentDecisionMakers) {
      final cardsInHand = _createDog(deck, nCardsPerAgent);
      final hand = OneUseActionHandler<SuitedPlayable>(cardsInHand);
      agents.add(CardPhaseAgent(agentDecisionMaker, hand));
    }
    return agents;
  }
}

class ConfiguredObject {
  final List<Selector<SuitedPlayable>> agentDecisionMakers;
  final Factory<ScoreManager> scoreManagerFactory;
  final Consumer<List<int>> earnedPointsConsumer;

  ConfiguredObject(
    this.agentDecisionMakers,
    this.scoreManagerFactory,
    this.earnedPointsConsumer,
  );
}

class InvalidAmountOfCardsInDeckException implements Exception {}
