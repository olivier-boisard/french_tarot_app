import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'player_area/screen_sized.dart';

class PlayedCardsArea extends StatefulWidget {
  final Map<PlayerLocation, Widget> playedCards;
  final Widget playTarget;

  const PlayedCardsArea({
    Key key,
    @required this.playedCards,
    this.playTarget,
  }) : super(key: key);

  @override
  _PlayerCardsAreaState createState() {
    return _PlayerCardsAreaState(
      playedCards: playedCards,
      playTarget: playTarget,
    );
  }
}

enum PlayerLocation {
  top,
  left,
  right,
  bottom
}

class _PlayerCardsAreaState extends State<PlayedCardsArea> with ScreenSized {
  final Map<PlayerLocation, Widget> playedCards;
  final Widget playTarget;

  _PlayerCardsAreaState({
    @required this.playedCards,
    this.playTarget,
  });

  @override
  Widget build(BuildContext context) {
    final cardPlaceHolder = Container(
      width: dimensions.width,
      height: dimensions.height,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: playedCards[PlayerLocation.top] ?? cardPlaceHolder,
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(),
              ),
              playedCards[PlayerLocation.left] ?? cardPlaceHolder,
              playedCards[PlayerLocation.right] ?? cardPlaceHolder,
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.topCenter,
            child: playedCards[PlayerLocation.bottom] ?? playTarget,
          ),
        ),
      ],
    );
  }
}
