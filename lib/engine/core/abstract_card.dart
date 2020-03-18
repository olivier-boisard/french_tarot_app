enum Suit { spades, heart, diamond, clover, trump, none }
abstract class AbstractCard {
  bool beats(Suit demanded, AbstractCard card);

  Suit get suit;

  int get strength;
}
