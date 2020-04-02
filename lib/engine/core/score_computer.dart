import 'abstract_card_phase_agent.dart';
import 'actions_handler.dart';
import 'playable_score_element.dart';
import 'score_element.dart';
import 'score_manager.dart';

//TODO SOLID
class ScoreComputer {
  final AbstractCardPhaseAgent _taker;
  final ScoreManager _takerScoreManager;
  final ScoreManager _oppositionScoreManager;

  ScoreComputer(
    this._taker,
    this._takerScoreManager,
    this._oppositionScoreManager,
  );

  void consume(ActionsHandler<PlayableScoreElement> turn,
      List<AbstractCardPhaseAgent> agentsPlayOrder) {
    final takerWon = _didTakerWin(agentsPlayOrder, turn);
    _dealWinnableScoreElementsToWinner(turn, takerWon);

    final takerScoreElement =
        _extractTakerPlayedScoreElement(turn, agentsPlayOrder);
    _handleUnwinnables(turn, takerScoreElement, takerWon);
  }

  PlayableScoreElement _extractTakerPlayedScoreElement(
      ActionsHandler<PlayableScoreElement> turn,
      List<AbstractCardPhaseAgent> agentsPlayOrder) {
    return turn.actionHistory[agentsPlayOrder.indexOf(_taker)];
  }

  bool _didTakerWin(List<AbstractCardPhaseAgent> agentsPlayOrder,
      ActionsHandler<PlayableScoreElement> turn) {
    final winner = agentsPlayOrder[turn.winningActionIndex];
    return winner == _taker;
  }

  void _dealWinnableScoreElementsToWinner(
      ActionsHandler<PlayableScoreElement> turn, bool takerWon) {
    final winnables = turn.actionHistory.where((element) => element.winnable);
    if (takerWon) {
      _takerScoreManager.winScoreElements(winnables);
    } else {
      _oppositionScoreManager.winScoreElements(winnables);
    }
  }

  void _handleUnwinnables(ActionsHandler<PlayableScoreElement> turn,
      PlayableScoreElement takerPlayedScoreElement, bool takerWon) {
    final takerPlayedNonWinnable = !takerPlayedScoreElement.winnable;
    final history = turn.actionHistory;
    final playedNonWinnables = history.where((element) => !element.winnable);
    if (playedNonWinnables.isNotEmpty) {
      if (takerWon && !takerPlayedNonWinnable) {
        _oppositionScoreManager.winScoreElements([NegativeScoreElement()]);
        _takerScoreManager.winScoreElements([PositiveScoreElement()]);
      } else if (!takerWon && takerPlayedNonWinnable) {
        _oppositionScoreManager.winScoreElements([PositiveScoreElement()]);
        _takerScoreManager.winScoreElements([NegativeScoreElement()]);
      }
      (takerPlayedNonWinnable ? _takerScoreManager : _oppositionScoreManager)
          .winScoreElements(playedNonWinnables);
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
