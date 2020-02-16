import 'card.dart';
import 'exceptions.dart';
import 'turn.dart';

abstract class Player {
  final List<Card> _wonCards = [];

  int get score {
    if (_wonCards.length % 2 == 1) {
      throw OddNumberOfCardsException();
    }
    var score = 0.0;
    for (final card in _wonCards) {
      score += card.score;
    }
    return score.round();
  }

  int get numberOfOudlers {
    var numberOfOudlers = 0;
    for (final card in _wonCards) {
      if (card.isOudler) {
        numberOfOudlers += 1;
      }
    }
    return numberOfOudlers;
  }

  void winCards(Iterable<Card> wonCards) {
    _wonCards.addAll(wonCards);
  }

  Card play(Turn turn);
}
