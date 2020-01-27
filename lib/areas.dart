import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Area extends StatelessWidget {
  final String areaName;

  const Area(this.areaName, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //TODO remove this wrapper
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Center(
        child: Text(
          areaName,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
