import '../../core/abstract_card_phase_agent.dart';
import '../../core/abstract_score_manager.dart';
import '../../core/function_interfaces.dart';
import '../bid/bid.dart';

// TODO SOLID
class EarnedPointsComputer {
  final List<AbstractCardPhaseAgent> _agents;
  final AbstractScoreManager _takerScoreManager;
  List<Consumer<List<int>>> earnedPointsConsumers;
  BiddingResult biddingResult;

  EarnedPointsComputer(this._agents, this._takerScoreManager);

  void run() {
    final earnedPoints = _computeEarnedPoints();
    _notifyConsumers(earnedPoints);
  }

  List<int> _computeEarnedPoints() {
    final contract = [56, 51, 41, 36][_takerScoreManager.nOudlers];
    var takerEarnedPoints = 0;
    var opponentsEarnedPoints = 0;
    final nOpponents = _agents.length - 1;
    final score = _takerScoreManager.score;
    if (score >= contract) {
      final basePoint = score - contract + 25;
      takerEarnedPoints = nOpponents * basePoint;
      opponentsEarnedPoints = -basePoint;
    } else {
      final basePoint = contract - score + 25;
      takerEarnedPoints = -nOpponents * basePoint;
      opponentsEarnedPoints = basePoint;
    }

    final earnedPoints = <int>[];
    for (final agent in _agents) {
      if (identical(agent, biddingResult.taker)) {
        earnedPoints.add(takerEarnedPoints);
      } else {
        earnedPoints.add(opponentsEarnedPoints);
      }
    }
    return earnedPoints;
  }

  //TODO factorize all such methods
  void _notifyConsumers(List<int> values) {
    if (earnedPointsConsumers != null) {
      for (final consumer in earnedPointsConsumers) {
        consumer(values);
      }
    }
  }
}
