import 'decision.dart';
import 'environment_state.dart';

abstract class AbstractAgent<T> {
  Decision<T> play(State<T> turn);

  bool get isReady;
}
