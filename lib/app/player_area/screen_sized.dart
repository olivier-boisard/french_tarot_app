import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../core/dimensions.dart';


mixin ScreenSized on StatelessWidget {
  double get offsetInPixel => window.physicalSize.width / 70;

  Dimensions get dimensions => Dimensions.fromScreen();

  static Widget padWidget(Widget widget, double leftOffsetInPixels) {
    return Padding(
      padding: EdgeInsets.only(left: leftOffsetInPixels),
      child: widget,
    );
  }
}
