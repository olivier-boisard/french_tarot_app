import 'dart:ui';

final cardWidgetHeight = 0.04 * window.physicalSize.height;
final cardWidgetWidth = cardWidgetHeight / 2;
final cardWidgetBorderRadius = cardWidgetHeight / 20;

class Dimensions {
  final double height;

  double get width => height / 2;

  double get borderRadius => height / 20;

  const Dimensions(this.height);

  Dimensions.fromScreen() : height=0.04 * window.physicalSize.height;
}
