typedef Consumer<T> = void Function(T);

typedef Factory<T> = T Function();

typedef Process = void Function();

void notifyConsumers<T>(List<Consumer<T>> consumers, T consumable) {
  if (consumers != null) {
    for (final consumer in consumers) {
      consumer(consumable);
    }
  }
}
