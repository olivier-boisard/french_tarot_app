import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/player.dart';
import 'package:french_tarot/engine/turn.dart';

class _FakePlayer extends Player {
  @override
  Card play(Turn turn) {
    throw UnimplementedError();
  }
}

void main() {
  test('Player has won cards, evaluate score and number of oudlers', () {
    final player = _FakePlayer();
    final wonCards = <Card>[
      Card.coloredCard(Suit.spades, 1),
      Card.coloredCard(Suit.heart, CardStrengths.queen),
      const Card.excuse(),
      const Card.trump(2),
      const Card.trump(21),
      const Card.trump(3),
    ];
    player.winCards(wonCards);
    const expectedScore = 14;
    expect(player.score, equals(expectedScore));
  });
}
