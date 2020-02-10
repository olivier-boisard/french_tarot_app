import 'package:french_tarot/engine/exceptions.dart';

enum Suit { spades, heart, diamond, clover, trump, none }

class Card {
  final Suit suit;
  final int strength;
  static const List<Suit> standardSuits = [
    Suit.heart,
    Suit.diamond,
    Suit.clover,
    Suit.spades
  ];

  Card.coloredCard(this.suit, this.strength) {
    _checkStrengthIsValid();
    _checkSuitIsValid();
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
    final colorDemanded = demanded != Suit.none;
    if (colorDemanded && suit != demanded) {
      return false;
    }
    if (colorDemanded && card.suit != demanded) {
      return true;
    }
    return _adjustedCardStrength > card._adjustedCardStrength;
  }

  bool operator ==(other) {
    return suit == other.suit && strength == other.strength;
  }

  int get hashCode => suit.hashCode + strength.hashCode;

  int get _adjustedCardStrength {
    return suit != Suit.trump ? strength : strength + 100;
  }

  void _checkStrengthIsValid() {
    if (strength < 1 || strength > CardStrengths.KING) {
      throw IllegalCardStrengthException();
    }
  }

  void _checkSuitIsValid() {
    if (!standardSuits.contains(suit)) {
      throw IllegalCardStrengthException();
    }
  }

}

class CardStrengths {
  static const int EXCUSE = 0;
  static const int JACK = 11;
  static const int KNIGHT = 12;
  static const int QUEEN = 13;
  static const int KING = 14;
}
