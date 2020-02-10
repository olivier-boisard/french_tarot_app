import 'package:flutter_test/flutter_test.dart';
import 'package:french_tarot/engine/turn.dart';

void main() {
  test("Construct Turn object", () {
    expect(() => Turn(), returnsNormally);
  });
}
