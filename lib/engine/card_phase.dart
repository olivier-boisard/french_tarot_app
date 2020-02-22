import 'behavior.dart';
import 'card.dart';
import 'player.dart';
import 'state.dart';
import 'turn.dart';

class CardPhaseAgent {
  final Player _player;
  final Behavior<CardPhaseState, Card> _behavior;

  CardPhaseAgent(this._player, this._behavior);

  Card act(CardPhaseEnvironmentState environmentState) {
    final hand = _player.hand;
    if (hand.isEmpty) {
      throw EmptyHandException();
    }

    final state = CardPhaseState(environmentState, hand);
    final output = _behavior(state);
    hand.remove(output);
    return output;
  }
}

class CardPhaseEnvironmentState {
  Turn turn;

  CardPhaseEnvironmentState(this.turn);
}

class CardPhaseState implements State<Card> {
  CardPhaseEnvironmentState environmentState;
  List<Card> hand;

  CardPhaseState(this.environmentState, this.hand);

  @override
  List<Card> get allowedActions {
    return environmentState.turn.extractAllowedCards(hand);
  }
}
