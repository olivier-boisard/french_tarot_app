import '../../core/abstract_card_phase_agent.dart';
import '../../core/decision.dart';
import '../../core/environment_state.dart';
import '../../core/selector.dart';
import '../../core/selector_wrapper.dart';
import '../../core/suited_playable.dart';

//TODO break dependency to OneUseActionHandler
class CardPhaseAgent implements AbstractCardPhaseAgent {
  final _Hand _hand;
  final Selector<SuitedPlayable> _decisionMaker;

  CardPhaseAgent(this._decisionMaker, List<SuitedPlayable> handCards)
      : _hand = _Hand(handCards);

  @override
  Decision<SuitedPlayable> play(State<SuitedPlayable> turn) {
    return _hand.pickAction(wrapSelector(turn, _decisionMaker));
  }

  @override
  bool get isReady => !_hand.isEmpty;
}

class EmptyHandException implements Exception {}

class _Hand {
  final List<SuitedPlayable> _actions;

  _Hand(this._actions);

  Decision<SuitedPlayable> pickAction(Selector<SuitedPlayable> decisionMaker) {
    if (_actions.isEmpty) {
      throw EmptyHandException();
    }
    final decision = decisionMaker(_actions);
    _actions.remove(decision.action);
    return decision;
  }

  bool get isEmpty => _actions.isEmpty;
}
