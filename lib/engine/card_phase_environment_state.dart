import 'behavior.dart';
import 'card.dart';
import 'turn.dart';

class CardPhaseEnvironmentState implements EnvironmentStateInterface<Card> {
  final Turn _turn;

  CardPhaseEnvironmentState(this._turn);

  @override
  List<Card> filterAllowedActions(List<Card> actions) {
    return _turn.extractAllowedCards(actions);
  }
}
