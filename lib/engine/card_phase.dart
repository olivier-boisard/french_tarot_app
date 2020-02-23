import 'behavior.dart';
import 'card.dart';

class CardPhaseAgent {
  final List<Card> _hand;
  final Behavior<Card> _behavior;

  CardPhaseAgent(this._hand, this._behavior);

  Action<Card> act(EnvironmentStateInterface<Card> environmentState) {
    if (_hand.isEmpty) {
      throw EmptyHandException();
    }

    final state = CardPhaseState(environmentState, _hand);
    final output = _behavior(state);
    _hand.remove(output.value);
    return output;
  }
}

class CardPhaseState implements State<Card> {
  EnvironmentStateInterface<Card> _environmentState;
  List<Card> _hand;

  CardPhaseState(this._environmentState, this._hand);

  @override
  List<Card> get allowedActions {
    return _environmentState.filterAllowedActions(_hand);
  }
}

class EmptyHandException implements Exception {}
