import 'abstract_agent.dart';
import 'actions_handler.dart';

typedef ActionPerAgentProcessor<T> = void Function(
  ActionsHandler<T> turn,
  List<AbstractAgent> agentsPlayOrder,
);
