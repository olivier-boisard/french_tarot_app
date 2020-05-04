import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'dimensions.dart';

abstract class AbstractCardWidget extends StatelessWidget {
  final Dimensions dimensions;

  const AbstractCardWidget({Key key, @required this.dimensions})
      : super(key: key);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Dimensions>('dimensions', dimensions));
  }
}
