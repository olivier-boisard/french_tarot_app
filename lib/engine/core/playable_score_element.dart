import 'score_element.dart';

abstract class PlayableScoreElement implements ScoreElement {
  bool get winnable;
}
