import 'behavior.dart';
import 'card.dart';
import 'state.dart';
import 'turn.dart';

class CardPhaseAgent {
  final List<Card> _hand;
  final Behavior<CardPhaseState, Card> _behavior;

  CardPhaseAgent(this._hand, this._behavior);

  Card act(CardPhaseEnvironmentState environmentState) {
    if (_hand.isEmpty) {
      throw EmptyHandException();
    }

    final state = CardPhaseState(environmentState, _hand);
    final output = _behavior(state);
    _hand.remove(output);
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
