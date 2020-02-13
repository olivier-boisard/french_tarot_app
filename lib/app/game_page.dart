import 'package:flutter/material.dart';

import 'areas.dart';

class GamePage extends StatefulWidget {

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Expanded(
            flex: 1,
            child: Area(),
          ),
          Expanded( // Screen middle (left player, play area, right player)
            flex: 2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: const RotatedBox(
                      quarterTurns: 1,
                      child: Area(),
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
                      child: Area(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded( // Human Player
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: const Area(visibleHand: true),
            ),
          ),
        ],
      ),
    );
  }
}