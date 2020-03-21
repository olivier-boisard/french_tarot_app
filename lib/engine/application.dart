import 'card_phase/abstract_score_computer.dart';

import 'core/abstract_card_phase_agent.dart';
import 'core/consumer.dart';

class Application {
  final Consumer<List<AbstractCardPhaseAgent>> _playerHandlers;
  final AbstractScoreComputer _scoreComputer;

  Application(this._playerHandlers, this._scoreComputer);

  void run(List<AbstractCardPhaseAgent> agents, AbstractCardPhaseAgent taker) {}
}
