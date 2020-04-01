import '../core/abstract_card_phase_agent.dart';
import '../core/score_element.dart';
import '../core/score_manager.dart';

class DogDealer {
  final ScoreManager _takerScoreManager;

  DogDealer(this._takerScoreManager);

  void deal(BiddingResult biddingResult, List<ScoreElement> dog) {
    _takerScoreManager.winScoreElements(dog);
  }
}

class BiddingResult {
  final AbstractCardPhaseAgent taker;
  final int bidValue;

  BiddingResult(this.taker, this.bidValue);
}
