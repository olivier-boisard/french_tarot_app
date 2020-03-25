import '../card_phase/actions_handler.dart';
import 'abstract_card_phase_agent.dart';

typedef ActionPerAgentProcessor<T> = void Function(
    ActionsHandler<T> turn, List<AbstractCardPhaseAgent> agentsPlayOrder);
