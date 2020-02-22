//TODO document
import 'state.dart';

typedef Behavior<S extends State, A> = A Function(S state);
