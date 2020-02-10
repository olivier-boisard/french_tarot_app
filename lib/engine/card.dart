import 'package:french_tarot/engine/exceptions.dart';

enum Suit { spades, heart, diamond, clover, trump, none }

class Card {
  final Suit suit;
  final int strength;

  Card.coloredCard(this.suit, this.strength) {
    if (strength < 1 || strength > CardStrengths.KING) {
      throw IllegalCardStrengthException();
    }

    const allowedSuits = [Suit.heart, Suit.diamond, Suit.clover, Suit.spades];
    if (!allowedSuits.contains(suit)) {
      throw IllegalCardStrengthException();
    }
  }

  Card.trump(this.strength) : this.suit = Suit.trump;

  Card.excuse()
      : this.suit = Suit.none,
        this.strength= CardStrengths.EXCUSE;

  double get score {
    const strengthScoreMap = {
      CardStrengths.JACK: 1.5,
      CardStrengths.KNIGHT: 2.5,
      CardStrengths.QUEEN: 3.5,
      CardStrengths.KING: 4.5
    };
    return strengthScoreMap[strength] ?? 0.5;
  }

  bool get isOudler {
    return [Card.trump(1), Card.trump(21), Card.excuse()].contains(this);
  }

  bool beats(Suit demanded, Card card) {
    return strength > card.strength;
  }

  bool operator ==(other) {
    return suit == other.suit && strength == other.strength;
  }

  int get hashCode => suit.hashCode + strength.hashCode;

}

class CardStrengths {
  static const int EXCUSE = 0;
  static const int JACK = 11;
  static const int KNIGHT = 12;
  static const int QUEEN = 13;
  static const int KING = 14;
}
