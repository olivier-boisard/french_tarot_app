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
import 'core/player_score_manager.dart';
import 'core/selector.dart';
import 'core/suited_playable.dart';

class Application {
  final ConfiguredObject _configuredObject;

  Application(this._configuredObject);

  void run() {
    const randomSeed = 1;
    const nCardsInDog = 6;
    final random = Random(randomSeed);
    final deck = Deck.withRandom(random)..shuffle();

    final agents = _createAgents(deck, nCardsInDog);
    final dog = _createDog(deck, nCardsInDog);
    final takerState = _configuredObject.takerScoreManager
      ..winScoreElements(dog);
    final oppositionState = _configuredObject.oppositionScoreManager;

    final taker = _determineTaker(agents, random);
    final scoreComputer = ScoreComputer(taker, takerState, oppositionState);
    playRound(scoreComputer, agents);

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

    // Propagate earned points
    final earnedPoints = <int>[];
    for (final agent in agents) {
      if (identical(agent, taker)) {
        earnedPoints.add(takerEarnedPoints);
      } else {
        earnedPoints.add(opponentsEarnedPoints);
      }
    }
    _configuredObject.earnedPointsConsumer(earnedPoints);
  }

  void playRound(ScoreComputer scoreComputer, List<AbstractCardPhaseAgent> agents) {
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
      List<Card> cardsInHand = _createDog(deck, nCardsPerAgent);
      final hand = OneUseActionHandler<SuitedPlayable>(cardsInHand);
      agents.add(CardPhaseAgent(agentDecisionMaker, hand));
    }
    return agents;
  }
}

class ConfiguredObject {
  final List<Selector<SuitedPlayable>> agentDecisionMakers;
  final PlayerScoreManager takerScoreManager;
  final PlayerScoreManager oppositionScoreManager;
  final Consumer<List<int>> earnedPointsConsumer;

  ConfiguredObject(this.agentDecisionMakers, this.takerScoreManager,
      this.oppositionScoreManager, this.earnedPointsConsumer);
}

class InvalidAmountOfCardsInDeckException implements Exception {}
