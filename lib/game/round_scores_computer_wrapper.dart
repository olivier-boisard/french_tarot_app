import '../engine/core/abstract_agent.dart';
import '../engine/core/actions_handler.dart';
import '../engine/core/function_interfaces.dart';
import '../engine/core/playable_score_element.dart';
import '../engine/core/round_scores_computer.dart';
import '../engine/core/score_element.dart';

class RoundScoresComputerWrapper {
  AbstractAgent taker;
  final Consumer<Iterable<ScoreElement>> _takerScoreElementsConsumer;
  final Consumer<Iterable<ScoreElement>> _oppositionScoreElementsConsumer;

  RoundScoresComputerWrapper(
    this._takerScoreElementsConsumer,
    this._oppositionScoreElementsConsumer,
  );

  void consume(
    ActionsHandler<PlayableScoreElement> turn,
    List<AbstractAgent> agentsPlayOrder,
  ) {
    if (identical(taker, null)) {
      throw UnsetTakerException();
    }
    RoundScoresComputer(
      taker,
      _takerScoreElementsConsumer,
      _oppositionScoreElementsConsumer,
    ).consume(turn, agentsPlayOrder);
  }
}

class UnsetTakerException implements Exception {}
