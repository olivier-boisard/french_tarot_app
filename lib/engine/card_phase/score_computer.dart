import '../core/abstract_score_element.dart';
import '../core/card.dart';
import '../core/player_score_manager.dart';
import 'actions_handler.dart';
import 'card_phase_agent.dart';

//TODO break dependency with Card (in particular with Excuse)
class ScoreComputer {
  final CardPhaseAgent _taker;
  final PlayerScoreManager _takerState;
  final PlayerScoreManager _oppositionState;

  ScoreComputer(this._taker, this._takerState, this._oppositionState);

  int get takerScore => _takerState.score;

  int get oppositionScore => _oppositionState.score;

  void consume(
      ActionsHandler<ScoreElement> turn, List<CardPhaseAgent> agentsPlayOrder) {
    final takerWon = _didTakerWin(agentsPlayOrder, turn);
    _dealNonExcuseCardsToWinner(turn, takerWon);

    final takerCard = _extractTakerPlayedCard(turn, agentsPlayOrder);
    _handleExcuse(turn, takerCard, takerWon);
  }

  Card _extractTakerPlayedCard(
      ActionsHandler<ScoreElement> turn, List<CardPhaseAgent> agentsPlayOrder) {
    return turn.actions[agentsPlayOrder.indexOf(_taker)];
  }

  bool _didTakerWin(
      List<CardPhaseAgent> agentsPlayOrder, ActionsHandler<ScoreElement> turn) {
    final winner = agentsPlayOrder[turn.winningActionIndex];
    return winner == _taker;
  }

  void _dealNonExcuseCardsToWinner(
      ActionsHandler<ScoreElement> turn, bool takerWon) {
    final playedCardsWithoutExcuse = turn.actions.toList()
      ..remove(const Card.excuse());
    if (takerWon) {
      _takerState.winScoreElements(playedCardsWithoutExcuse);
    } else {
      _oppositionState.winScoreElements(playedCardsWithoutExcuse);
    }
  }

  void _handleExcuse(
      ActionsHandler<ScoreElement> turn, Card takerPlayedCard, bool takerWon) {
    const excuse = Card.excuse();
    final takerPlayedExcuse = takerPlayedCard == excuse;
    if (turn.actions.contains(excuse)) {
      if (takerWon && !takerPlayedExcuse) {
        _oppositionState.winScoreElements([NegativeDummyCard()]);
        _takerState.winScoreElements([PositiveDummyCard()]);
      } else if (!takerWon && takerPlayedExcuse) {
        _oppositionState.winScoreElements([PositiveDummyCard()]);
        _takerState.winScoreElements([NegativeDummyCard()]);
      }
      (takerPlayedExcuse ? _takerState : _oppositionState)
          .winScoreElements([excuse]);
    }
  }
}

class PositiveDummyCard implements ScoreElement {
  @override
  double get score => 0.5;

  @override
  bool get isOudler => false;
}

class NegativeDummyCard implements ScoreElement {
  @override
  double get score => -0.5;

  @override
  bool get isOudler => false;
}
