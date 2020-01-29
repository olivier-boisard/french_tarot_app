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
              //TODO FractionallySizedBox?
              child: FractionallySizedBox( // Screen top (top player)
                widthFactor: 1.0,
                child: Area("Top Player"),
              ),
            ),
            Expanded( // Screen middle (left player, play area, right player)
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Area("Left Player"),
                  ),
                  Expanded(
                    flex: 2,
                    child: Area("Play Area"),
                  ),
                  Expanded(
                    flex: 1,
                    child: Area("Right Area"),
                  )
                ],
              ),
            ),
            Expanded( // Human Player
                child: Area("Human Player")
            )
          ],
        ),
      ),
    );
  }
}