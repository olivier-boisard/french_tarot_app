import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/player.dart';
import 'package:french_tarot/engine/random_behavior.dart';
import 'package:french_tarot/engine/turn.dart';

void main() {
  test('Deal card and play first card in turn', () {
    final hand = [Card.coloredCard(Suit.diamond, 1)];
    final randomBehavior = RandomBehavior<State, Card>();
    final player = Player(randomBehavior.run)
      ..deal(hand);
    final environmentState = EnvironmentState(Turn());
    expect(player.play(environmentState), isIn(hand));
    expect(() => player.play(environmentState),
        throwsA(isInstanceOf<EmptyHandException>()));
  });
}
