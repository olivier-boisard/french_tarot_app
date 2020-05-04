import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'abstract_card_widget.dart';
import 'dimensions.dart';

class FaceDownCard extends AbstractCardWidget {

  const FaceDownCard({Key key, @required dimensions})
      : super(key: key, dimensions: dimensions);

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
