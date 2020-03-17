import '../core/abstract_card.dart';
import '../core/card.dart';
import '../core/player_state.dart';
import 'card_phase_agent.dart';
import 'turn.dart';

class ScoreComputer {
  final CardPhaseAgent _taker;
  final PlayerState _takerState;
  final PlayerState _oppositionState;

  ScoreComputer(this._taker)
      : _takerState = PlayerState(),
        _oppositionState = PlayerState();

  int get takerScore => _takerState.score;

  int get oppositionScore => _oppositionState.score;

  void consume(Turn turn, List<CardPhaseAgent> agentsPlayOrder) {
    final takerWon = _didTakerWin(agentsPlayOrder, turn);
    _dealNonExcuseCardsToWinner(turn, takerWon);

    final takerCard = _extractTakerPlayedCard(turn, agentsPlayOrder);
    _handleExcuse(turn, takerCard, takerWon);
  }

  Card _extractTakerPlayedCard(Turn turn,
      List<CardPhaseAgent> agentsPlayOrder) {
    final takerCard = turn.playedCards[agentsPlayOrder.indexOf(_taker)];
    return takerCard;
  }

  bool _didTakerWin(List<CardPhaseAgent> agentsPlayOrder, Turn turn) {
    final winner = agentsPlayOrder[turn.winningCardIndex];
    final takerWon = winner == _taker;
    return takerWon;
  }

  void _dealNonExcuseCardsToWinner(Turn turn, bool takerWon) {
    final playedCardsWithoutExcuse = turn.playedCards.toList()
      ..remove(const Card.excuse());
    if (takerWon) {
      _takerState.winCards(playedCardsWithoutExcuse);
    } else {
      _oppositionState.winCards(playedCardsWithoutExcuse);
    }
  }

  void _handleExcuse(Turn turn, Card takerPlayedCard, bool takerWon) {
    const excuse = Card.excuse();
    if (turn.playedCards.contains(excuse)) {
      final takerPlayedExcuse = takerPlayedCard == excuse;
      if (takerWon && !takerPlayedExcuse) {
        _oppositionState.winCards([NegativeDummyCard(), excuse]);
        _takerState.winCards([PositiveDummyCard()]);
      } else if (!takerWon && takerPlayedExcuse) {
        _oppositionState.winCards([PositiveDummyCard()]);
        _takerState.winCards([NegativeDummyCard(), excuse]);
      }
    }
  }
}

class PositiveDummyCard implements AbstractCard {

  @override
  double get score => 0.5;

  @override
  bool get isOudler => false;
}

class NegativeDummyCard implements AbstractCard {

  @override
  double get score => -0.5;

  @override
  bool get isOudler => false;
}
