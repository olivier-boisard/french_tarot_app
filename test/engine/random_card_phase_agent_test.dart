import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card_phase/card_phase_agent.dart';
import 'package:french_tarot/engine/card_phase/hand.dart';
import 'package:french_tarot/engine/card_phase/turn.dart';
import 'package:french_tarot/engine/core/card.dart';
import 'package:french_tarot/engine/random_decision_maker.dart';

void main() {
  test('Create random card phase agent', () {
    final cardsInHand = [
      Card.coloredCard(Suit.diamond, 1),
      Card.coloredCard(Suit.diamond, 2),
    ];
    final cardsInHandCopy = cardsInHand.toList();
    final hand = Hand(cardsInHand);
    final turn = Turn();
    final agent = CardPhaseAgent(RandomDecisionMaker<Card>().run, hand);
    final play = agent.play(turn);
    expect(play.action, isIn(cardsInHandCopy));
  });
}
