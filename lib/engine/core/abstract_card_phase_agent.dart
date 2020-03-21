import '../decision_maker.dart';
import 'environment_state.dart';
import 'suited_playable.dart';

abstract class AbstractCardPhaseAgent {
  Decision<SuitedPlayable> play(State<SuitedPlayable> turn);
  bool get isReady;
}
