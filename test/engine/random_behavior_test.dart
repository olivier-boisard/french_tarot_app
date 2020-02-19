import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/player.dart';
import 'package:french_tarot/engine/random_behavior.dart';
import 'package:french_tarot/engine/turn.dart';

void main() {
  test('Deal card and play first card in turn', () {
    final hand = [Card.coloredCard(Suit.diamond, 1), Card.trump(2)];
    final player = Player(RandomBehavior().run)
      ..deal(hand);
    final turn = Turn();
    expect(player.play(turn), isIn(hand));
  });
}
