import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/player.dart';
import 'package:french_tarot/engine/state.dart';

class FakePlayer extends Player {
  FakePlayer() : super(fakeBehavior);

  static Card fakeBehavior(State state, List<Card> allowedCards) {
    return null;
  }
}

void main() {
  test('Player has won cards, evaluate score and number of oudlers', () {
    final player = FakePlayer();
    const expectedScore = 14;

    _makePlayerWinsNonOudlerCards(player);
    _makePlayerWinTwoOudlers(player);

    expect(player.score, equals(expectedScore));
    expect(player.numberOfOudlers, equals(2));
  });

  test('Compute score on odd number of cards fails', () {
    final player = FakePlayer();
    final wonCards = [Card.coloredCard(Suit.spades, 1)];
    player.winCards(wonCards);
    expect(() => player.score,
        throwsA(isInstanceOf<OddNumberOfCardsException>()));
  });
}

void _makePlayerWinTwoOudlers(FakePlayer player) {
  final oudlers = [const Card.excuse(), Card.trump(21)];
  player.winCards(oudlers);
}

void _makePlayerWinsNonOudlerCards(FakePlayer player) {
  final wonCards = <Card>[
    Card.coloredCard(Suit.spades, 1),
    Card.coloredCard(Suit.heart, CardStrengths.queen),
    Card.trump(2),
    Card.trump(3),
  ];
  player.winCards(wonCards);
}
