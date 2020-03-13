import '../decision.dart';
import 'card.dart';
import 'environment_state.dart';

typedef OnStateDecisionMaker = Decision Function(List<Card> hand);

OnStateDecisionMaker wrapDecisionMaker(
    EnvironmentState turn, DecisionMaker<Card> decisionMaker) {
  return (hand) => decisionMaker(turn.extractAllowedActions(hand));
}
