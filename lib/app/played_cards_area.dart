import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PlayedCardsArea extends StatelessWidget {
  final LinkedHashMap<int, Widget> playedCards;

  const PlayedCardsArea({Key key, this.playedCards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Map<int, Widget>>('playedCards', playedCards),
    );
  }
}
