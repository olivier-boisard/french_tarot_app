import 'decision.dart';

typedef Selector<T> = Decision<T> Function(List<T>);
