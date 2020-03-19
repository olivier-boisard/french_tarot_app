import '../decision_maker.dart';
import 'environment_state.dart';

DecisionMaker<T> wrapDecisionMaker<T>(
    EnvironmentState<T> state, DecisionMaker<T> decisionMaker) {
  return (actions) => decisionMaker(state.extractAllowedActions(actions));
}
