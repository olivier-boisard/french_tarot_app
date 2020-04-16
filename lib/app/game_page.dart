import 'package:flutter/material.dart';

import '../engine/core/card.dart' as engine;
import 'areas/face_down_area.dart';
import 'areas/face_up_area.dart';

class GamePage extends StatefulWidget {
  final List<engine.Card> _visibleHand;

  const GamePage(this._visibleHand, {Key key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState(_visibleHand);
}

class _GamePageState extends State<GamePage> {
  final List<engine.Card> _visibleHand;

  _GamePageState(this._visibleHand);

  @override
  Widget build(BuildContext context) {
    const faceDownArea = FaceDownArea(_visibleHand.length);
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Expanded(
            flex: 1,
            child: faceDownArea,
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
                    child: const RotatedBox(
                      quarterTurns: 1,
                      child: faceDownArea,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: const RotatedBox(
                      quarterTurns: 3,
                      child: faceDownArea,
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
              //TODO this won't compile
              child: FaceUpArea(_visibleHand),
            ),
          ),
        ],
      ),
    );
  }
}
