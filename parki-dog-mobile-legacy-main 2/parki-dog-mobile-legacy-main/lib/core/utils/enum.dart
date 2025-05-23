import 'package:parki_dog/core/utils/values_manager.dart';

enum RequestState { loading, loaded, error }

enum ViewOrientation {
  orientationVertical(AppInt.i0),
  orientationHorizontal(AppInt.i1),
  orientationGrid(AppInt.i2),
  orientationFlexibleRow(AppInt.i3);

  final int value;

  const ViewOrientation(this.value);

  @override
  String toString() => value.toString();
}
