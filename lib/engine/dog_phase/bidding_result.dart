import '../core/abstract_card_phase_agent.dart';

class BiddingResult {
  final AbstractCardPhaseAgent taker;
  final int bidValue;

  BiddingResult(this.taker, this.bidValue);
}
