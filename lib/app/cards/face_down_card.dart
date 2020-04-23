import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dimensions.dart';

class FaceDownCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardWidgetHeight,
      width: cardWidgetWidth,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(cardWidgetBorderRadius),
      ),
    );
  }
}
