import '../core/abstract_card_phase_agent.dart';
import '../core/player_score_manager.dart';
import '../core/score_element.dart';
import 'abstract_score_computer.dart';
import 'actions_handler.dart';
import 'playable_score_element.dart';

class ScoreComputer implements AbstractScoreComputer {
  final AbstractCardPhaseAgent _taker;
  final PlayerScoreManager _takerState;
  final PlayerScoreManager _oppositionState;

  ScoreComputer(this._taker, this._takerState, this._oppositionState);

  @override
  int get takerScore => _takerState.score;

  @override
  int get oppositionScore => _oppositionState.score;

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
      _takerState.winScoreElements(winnables);
    } else {
      _oppositionState.winScoreElements(winnables);
    }
  }

  void _handleUnwinnables(ActionsHandler<PlayableScoreElement> turn,
      PlayableScoreElement takerPlayedScoreElement, bool takerWon) {
    final takerPlayedNonWinnable = !takerPlayedScoreElement.winnable;
    final history = turn.actionHistory;
    final playedNonWinnables = history.where((element) => !element.winnable);
    if (playedNonWinnables.isNotEmpty) {
      if (takerWon && !takerPlayedNonWinnable) {
        _oppositionState.winScoreElements([NegativeScoreElement()]);
        _takerState.winScoreElements([PositiveScoreElement()]);
      } else if (!takerWon && takerPlayedNonWinnable) {
        _oppositionState.winScoreElements([PositiveScoreElement()]);
        _takerState.winScoreElements([NegativeScoreElement()]);
      }
      (takerPlayedNonWinnable ? _takerState : _oppositionState)
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
