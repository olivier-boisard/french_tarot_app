import 'package:french_tarot/engine/exceptions.dart';

enum Suit { spades, heart, diamond, clover, trump, none }

class Card {
  Suit suit;
  int scoreValue;
  int strength;
  int isOudler;

  Card.coloredCard(this.suit, this.strength) {
    if (this.strength < 1 || this.strength > FigureValues.KING) {
      throw IllegalCardStrengthException();
    }

    const allowedSuits = [Suit.heart, Suit.diamond, Suit.clover, Suit.spades];
    if (!allowedSuits.contains(this.suit)) {
      throw IllegalCardStrengthException();
    }
  }

  bool beats(Suit demanded, Card card) {
    throw UnimplementedError();
  }
}

class FigureValues {
  static const int JACK = 11;
  static const int KNIGHT = 12;
  static const int QUEEN = 13;
  static const int KING = 14;
}
