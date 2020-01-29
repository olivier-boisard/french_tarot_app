import 'package:flutter/material.dart';
import 'package:french_tarot/areas.dart';

class GamePage extends StatefulWidget {

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
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
                      child: RotatedBox(
                        child: Area(),
                        quarterTurns: 1,
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
                      child: RotatedBox(
                        child: Area(),
                        quarterTurns: 3,
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
                child: Area(visibleHand: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}