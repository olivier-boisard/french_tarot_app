import 'decision.dart';

typedef Selector<T> = Decision<T> Function(Iterable<T>);
