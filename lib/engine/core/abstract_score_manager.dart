import 'score_element.dart';

abstract class AbstractScoreManager {
  int get score;

  int get nOudlers;

  void winScoreElements(Iterable<ScoreElement> wonScoreElements);
}
