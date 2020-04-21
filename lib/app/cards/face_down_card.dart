import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _cardWidgetHeight = 0.04 * window.physicalSize.height;
final _cardWidgetWidth = _cardWidgetHeight / 2;
final _cardWidgetBorderRadius = _cardWidgetHeight / 20;

class FaceDownCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _cardWidgetHeight,
      width: _cardWidgetWidth,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(_cardWidgetBorderRadius),
      ),
    );
  }
}
