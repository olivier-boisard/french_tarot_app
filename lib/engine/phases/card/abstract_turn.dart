import '../../core/actions_handler.dart';
import '../../core/environment_state.dart';

abstract class AbstractTurn<T> implements State<T>, ActionsHandler<T> {
  void addAction(T action);
}
