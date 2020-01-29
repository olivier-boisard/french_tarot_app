import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FaceDownCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = 0.04 * window.physicalSize.height;
    return Container(
      height: height,
      width: height / 2,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(height / 20),
      ),
    );
  }
}
