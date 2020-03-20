import '../card_phase/actions_handler.dart';
import '../card_phase/card_phase_agent.dart';

//TODO rename this class
typedef TurnConsumer<T> = void Function(
    ActionsHandler<T> turn, List<CardPhaseAgent> agentsPlayOrder);
