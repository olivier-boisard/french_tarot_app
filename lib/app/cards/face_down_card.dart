import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/dimensions.dart';
import '../player_area/screen_sized.dart';

class FaceDownCard extends StatelessWidget with ScreenSized {
  FaceDownCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dimensions.height,
      width: dimensions.width,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Dimensions>('dimensions', dimensions));
  }
}
