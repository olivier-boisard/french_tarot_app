import '../../core/abstract_card.dart';
import '../../core/score_manager.dart';
import '../bid/bid.dart';

//TODO SOLID
class DogPhase {
  final List<AbstractCard> _dog;
  final ScoreManager _takerScoreManager;
  BiddingResult biddingResult;

  DogPhase(this._dog, this._takerScoreManager);

  void run() {
    _takerScoreManager.winScoreElements(_dog);
  }
}
