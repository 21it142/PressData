// class PressData {
//   String type;
//   dynamic value;

//   PressData.fromJson(Map<String, dynamic> json)
//       : type = json['type'],
//         value = json['value'];

//   get serialNumber => null;

//   Map<String, dynamic> toJson() => {
//         'type': type,
//         'value': value,
//       };
//}
class PressData {
  String temperature;
  String humidity;
  String o2_1;
  String o2_2;
  String n2o;
  String vacuum;
  String air;
  String co2;
  String serialNo;
  String locationName;

  PressData({
    required this.temperature,
    required this.humidity,
    required this.o2_1,
    required this.o2_2,
    required this.n2o,
    required this.vacuum,
    required this.air,
    required this.co2,
    required this.serialNo,
    required this.locationName,
  });

  factory PressData.fromJson(Map<String, dynamic> json) {
    return PressData(
      temperature: json['Temperature'],
      humidity: json['Humidity'],
      o2_1: json['O2_1'],
      o2_2: json['O2_2'],
      n2o: json['N2O'],
      vacuum: json['Vacuum'],
      air: json['AIR'],
      co2: json['CO2'],
      serialNo: json['serialNo'],
      locationName: json['locationName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Temperature': temperature,
      'Humidity': humidity,
      'O2_1': o2_1,
      'O2_2': o2_2,
      'N2O': n2o,
      'Vacuum': vacuum,
      'AIR': air,
      'CO2': co2,
      'serialNo': serialNo,
      'locationName': locationName,
    };
  }
}
