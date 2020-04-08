import 'dart:math';

import '../core/abstract_agent.dart';
import '../core/function_interfaces.dart';
import '../phases/bid.dart';

class RandomBiddingPhase {
  final List<AbstractAgent> _agents;
  final Random _random;
  List<Consumer<BiddingResult>> biddingResultsConsumers;

  RandomBiddingPhase(this._agents) : _random = Random();

  RandomBiddingPhase.withRandom(this._agents, this._random);

  void run() {
    final result = BiddingResult(
      _agents[_random.nextInt(_agents.length)],
      Bid.petite,
    );
    notifyConsumers<BiddingResult>(biddingResultsConsumers, result);
  }
}
