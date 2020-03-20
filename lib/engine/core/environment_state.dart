abstract class State<T> {
  List<T> extractAllowedActions(List<T> actions);

  T extractGreedyAction(List<T> actions);

  List<double> get featureVector;
}
