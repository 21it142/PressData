import 'package:collection/collection.dart';

class Values {
  final double x;
  final double y;
  Values({required this.x, required this.y});
}

List<Values> get values {
  final data = <double>[10, 20, 30, 40, 50];
  return data
      .mapIndexed(((index, element) => Values(x: index.toDouble(), y: element)))
      .toList();
}
