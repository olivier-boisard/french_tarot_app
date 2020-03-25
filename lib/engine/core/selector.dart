import '../decision_maker.dart';

typedef Selector<T> = Decision<T> Function(List<T>);
