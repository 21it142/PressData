import 'package:pressdata/data/db.dart';

class PressureStats {
  final List<int> maxPressure;
  final List<DateTime> maxPressureTime;
  final List<int> minPressure;
  final List<DateTime> minPressureTime;
  final List<int> avgPressure;

  PressureStats({
    required this.maxPressure,
    required this.maxPressureTime,
    required this.minPressure,
    required this.minPressureTime,
    required this.avgPressure,
  });
}

PressureStats calculatePressureStats(
    List<PressDataTableData> data, List<String> selectedValues) {
  if (data.isEmpty) {
    return PressureStats(
      maxPressure: [],
      maxPressureTime: [],
      minPressure: [],
      minPressureTime: [],
      avgPressure: [],
    );
  }

  List<int> maxPressures = [];
  List<DateTime> maxPressureTimes = [];
  List<int> minPressures = [];
  List<DateTime> minPressureTimes = [];
  List<int> avgPressures = [];

  for (String value in selectedValues) {
    int maxPressure = data.first.getPressureValue(value);
    DateTime maxPressureTime = data.first.recordedAt!;
    int minPressure = data.first.getPressureValue(value);
    DateTime minPressureTime = data.first.recordedAt!;
    int totalPressure = 0;

    for (var record in data) {
      int currentPressure = record.getPressureValue(value);
      if (currentPressure > maxPressure) {
        maxPressure = currentPressure;
        maxPressureTime = record.recordedAt!;
      }
      if (currentPressure < minPressure) {
        minPressure = currentPressure;
        minPressureTime = record.recordedAt!;
      }
      totalPressure += currentPressure;
    }

    double avgPressure = (totalPressure / data.length);

    maxPressures.add(maxPressure);
    maxPressureTimes.add(maxPressureTime);
    minPressures.add(minPressure);
    minPressureTimes.add(minPressureTime);
    avgPressures.add(avgPressure.toInt());
  }

  return PressureStats(
    maxPressure: maxPressures,
    maxPressureTime: maxPressureTimes,
    minPressure: minPressures,
    minPressureTime: minPressureTimes,
    avgPressure: avgPressures,
  );
}

extension on PressDataTableData {
  int getPressureValue(String value) {
    switch (value) {
      case 'O2(1)':
        return o2;
      case 'TEMP':
        return temperature;
      case 'HUMI':
        return humidity;
      case 'AIR':
        return airPressure;
      case 'CO2':
        return co2;
      case 'N2O':
        return n2o;
      case 'VAC':
        return vac;
      case 'O2(2)':
        return o22;
      default:
        throw ArgumentError('Invalid value: $value');
    }
  }
}
