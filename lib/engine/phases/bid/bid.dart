import '../../core/abstract_card_phase_agent.dart';

class BiddingResult {
  final AbstractCardPhaseAgent taker;
  final int bidValue;

  BiddingResult(this.taker, this.bidValue);
}

class Bid {
  static const PASS = 0;
  static const PETITE = 1;
  static const GUARD = 2;
  static const GUARD_WITHOUT = 3;
  static const GUARD_AGAINST = 4;
}
