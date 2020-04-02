import 'decision_maker.dart';
import 'selector.dart';

class OneUseActionHandler<T> {
  final List<T> _actions;

  OneUseActionHandler(this._actions);

  Decision<T> pickAction(Selector<T> decisionMaker) {
    if (_actions.isEmpty) {
      throw EmptyActionHandlerException();
    }
    final decision = decisionMaker(_actions);
    _actions.remove(decision.action);
    return decision;
  }

  bool get isEmpty => _actions.isEmpty;
}

class EmptyActionHandlerException implements Exception {}