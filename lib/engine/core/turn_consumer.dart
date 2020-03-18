import 'package:french_tarot/engine/card_phase/abstract_turn.dart';

import '../card_phase/card_phase_agent.dart';

typedef TurnConsumer<T> = void Function(
    AbstractTurn<T> turn, List<CardPhaseAgent> agentsPlayOrder);
