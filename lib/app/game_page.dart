import 'package:flutter/material.dart';

import '../engine/core/abstract_tarot_card.dart';
import 'cards/face_up_card.dart';
import 'core/dimensions.dart';

class GamePage extends StatelessWidget {
  final List<Widget> playerAreas;

  const GamePage({Key key, @required this.playerAreas}) : super(key: key);

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
                  //TODO there should be 4 card placeholders here
                  child: DragTarget<AbstractTarotCard>(
                    //TODO onWillAccept should check the card is allowed
                    //TODO onAccept should update app state
                    builder: (context, candidates, rejects) {
                      return candidates.isNotEmpty ?
                      FaceUpCard(
                        card: candidates.first,
                        dimensions: Dimensions.fromScreen(),
                      ) :
                      Container();
                    },
                  ),
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
