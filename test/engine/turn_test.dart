import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/card.dart';
import 'package:french_tarot/engine/turn.dart';

void main() {
  test("Construct Turn object", () {
    expect(() => Turn(), returnsNormally);
  });
  test("Add card", () {
    final turn = Turn();
    final playedCard = Card.trump(2);
    turn.addPlayedCard(playedCard);
    expect(turn.playedCards.first, equals(playedCard));
  });
}
