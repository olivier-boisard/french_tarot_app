import '../core/abstract_score_element.dart';
import '../core/card.dart';
import '../core/player_state.dart';
import 'abstract_turn.dart';
import 'card_phase_agent.dart';

class ScoreComputer {
  final CardPhaseAgent _taker;
  final PlayerState _takerState;
  final PlayerState _oppositionState;

  ScoreComputer(this._taker, this._takerState, this._oppositionState);

  int get takerScore => _takerState.score;

  int get oppositionScore => _oppositionState.score;

  void consume(AbstractTurn<ScoreElement> turn,
      List<CardPhaseAgent> agentsPlayOrder) {
    final takerWon = _didTakerWin(agentsPlayOrder, turn);
    _dealNonExcuseCardsToWinner(turn, takerWon);

    final takerCard = _extractTakerPlayedCard(turn, agentsPlayOrder);
    _handleExcuse(turn, takerCard, takerWon);
  }

  Card _extractTakerPlayedCard(AbstractTurn<ScoreElement> turn,
      List<CardPhaseAgent> agentsPlayOrder) {
    return turn.playedCards[agentsPlayOrder.indexOf(_taker)];
  }

  bool _didTakerWin(List<CardPhaseAgent> agentsPlayOrder,
      AbstractTurn<ScoreElement> turn) {
    final winner = agentsPlayOrder[turn.winningCardIndex];
    return winner == _taker;
  }

  void _dealNonExcuseCardsToWinner(AbstractTurn<ScoreElement> turn,
      bool takerWon) {
    final playedCardsWithoutExcuse = turn.playedCards.toList()
      ..remove(const Card.excuse());
    if (takerWon) {
      _takerState.winScoreElements(playedCardsWithoutExcuse);
    } else {
      _oppositionState.winScoreElements(playedCardsWithoutExcuse);
    }
  }

  void _handleExcuse(AbstractTurn<ScoreElement> turn, Card takerPlayedCard,
      bool takerWon) {
    const excuse = Card.excuse();
    final takerPlayedExcuse = takerPlayedCard == excuse;
    if (turn.playedCards.contains(excuse)) {
      if (takerWon && !takerPlayedExcuse) {
        _oppositionState.winScoreElements([NegativeDummyCard()]);
        _takerState.winScoreElements([PositiveDummyCard()]);
      } else if (!takerWon && takerPlayedExcuse) {
        _oppositionState.winScoreElements([PositiveDummyCard()]);
        _takerState.winScoreElements([NegativeDummyCard()]);
      }
      (takerPlayedExcuse ? _takerState : _oppositionState).winScoreElements(
          [excuse]);
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
