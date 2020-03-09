import 'card.dart';
import 'decision.dart';
import 'turn.dart';

Function wrapDecisionMaker(Turn turn, DecisionMaker<Card> decisionMaker) {
  return (hand) => decisionMaker(turn.extractAllowedCards(hand));
}
