import '../../core/abstract_agent.dart';
import '../../core/decision.dart';
import '../../core/environment_state.dart';
import '../../core/selector.dart';
import '../../core/suited_playable.dart';

class CardPhaseAgent<T extends SuitedPlayable> implements AbstractAgent<T> {
  final Selector<T> _decisionMaker;
  final List<T> _hand;

  CardPhaseAgent(this._decisionMaker, this._hand);

  @override
  Decision<T> play(State<T> turn) {
    if (_hand.isEmpty) {
      throw EmptyHandException();
    }
    final decision = _wrapSelector(turn, _decisionMaker)(_hand);
    _hand.remove(decision.action);
    return decision;
  }

  @override
  bool get isReady => _hand.isNotEmpty;

  static Selector<T> _wrapSelector<T>(State<T> state, Selector<T> selector) {
    return (actions) => selector(state.extractAllowedActions(actions));
  }
}

class EmptyHandException implements Exception {}
