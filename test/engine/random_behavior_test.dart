import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card_phase/one_use_action_handler.dart';
import 'package:french_tarot/engine/card_phase/turn.dart';
import 'package:french_tarot/engine/core/card.dart';
import 'package:french_tarot/engine/core/decision_maker_wrapper.dart';
import 'package:french_tarot/engine/core/suited_playable.dart';
import 'package:french_tarot/engine/random_decision_maker.dart';

//TODO use RandomCardPhaseAgent here after its creation
void main() {
  test('Deal card and play first card in turn', () {
    final hand = [Card.coloredCard(Suit.diamond, 1)];
    final handCopy = hand.toList();
    final agent = OneUseActionHandler<SuitedPlayable>(hand);
    final decisionFunction = RandomDecisionMaker<SuitedPlayable>().run;

    expect(agent.pickAction(decisionFunction).action, isIn(handCopy));
    expect(
      () => agent.pickAction(decisionFunction),
      throwsA(isInstanceOf<EmptyActionHandlerException>()),
    );
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
    final turn = Turn()..addAction(Card.coloredCard(Suit.diamond, 2));

    for (var i = 0; i < 1000; i++) {
      final behavior = RandomDecisionMaker<SuitedPlayable>.withRandom(
        Random(i),
      );
      final agent = OneUseActionHandler<SuitedPlayable>(originalHand.toList());
      final decision = agent.pickAction(wrapDecisionMaker(turn, behavior.run));
      expect(decision.action, equals(diamondCardInHand));
    }
  });

  test('Get all possible results', () {
    final diamondCardsInHand = [
      Card.coloredCard(Suit.diamond, 1),
      Card.coloredCard(Suit.diamond, 2),
      Card.coloredCard(Suit.diamond, 3),
    ];
    final originalHand = diamondCardsInHand +
        [
          Card.coloredCard(Suit.spades, 1),
          Card.coloredCard(Suit.spades, 2),
          Card.coloredCard(Suit.spades, 3),
          Card.coloredCard(Suit.spades, 4),
        ];

    final turn = Turn()..addAction(Card.coloredCard(Suit.diamond, 4));
    for (var i = 0; i < 1000; i++) {
      final random = Random(i);
      final behavior = RandomDecisionMaker<SuitedPlayable>.withRandom(random);
      final agent = OneUseActionHandler<SuitedPlayable>(originalHand.toList());
      final decision = agent.pickAction(wrapDecisionMaker(turn, behavior.run));
      diamondCardsInHand.remove(decision.action);
    }
    expect(diamondCardsInHand, isEmpty);
  });
}
