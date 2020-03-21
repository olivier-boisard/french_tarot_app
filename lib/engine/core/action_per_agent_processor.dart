import '../card_phase/actions_handler.dart';
import '../card_phase/card_phase_agent.dart';

typedef ActionPerAgentProcessor<T> = void Function(
    ActionsHandler<T> turn, List<CardPhaseAgent> agentsPlayOrder);
