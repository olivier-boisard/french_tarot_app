import '../../core/abstract_card_phase_agent.dart';
import '../../core/decision.dart';
import '../../core/environment_state.dart';
import '../../core/selector.dart';
import '../../core/suited_playable.dart';

class CardPhaseAgent implements AbstractCardPhaseAgent {
  final Selector<SuitedPlayable> _decisionMaker;
  final List<SuitedPlayable> _hand;

  CardPhaseAgent(this._decisionMaker, this._hand);

  @override
  Decision<SuitedPlayable> play(State<SuitedPlayable> turn) {
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
