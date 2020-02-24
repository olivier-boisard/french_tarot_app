import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/card_phase.dart';
import 'package:french_tarot/engine/random_behavior.dart';

void main() {
  test('Deal card and play first card in turn', () {
    final hand = [Card.coloredCard(Suit.diamond, 1)];
    final handCopy = hand.toList();
    final agent = CardPhaseAgent(hand);
    final decisionFunction = RandomBehavior<Card>().run;
    expect(agent
        .act(decisionFunction)
        .action, isIn(handCopy));
    expect(() => agent.act(decisionFunction),
        throwsA(isInstanceOf<EmptyHandException>()));
  });
}
