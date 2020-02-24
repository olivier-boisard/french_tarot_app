typedef ActionsFilter<T> = List<T> Function(List<T> actions);

class Decision<T> {
  final double probability;
  final T action;

  Decision(this.probability, this.action);
}

abstract class State<A> {
  List<A> get allowedActions;
}

abstract class EnvironmentStateInterface<T> {
  List<T> filterAllowedActions(List<T> actions);
}

class EncodedState {}
