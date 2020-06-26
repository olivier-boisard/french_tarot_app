import 'suits.dart';

abstract class SuitedPlayable {
  bool beats(Suit demanded, SuitedPlayable card);

  Suit get suit;

  int get strength;
}
