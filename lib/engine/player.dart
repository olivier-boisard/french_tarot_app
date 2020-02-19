import 'behavior.dart';
import 'card.dart';
import 'state.dart';
import 'turn.dart';


class Player {
  final List<Card> _wonCards = [];
  final List<Card> _hand = [];
  final Behavior<_CardPhaseState, Card> playerBehavior;

  Player(this.playerBehavior);

  int get score {
    if (_wonCards.length % 2 == 1) {
      throw OddNumberOfCardsException();
    }
    var score = 0.0;
    for (final card in _wonCards) {
      score += card.score;
    }
    return score.round();
  }

  int get numberOfOudlers {
    var numberOfOudlers = 0;
    for (final card in _wonCards) {
      if (card.isOudler) {
        numberOfOudlers += 1;
      }
    }
    return numberOfOudlers;
  }

  void winCards(Iterable<Card> wonCards) {
    _wonCards.addAll(wonCards);
  }

  void deal(Iterable<Card> hand) {
    _hand.addAll(hand);
  }

  Card play(EnvironmentState environmentState) {
    if (_hand.isEmpty) {
      throw EmptyHandException();
    }

    final state = _CardPhaseState(environmentState, _hand);
    final output = playerBehavior(state, state.allowedActions);
    _hand.remove(output);
    return output;
  }
}

//TODO Player and _CardPhaseState should depend on a abstraction of this
class EnvironmentState {
  Turn turn;

  EnvironmentState(this.turn);
}

class EmptyHandException implements Exception {}

class OddNumberOfCardsException implements Exception {}

class _CardPhaseState implements State<Card> {
  EnvironmentState environmentState;
  List<Card> hand;

  _CardPhaseState(this.environmentState, this.hand);

  @override
  List<Card> get allowedActions {
    return environmentState.turn.extractAllowedCards(hand);
  }
}
