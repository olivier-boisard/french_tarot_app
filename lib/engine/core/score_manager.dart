import 'abstract_score_manager.dart';
import 'score_element.dart';

class ScoreManager implements AbstractScoreManager {
  final List<ScoreElement> _wonScoreElements = [];

  @override
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

  @override
  int get nOudlers {
    var numberOfOudlers = 0;
    for (final scoreElement in _wonScoreElements) {
      if (scoreElement.isOudler) {
        numberOfOudlers += 1;
      }
    }
    return numberOfOudlers;
  }

  @override
  void winScoreElements(Iterable<ScoreElement> wonScoreElements) {
    _wonScoreElements.addAll(wonScoreElements);
  }
}

class OddNumberOfCardsException implements Exception {}
