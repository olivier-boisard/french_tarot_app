import '../core/abstract_score_element.dart';

abstract class PlayableScoreElement implements ScoreElement {
  bool get winnable;
}
