import 'core/score_element.dart';
import 'core/score_manager.dart';

class DogDealer {
  final ScoreManager _takerScoreManager;

  DogDealer(this._takerScoreManager);

  void deal(List<ScoreElement> dog) {
    _takerScoreManager.winScoreElements(dog);
  }
}
