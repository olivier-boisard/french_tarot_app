import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/card_phase.dart';
import 'package:french_tarot/engine/random_behavior.dart';
import 'package:french_tarot/engine/turn.dart';

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

  test('Only allowed cards are played', () {
    final diamondCardInHand = Card.coloredCard(Suit.diamond, 1);
    final originalHand = [
      diamondCardInHand,
      Card.coloredCard(Suit.spades, 1),
      Card.coloredCard(Suit.spades, 2),
      Card.coloredCard(Suit.spades, 3),
      Card.coloredCard(Suit.spades, 4),
    ];
    final turn = Turn()
      ..addPlayedCard(Card.coloredCard(Suit.diamond, 2));

    for (var i = 0; i < 1000; i++) {
      final behavior = RandomBehavior<Card>.withRandom(Random(i));
      final agent = CardPhaseAgent(originalHand.toList());
      final decision = agent.act(
            (cards) => behavior.run(turn.extractAllowedCards(cards)),
      );
      expect(decision.action, equals(diamondCardInHand));
    }
  });

  //TODO add unit test to test that when there are several possible cards, we
  // get different results
}
