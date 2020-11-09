import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/core/suits.dart';
import 'package:french_tarot/engine/core/tarot_card.dart';
import 'package:french_tarot/engine/phases/card/card_phase_turn.dart';
import 'package:french_tarot/engine/random/random_card_phase_agent_facade.dart';

void main() {
  test('Create random card phase agent', () {
    final cardsInHand = [
      TarotCard.coloredCard(Suit.diamond, 1),
      TarotCard.coloredCard(Suit.diamond, 2),
    ];
    final cardsInHandCopy = cardsInHand.toList();
    final turn = CardPhaseTurn();
    final agent = RandomCardPhaseAgentFacade(cardsInHand);
    final play = agent.play(turn);
    expect(play.action, isIn(cardsInHandCopy));
  });
}
