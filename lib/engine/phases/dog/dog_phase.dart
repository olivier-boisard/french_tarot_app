import '../../core/abstract_card.dart';
import '../../core/function_interfaces.dart';
import '../bid.dart';

class DogPhase {
  final List<AbstractCard> _dog;
  final Consumer<List<AbstractCard>> _dogConsumer;
  BiddingResult biddingResult;

  DogPhase(this._dog, this._dogConsumer);

  void run() => _dogConsumer(_dog);
}
