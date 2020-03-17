import '../card_phase/card_phase_agent.dart';
import '../card_phase/turn.dart';

typedef TurnConsumer = void Function(
    Turn turn, List<CardPhaseAgent> agentsPlayOrder);
