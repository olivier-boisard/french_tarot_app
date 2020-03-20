import '../core/environment_state.dart';

import 'actions_handler.dart';

abstract class AbstractTurn<T> implements State<T>, ActionsHandler<T> {
  void addAction(T action);
}
