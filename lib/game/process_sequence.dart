import 'dart:io';

import '../engine/core/function_interfaces.dart';

class ProcessSequence {
  final List<Process> _processes;

  ProcessSequence(this._processes);

  void run() {
    for (final process in _processes) {
      process();
    }
  }
}
