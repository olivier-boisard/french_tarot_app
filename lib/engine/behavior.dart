typedef ActionsFilter<T> = List<T> Function(List<T> actions);

class Decision<T> {
  final double probability;
  final T action;

  Decision(this.probability, this.action);
}
