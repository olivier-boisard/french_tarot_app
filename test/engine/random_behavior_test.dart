import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/card_phase.dart';
import 'package:french_tarot/engine/card_phase_environment_state.dart';
import 'package:french_tarot/engine/random_behavior.dart';
import 'package:french_tarot/engine/turn.dart';

void main() {
  test('Deal card and play first card in turn', () {
    final hand = [Card.coloredCard(Suit.diamond, 1)];
    final handCopy = hand.toList();
    final agent = CardPhaseAgent(hand, RandomBehavior<Card>().run);
    final state = CardPhaseEnvironmentState(Turn());
    expect(agent
        .act(state)
        .value, isIn(handCopy));
    expect(() => agent.act(state),
        throwsA(isInstanceOf<EmptyHandException>()));
  });
}
