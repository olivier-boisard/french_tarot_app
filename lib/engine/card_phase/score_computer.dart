import 'package:french_tarot/engine/card_phase/card_phase_agent.dart';
import 'package:french_tarot/engine/core/player_state.dart';

import 'turn.dart';

class ScoreComputer {
  CardPhaseAgent _taker;
  PlayerState _takerState;
  PlayerState _oppositionState;

  ScoreComputer(this._taker)
      : _takerState = PlayerState(),
        _oppositionState = PlayerState();

  int get takerScore => _takerState.score;

  int get oppositionScore => _oppositionState.score;

  void consume(Turn turn, List<CardPhaseAgent> agentsPlayOrder) {
    final winner = agentsPlayOrder[turn.winningCardIndex];
    final playedCards = turn.playedCards;
    if (winner == _taker) {
      _takerState.winCards(playedCards);
    } else {
      _oppositionState.winCards(playedCards);
    }
  }
}
