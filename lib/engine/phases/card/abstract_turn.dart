import '../../core/actions_handler.dart';
import '../../core/environment_state.dart';

// This class exists instead of a simple functional interface because it also
// implements other interfaces
abstract class AbstractTurn<T> implements State<T>, ActionsHandler<T> { // ignore: one_member_abstracts
  void addAction(T action);
}
