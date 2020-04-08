import '../core/abstract_agent.dart';

class BiddingResult {
  final AbstractAgent taker;
  final int bidValue;

  BiddingResult(this.taker, this.bidValue);
}

class Bid {
  static const pass = 0;
  static const petite = 1;
  static const guard = 2;
  static const guardWithout = 3;
  static const guardAgainst = 4;
}
