import '../core/card.dart';
import '../decision.dart';
import 'turn.dart';

typedef TurnDecisionMaker = Decision Function(List<Card> hand);

TurnDecisionMaker wrapDecisionMaker(Turn turn,
    DecisionMaker<Card> decisionMaker) {
  return (hand) => decisionMaker(turn.extractAllowedCards(hand));
}
