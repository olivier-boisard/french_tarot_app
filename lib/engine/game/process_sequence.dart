import '../core/function_interfaces.dart';

class ProcessSequence {
  final Iterable<Process> _processes;

  ProcessSequence(this._processes);

  void run() {
    for (final process in _processes) {
      process();
    }
  }
}
