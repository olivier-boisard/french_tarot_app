import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/suits.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';
import 'package:french_tarot/engine/phases/card/card_phase_agent.dart';
import 'package:french_tarot/engine/phases/card/card_phase_turn.dart';
import 'package:french_tarot/engine/random/random_card_phase_agent_facade.dart';

void main() {
  test('Deal card and play first card in turn', () {
    final hand = [TarotCard.coloredCard(Suit.diamond, 1)];
    final handCopy = hand.toList();
    final cardPhaseAgent = RandomCardPhaseAgentFacade(hand);

    expect(cardPhaseAgent.play(CardPhaseTurn()).action, isIn(handCopy));
    expect(
      () => cardPhaseAgent.play(CardPhaseTurn()).action,
      throwsA(isInstanceOf<EmptyHandException>()),
    );
  });

  test('Only allowed cards are played', () {
    final diamondCardInHand = TarotCard.coloredCard(Suit.diamond, 1);
    final originalHand = [
      diamondCardInHand,
      TarotCard.coloredCard(Suit.spades, 1),
      TarotCard.coloredCard(Suit.spades, 2),
      TarotCard.coloredCard(Suit.spades, 3),
      TarotCard.coloredCard(Suit.spades, 4),
    ];
    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.diamond, 2));

    for (var i = 0; i < 1000; i++) {
      final handCopy = originalHand.toList();
      final cardPhaseAgent = RandomCardPhaseAgentFacade.withRandom(
        Random(i),
        handCopy,
      );
      final decision = cardPhaseAgent.play(turn);
      expect(decision.action, equals(diamondCardInHand));
    }
  });

  test('Get all possible results', () {
    final diamondCardsInHand = [
      TarotCard.coloredCard(Suit.diamond, 1),
      TarotCard.coloredCard(Suit.diamond, 2),
      TarotCard.coloredCard(Suit.diamond, 3),
    ];
    final originalHand = diamondCardsInHand +
        [
          TarotCard.coloredCard(Suit.spades, 1),
          TarotCard.coloredCard(Suit.spades, 2),
          TarotCard.coloredCard(Suit.spades, 3),
          TarotCard.coloredCard(Suit.spades, 4),
        ];

    final turn = CardPhaseTurn()
      ..addAction(TarotCard.coloredCard(Suit.diamond, 4));
    for (var i = 0; i < 1000; i++) {
      final handCopy = originalHand.toList();
      final cardPhaseAgent = RandomCardPhaseAgentFacade.withRandom(
        Random(i),
        handCopy,
      );
      final decision = cardPhaseAgent.play(turn);
      diamondCardsInHand.remove(decision.action);
    }
    expect(diamondCardsInHand, isEmpty);
  });
}
