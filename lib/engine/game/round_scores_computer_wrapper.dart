import '../core/abstract_agent.dart';
import '../core/actions_handler.dart';
import '../core/function_interfaces.dart';
import '../core/playable_score_element.dart';
import '../core/round_scores_computer.dart';
import '../core/score_element.dart';

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
    Iterable<AbstractAgent> agentsPlayOrder,
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
