import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/deck.dart';

void main() {
  test("Construct deck without random object", () {
    expect(() => Deck(), returnsNormally);
  });
  test("Construct deck with random object", () {
    expect(() => Deck.withRandom(Random()), returnsNormally);
  });
}
