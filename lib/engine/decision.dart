class Decision<T> {
  final double probability;
  final T action;

  Decision(this.probability, this.action);
}

typedef DecisionMaker<A> = Decision<A> Function(List<A> possibleActions);
