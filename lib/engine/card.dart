import 'package:flutter/foundation.dart';

import 'exceptions.dart';

enum Suit { spades, heart, diamond, clover, trump, none }

@immutable
class Card {
  final Suit suit;
  final int strength;
  static const List<Suit> standardSuits = [
    Suit.heart,
    Suit.diamond,
    Suit.clover,
    Suit.spades
  ];

  //TODO make const
  Card.coloredCard(this.suit, this.strength) {
    _checkStrengthIsValid();
    _checkSuitIsValid();
  }

  const Card.trump(this.strength) : suit = Suit.trump;

  const Card.excuse()
      : suit = Suit.none,
        strength= CardStrengths.excuse;

  double get score {
    const strengthScoreMap = {
      CardStrengths.jack: 1.5,
      CardStrengths.knight: 2.5,
      CardStrengths.queen: 3.5,
      CardStrengths.king: 4.5
    };
    return strengthScoreMap[strength] ?? 0.5;
  }

  bool get isOudler {
    final oudlers = [
      const Card.trump(1),
      const Card.trump(21),
      const Card.excuse()
    ];
    return oudlers.contains(this);
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

  @override
  bool operator ==(other) {
    return suit == other.suit && strength == other.strength;
  }

  @override
  int get hashCode => suit.hashCode + strength.hashCode;

  int get _adjustedCardStrength {
    return suit != Suit.trump ? strength : strength + 100;
  }

  void _checkStrengthIsValid() {
    if (strength < 1 || strength > CardStrengths.king) {
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
  static const int excuse = 0;
  static const int jack = 11;
  static const int knight = 12;
  static const int queen = 13;
  static const int king = 14;
}
