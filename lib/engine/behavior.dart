typedef Behavior<A> = Action<A> Function(State state);

typedef ActionsFilter<T> = List<T> Function(List<T> actions);

//TODO rename
class Action<T> {
  final double probability;
  final T value;

  Action(this.probability, this.value);
}

abstract class State<A> {
  List<A> get allowedActions;
}

abstract class EnvironmentStateInterface<T> {
  List<T> filterAllowedActions(List<T> actions);
}

class EncodedState {}
