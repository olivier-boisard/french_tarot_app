import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  final List<Widget> playerAreas;
  final Widget playedCardsArea;

  const GamePage({
    Key key,
    @required this.playerAreas,
    @required this.playedCardsArea
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (playerAreas.length != 4) {
      throw InvalidNumberOfPlayerAreasException();
    }

    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: playerAreas.last,
          ),
          Expanded(
            // Screen middle (left player, play area, right player)
            flex: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: playerAreas[2],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: playedCardsArea,
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: playerAreas[1],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // Human Player
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: playerAreas.first,
            ),
          ),
        ],
      ),
    );
  }
}

class InvalidNumberOfPlayerAreasException implements Exception {}
