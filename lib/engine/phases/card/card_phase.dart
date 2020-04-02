import '../../core/abstract_card_phase_agent.dart';
import '../../core/function_interfaces.dart';
import '../../core/score_computer.dart';
import '../../core/score_manager.dart';
import '../bid/bid.dart';
import 'round.dart';
import 'turn.dart';

// TODO SOLID
class CardPhase {
  final List<AbstractCardPhaseAgent> _agents;
  final ScoreManager _takerScoreManager;
  final ScoreManager _oppositionScoreManager;
  List<Consumer<List<int>>> earnedPointsConsumers;
  BiddingResult biddingResult;

  CardPhase(
    this._agents,
    this._takerScoreManager,
    this._oppositionScoreManager,
  );

  void run() {
    final scoreComputer = _createScoreComputer(biddingResult.taker);
    _playRound(scoreComputer, _agents);
    _distributePoints(_agents, biddingResult.taker);
  }

  void _playRound(
    ScoreComputer scoreComputer,
    List<AbstractCardPhaseAgent> agents,
  ) {
    //TODO break dependency to Round and Turn
    Round(() => Turn(), scoreComputer.consume).play(agents);
  }

  void _distributePoints(
    List<AbstractCardPhaseAgent> agents,
    AbstractCardPhaseAgent taker,
  ) {
    final earnedPoints = _computeEarnedPoints(agents, taker);
    _notifyConsumers(earnedPoints);
  }

  void _notifyConsumers(List<int> values) {
    if (earnedPointsConsumers != null) {
      for (final consumer in earnedPointsConsumers) {
        consumer(values);
      }
    }
  }

  ScoreComputer _createScoreComputer(AbstractCardPhaseAgent taker) {
    return ScoreComputer(
      taker,
      _takerScoreManager.winScoreElements,
      _oppositionScoreManager.winScoreElements,
    );
  }

  List<int> _computeEarnedPoints(
    List<AbstractCardPhaseAgent> agents,
    AbstractCardPhaseAgent taker,
  ) {
    final contract = [56, 51, 41, 36][_takerScoreManager.nOudlers];
    var takerEarnedPoints = 0;
    var opponentsEarnedPoints = 0;
    final nOpponents = agents.length - 1;
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
    for (final agent in agents) {
      if (identical(agent, taker)) {
        earnedPoints.add(takerEarnedPoints);
      } else {
        earnedPoints.add(opponentsEarnedPoints);
      }
    }
    return earnedPoints;
  }
}
