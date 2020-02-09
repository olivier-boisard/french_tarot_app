import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/app/cards.dart';

//TODO unit tests

void main() {
  test('Construct cards with incorrect value-suit combinations fails', () {
    expect(TarotCard(Suit.spades, Value.numeric_11),
        throwsA(BadSuitValueCombinationException));
  });
}
