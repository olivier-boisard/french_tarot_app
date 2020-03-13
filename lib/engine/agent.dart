class Decision<T> {
  final double probability;
  final T action;

  Decision(this.probability, this.action);
}

typedef DecisionMaker<T> = Decision<T> Function(List<T> possibleActions);
