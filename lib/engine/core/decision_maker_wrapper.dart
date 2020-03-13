import '../agent.dart';
import 'environment_state.dart';

typedef OnStateDecisionMaker<T> = Decision<T> Function(List<T> action);

OnStateDecisionMaker<T> wrapDecisionMaker<T>(EnvironmentState<T> state,
    DecisionMaker<T> decisionMaker) {
  return (actions) => decisionMaker(state.extractAllowedActions(actions));
}
