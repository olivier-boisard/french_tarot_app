typedef Consumer<T> = void Function(T);

typedef Factory<T> = T Function();

typedef Process = void Function();

typedef Transformer<R, P> = R Function(P);

void notifyConsumers<T>(Iterable<Consumer<T>> consumers, T consumable) {
  if (consumers != null) {
    for (final consumer in consumers) {
      consumer(consumable);
    }
  }
}
