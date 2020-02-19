import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/player.dart';
import 'package:french_tarot/engine/random_behavior.dart';
import 'package:french_tarot/engine/turn.dart';

void main() {
  test('Deal card and play first card in turn', () {
    final hand = [Card.coloredCard(Suit.diamond, 1)];
    final randomBehavior = RandomBehavior<Turn, Card>();
    final player = Player(randomBehavior.run)
      ..deal(hand);
    expect(player.play(Turn()), isIn(hand));
    expect(() => player.play(Turn()),
        throwsA(isInstanceOf<EmptyHandException>()));
  });
}
