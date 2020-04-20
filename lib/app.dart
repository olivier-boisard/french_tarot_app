import 'package:flutter/material.dart';

import 'app/main.dart';
import 'engine/core/tarot_deck_facade.dart';

void main() {
  final tarotDeckFacade = TarotDeckFacade();
  runApp(FrenchTarotApp(tarotDeckFacade.pop(18)));
}
