import 'package:flutter/foundation.dart';

import 'abstract_tarot_card.dart';
import 'suited_playable.dart';

@immutable
class TarotCard implements AbstractTarotCard {
  @override
  final Suit suit;
  @override
  final int value;
  static const List<Suit> standardSuits = [
    Suit.heart,
    Suit.diamond,
    Suit.clover,
    Suit.spades
  ];

  TarotCard.coloredCard(this.suit, this.value) {
    _checkStrengthIsValid();
    _checkSuitIsValid();
  }

  TarotCard.trump(this.value) : suit = Suit.trump {
    _checkStrengthIsValid();
  }

  const TarotCard.excuse()
      : suit = Suit.none,
        value = CardStrengths.excuse;

  @override
  double get score {
    var output = 0.0;
    if (isOudler) {
      output = 4.5;
    } else if (suit == Suit.trump) {
      output = 0.5;
    } else {
      const strengthScoreMap = {
        CardStrengths.jack: 1.5,
        CardStrengths.knight: 2.5,
        CardStrengths.queen: 3.5,
        CardStrengths.king: 4.5
      };
      output = strengthScoreMap[value] ?? 0.5;
    }
    return output;
  }

  @override
  bool get isOudler {
    final oudlers = [
      TarotCard.trump(1),
      TarotCard.trump(21),
      const TarotCard.excuse()
    ];
    return oudlers.contains(this);
  }

  @override
  bool beats(Suit demanded, SuitedPlayable card) {
    final colorDemanded = demanded != Suit.none;
    if (colorDemanded && suit != demanded) {
      return false;
    }
    if (colorDemanded && card.suit != demanded) {
      return true;
    }
    return strength > card.strength;
  }

  @override
  bool operator ==(other) {
    return suit == other.suit && value == other.value;
  }

  @override
  int get hashCode => suit.hashCode + value.hashCode;

  @override
  int get strength {
    return suit != Suit.trump ? value : value + 100;
  }

  void _checkStrengthIsValid() {
    if (suit != Suit.trump && (value < 1 || value > CardStrengths.king)) {
      throw IllegalCardStrengthException();
    }
    if (suit == Suit.trump && (value < 1 || value > 21)) {
      throw IllegalCardStrengthException();
    }
  }

  void _checkSuitIsValid() {
    if (!standardSuits.contains(suit)) {
      throw IllegalCardStrengthException();
    }
  }

  @override
  bool get winnable => isExcuse;

  @override
  bool get isExcuse => this == const TarotCard.excuse();
}

class CardStrengths {
  static const int excuse = 0;
  static const int jack = 11;
  static const int knight = 12;
  static const int queen = 13;
  static const int king = 14;
}

class IllegalCardStrengthException implements Exception {}
