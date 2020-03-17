import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card_phase/card_phase_agent.dart';
import 'package:french_tarot/engine/card_phase/hand.dart';
import 'package:french_tarot/engine/card_phase/round.dart';
import 'package:french_tarot/engine/core/card.dart';
import 'package:french_tarot/engine/core/deck.dart';
import 'package:french_tarot/engine/random_decision_maker.dart';

void main() {
  test('Play round', () {
    final deck = Deck();
    const nPlayers = 4;
    const nCardsInDog = 6;
    final nCardsPerPlayer = (deck.size - nCardsInDog) ~/ nPlayers;

    deck.shuffle();

    final agents = <CardPhaseAgent>[];
    for (var i = 0; i < nPlayers; i++) {
      final decisionMaker = RandomDecisionMaker<Card>();
      final hand = Hand(deck.pop(nCardsPerPlayer));
      agents.add(CardPhaseAgent(decisionMaker.run, hand));
    }

    final scores = playRound(agents);
    expect(scores, isNotEmpty);
    expect(scores.values.toList()[0], isNot(equals(0)));
    expect(scores.values.reduce((a, b) => a + b), equals(0));
  });
}
