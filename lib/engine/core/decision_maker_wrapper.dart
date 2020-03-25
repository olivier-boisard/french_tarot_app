import 'environment_state.dart';
import 'selector.dart';

Selector<T> wrapDecisionMaker<T>(State<T> state, Selector<T> decisionMaker) {
  return (actions) => decisionMaker(state.extractAllowedActions(actions));
}
