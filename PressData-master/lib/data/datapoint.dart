class DataPoint {
  final DateTime time;
  final double o2_1, n2o, air, co2, o2_2, vac, temp, humidity;

  DataPoint({
    required this.time,
    required this.o2_1,
    required this.n2o,
    required this.air,
    required this.co2,
    required this.o2_2,
    required this.vac,
    required this.temp,
    required this.humidity,
  });

  factory DataPoint.fromJson(Map<String, dynamic> json) {
    final timeString = json['Time'];
    final timeParts = timeString.split(":");

    // Parse the time and append today's date
    final now = DateTime.now();
    final parsedTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]), // Hours
      int.parse(timeParts[1]), // Minutes
    );

    return DataPoint(
      time: parsedTime,
      o2_1: (json['O2(1)'] as num).toDouble(),
      n2o: (json['N2O'] as num).toDouble(),
      air: (json['AIR'] as num).toDouble(),
      co2: (json['CO2'] as num).toDouble(),
      o2_2: (json['O2(2)'] as num).toDouble(),
      vac: (json['Vac'] as num).toDouble() * 10,
      temp: (json['Temp'] as num).toDouble(),
      humidity: (json['Humidity'] as num).toDouble(),
    );
  }
}
