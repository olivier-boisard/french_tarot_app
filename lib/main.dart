import 'engine/core/tarot_deck_facade.dart';

//TODO replace List with Iterable everywhere possible in the code

void main() {
  final deck = TarotDeckFacade()..shuffle();
  const nCards = 18;

  final cards = deck.pop(nCards);
}
