enum Suit { spades, heart, diamond, clover, trump, none }

abstract class SuitedPlayable {
  bool beats(Suit demanded, SuitedPlayable card);

  Suit get suit;

  int get strength;
}
