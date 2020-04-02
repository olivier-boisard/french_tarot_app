import 'abstract_card_phase_agent.dart';
import 'actions_handler.dart';

typedef ActionPerAgentProcessor<T> = void Function(
  ActionsHandler<T> turn,
  List<AbstractCardPhaseAgent> agentsPlayOrder,
);
