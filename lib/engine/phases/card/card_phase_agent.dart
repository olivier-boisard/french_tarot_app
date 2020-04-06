import '../../core/abstract_card_phase_agent.dart';
import '../../core/decision.dart';
import '../../core/environment_state.dart';
import '../../core/selector.dart';
import '../../core/selector_wrapper.dart';
import '../../core/suited_playable.dart';

//TODO break dependency to OneUseActionHandler
class CardPhaseAgent implements AbstractCardPhaseAgent {
  final Selector<SuitedPlayable> _decisionMaker;
  final List<SuitedPlayable> _hand;

  CardPhaseAgent(this._decisionMaker, this._hand);

  @override
  Decision<SuitedPlayable> play(State<SuitedPlayable> turn) {
    if (_hand.isEmpty) {
      throw EmptyHandException();
    }
    final decision = wrapSelector(turn, _decisionMaker)(_hand);
    _hand.remove(decision.action);
    return decision;
  }

  @override
  bool get isReady => _hand.isNotEmpty;
}

class EmptyHandException implements Exception {}
