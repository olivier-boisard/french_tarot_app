import 'abstract_card_phase_agent.dart';
import 'actions_handler.dart';
import 'function_interfaces.dart';
import 'playable_score_element.dart';
import 'score_element.dart';

class ScoreComputer {
  final AbstractCardPhaseAgent _taker;
  final Consumer<Iterable<ScoreElement>> _takerScoreElementsConsumer;
  final Consumer<Iterable<ScoreElement>> _oppositionScoreElementsConsumer;

  ScoreComputer(
    this._taker,
    this._takerScoreElementsConsumer,
    this._oppositionScoreElementsConsumer,
  );

  void consume(
    ActionsHandler<PlayableScoreElement> turn,
    List<AbstractCardPhaseAgent> agentsPlayOrder,
  ) {
    final takerWon = _didTakerWin(agentsPlayOrder, turn);
    _dealWinnableScoreElementsToWinner(turn, takerWon);

    final takerScoreElement = _extractTakerPlayedScoreElement(
      turn,
      agentsPlayOrder,
    );
    _handleScoreElements(turn, takerScoreElement, takerWon);
  }

  PlayableScoreElement _extractTakerPlayedScoreElement(
    ActionsHandler<PlayableScoreElement> turn,
    List<AbstractCardPhaseAgent> agentsPlayOrder,
  ) {
    return turn.actionHistory[agentsPlayOrder.indexOf(_taker)];
  }

  bool _didTakerWin(
    List<AbstractCardPhaseAgent> agentsPlayOrder,
    ActionsHandler<PlayableScoreElement> turn,
  ) {
    final winner = agentsPlayOrder[turn.winningActionIndex];
    return winner == _taker;
  }

  void _dealWinnableScoreElementsToWinner(
    ActionsHandler<PlayableScoreElement> turn,
    bool takerWon,
  ) {
    final scoreElements =
        turn.actionHistory.where((element) => element.winnable);
    if (takerWon) {
      _takerScoreElementsConsumer(scoreElements);
    } else {
      _oppositionScoreElementsConsumer(scoreElements);
    }
  }

  void _handleScoreElements(
    ActionsHandler<PlayableScoreElement> turn,
    PlayableScoreElement takerPlayedScoreElement,
    bool takerWon,
  ) {
    final takerPlayedNonWinnable = !takerPlayedScoreElement.winnable;
    final history = turn.actionHistory;
    final playedNonWinnables = history.where((element) => !element.winnable);
    if (playedNonWinnables.isNotEmpty) {
      if (takerWon && !takerPlayedNonWinnable) {
        _oppositionScoreElementsConsumer([NegativeScoreElement()]);
        _takerScoreElementsConsumer([PositiveScoreElement()]);
      } else if (!takerWon && takerPlayedNonWinnable) {
        _oppositionScoreElementsConsumer([PositiveScoreElement()]);
        _takerScoreElementsConsumer([NegativeScoreElement()]);
      }
      final consumer = takerPlayedNonWinnable
          ? _takerScoreElementsConsumer
          : _oppositionScoreElementsConsumer;
      consumer(playedNonWinnables);
    }
  }
}

class PositiveScoreElement implements ScoreElement {
  @override
  double get score => 0.5;

  @override
  bool get isOudler => false;
}

class NegativeScoreElement implements ScoreElement {
  @override
  double get score => -0.5;

  @override
  bool get isOudler => false;
}
