import 'dart:io';

import 'core/function_interfaces.dart';

class Application {
  final List<Process> _processes;

  Application(this._processes);

  void run() {
    for (final process in _processes) {
      process();
    }
  }
}
