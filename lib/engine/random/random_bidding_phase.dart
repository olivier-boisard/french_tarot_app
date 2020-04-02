import 'dart:math';

import '../core/abstract_card_phase_agent.dart';
import '../core/function_interfaces.dart';
import '../phases/bid/bid.dart';

class RandomBiddingPhase {
  final List<AbstractCardPhaseAgent> _agents;
  final Random _random;
  List<Consumer<BiddingResult>> biddingResultsConsumers;

  RandomBiddingPhase(this._agents) : _random = Random();

  RandomBiddingPhase.withRandom(this._agents, this._random);

  void run() {
    final result = BiddingResult(
      _agents[_random.nextInt(_agents.length)],
      Bid.PETITE,
    );
    _notifyConsumers(result);
  }

  void _notifyConsumers(BiddingResult result) {
    if (biddingResultsConsumers != null) {
      for (final consumer in biddingResultsConsumers) {
        consumer(result);
      }
    }
  }
}
