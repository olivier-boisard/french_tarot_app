import 'action.dart';
import 'card.dart';
import 'state.dart';
import 'turn.dart';

typedef Behavior<A> = A Function(State state);

class CardPhaseAgent {
  final List<Card> _hand;
  final Behavior<Action<Card>> _behavior;

  CardPhaseAgent(this._hand, this._behavior);

  Action<Card> act(CardPhaseEnvironmentState environmentState) {
    if (_hand.isEmpty) {
      throw EmptyHandException();
    }

    final state = CardPhaseState(environmentState, _hand);
    final output = _behavior(state);
    _hand.remove(output.value);
    return output;
  }
}

class CardPhaseEnvironmentState {
  Turn turn;

  CardPhaseEnvironmentState(this.turn);
}

class CardPhaseState implements State<Card> {
  CardPhaseEnvironmentState _environmentState;
  List<Card> _hand;

  CardPhaseState(this._environmentState, this._hand);

  @override
  List<Card> get allowedActions {
    return _environmentState.turn.extractAllowedCards(_hand);
  }
}

class EmptyHandException implements Exception {}
