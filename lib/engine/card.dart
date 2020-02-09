import 'package:french_tarot/engine/exceptions.dart';

enum Suit { spades, heart, diamond, clover, trump, none }

class Card {
  Suit _suit;
  int _scoreValue;
  int _isOudler;

  Card.createColoredCard(this._suit, this._scoreValue) {
    if (this._scoreValue < 1 || this._scoreValue > FigureValues.KING) {
      throw IllegalCardValueException();
    }
  }

  bool beats(Suit demanded, Card card) {
    throw UnimplementedError();
  }
}

class FigureValues {
  static int JACK = 11;
  static int KNIGHT = 12;
  static int QUEEN = 13;
  static int KING = 14;
}
