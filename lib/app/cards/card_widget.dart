import 'package:flutter/cupertino.dart';

import '../../engine/core/abstract_tarot_card.dart';

abstract class AbstractCardWidget extends StatelessWidget {
  final AbstractTarotCard card;

  const AbstractCardWidget({Key key, @required this.card}) : super(key: key);
}
