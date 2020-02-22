typedef Behavior<T> = Action Function(State state);

class Action<T> {
  final double probability;
  final T value;

  Action(this.probability, this.value);
}

abstract class State<A> {
  List<A> get allowedActions;
}
