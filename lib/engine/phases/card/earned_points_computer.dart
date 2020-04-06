import '../../core/abstract_card_phase_agent.dart';
import '../../core/abstract_score_manager.dart';
import '../../core/function_interfaces.dart';
import '../bid.dart';

class EarnedPointsComputer {
  final List<AbstractCardPhaseAgent> _agents;
  final AbstractScoreManager _takerScoreManager;
  List<Consumer<List<int>>> earnedPointsConsumers;
  BiddingResult biddingResult;

  EarnedPointsComputer(this._agents, this._takerScoreManager);

  void run() {
    final earnedPoints = _computeEarnedPoints();
    final outputList = _populateOutputList(earnedPoints);
    notifyConsumers<List<int>>(earnedPointsConsumers, outputList);
  }

  _EarnedPoints _computeEarnedPoints() {
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

    return _EarnedPoints(
      takerEarnedPoints,
      opponentsEarnedPoints,
    );
  }

  List<int> _populateOutputList(_EarnedPoints earnedPoints) {
    final output = <int>[];
    for (final agent in _agents) {
      if (identical(agent, biddingResult.taker)) {
        output.add(earnedPoints.taker);
      } else {
        output.add(earnedPoints.opponents);
      }
    }
    return output;
  }
}

class _EarnedPoints {
  final int taker;
  final int opponents;

  _EarnedPoints(this.taker, this.opponents);
}
