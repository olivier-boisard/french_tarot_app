import 'environment_state.dart';
import 'selector.dart';

Selector<T> wrapSelector<T>(State<T> state, Selector<T> selector) {
  return (actions) => selector(state.extractAllowedActions(actions));
}
