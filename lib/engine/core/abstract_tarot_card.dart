import 'abstract_card.dart';

// We disable a linter rule here because this class implements an interface.
// ignore: one_member_abstracts
abstract class AbstractTarotCard implements AbstractCard {
  bool isExcuse();
}
