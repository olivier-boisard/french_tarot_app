import 'card.dart';
import 'turn.dart';

abstract class Player {
  final List<Card> _wonCards = [];

  int get score {
    var score = 0.0;
    for (final card in _wonCards) {
      score += card.score;
    }
    return score.round();
  }

  void winCards(Iterable<Card> wonCards) {
    _wonCards.addAll(wonCards);
  }

  Card play(Turn turn);
}
