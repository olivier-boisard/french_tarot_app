import 'score_element.dart';

class PlayerScoreManager {
  final List<ScoreElement> _wonScoreElements = [];

  int get score {
    if (_wonScoreElements.length % 2 == 1) {
      throw OddNumberOfCardsException();
    }
    var score = 0.0;
    for (final scoreElement in _wonScoreElements) {
      score += scoreElement.score;
    }
    return score.round();
  }

  int get numberOfOudlers {
    var numberOfOudlers = 0;
    for (final scoreElement in _wonScoreElements) {
      if (scoreElement.isOudler) {
        numberOfOudlers += 1;
      }
    }
    return numberOfOudlers;
  }

  void winScoreElements(Iterable<ScoreElement> wonScoreElements) {
    _wonScoreElements.addAll(wonScoreElements);
  }
}

class OddNumberOfCardsException implements Exception {}
