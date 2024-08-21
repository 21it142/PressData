import 'package:pressdata/data/db.dart';

class Logs {
  List<String> parameter;
  List<DateTime> time;
  List<int> maxvalue;
  List<int> minvalue;
  List<String> log;

  Logs(
      {required this.parameter,
      required this.log,
      required this.maxvalue,
      required this.minvalue,
      required this.time});
}

Logs getlogs(List<ErrorTableData> data, List<String> selectedValues) {
  print("I am inside getlogs");
  if (data.isEmpty) {
    return Logs(
      parameter: [],
      maxvalue: [],
      minvalue: [],
      time: [],
      log: [],
    );
  }

  List<int> maxvalue = [];
  List<DateTime> time = [];
  List<int> minvalue = [];
  List<String> logSet = [];
  List<String> parameter = [];
  for (String value in selectedValues) {
    print("inside for");
    // int maxValue = data.first.getPressureValueMax(value);
    // int minValue = data.first.getPressureValueMin(value);
    // DateTime recordTime = data.first.recordedAt!;
    //  String logEntry = data.first.getlogslist(value);

    for (var record in data) {
      print("inside record");
      // String currentLog = record.getlogslist(value);
      //print("currentLog->>>>>>>>>>>$currentLog + $value");

      if (record.parameter == value) {
        parameter.add(record.parameter);
        minvalue.add(record.minValue);
        maxvalue.add(record.maxValue);
        logSet.add(record.logValue);
        time.add(record.recordedAt!);
      }
    }
  }

  return Logs(
    parameter: parameter,
    minvalue: minvalue,
    maxvalue: maxvalue,
    time: time,
    log: logSet,
  );
}

// extension on PressDataTableData {
//   int getPressureValueMax(String value) {
//     switch (value) {
//       case 'O2(1)':
//         return O2_1_max;
//       case 'TEMP':
//         return Temp_max;
//       case 'HUMI':
//         return Humi_max;
//       case 'AIR':
//         return air_max;
//       case 'CO2':
//         return co2_max;
//       case 'N2O':
//         return n2o_max;
//       case 'VAC':
//         return vac_max;
//       case 'O2(2)':
//         return o2_2_max;
//       default:
//         throw ArgumentError('Invalid value: $value');
//     }
//   }
// }

// extension on PressDataTableData {
//   int getPressureValueMin(String value) {
//     switch (value) {
//       case 'O2(1)':
//         return O2_1_min;
//       case 'TEMP':
//         return Temp_min;
//       case 'HUMI':
//         return Humi_min;
//       case 'AIR':
//         return air_min;
//       case 'CO2':
//         return co2_min;
//       case 'N2O':
//         return n2o_min;
//       case 'VAC':
//         return vac_min;
//       case 'O2(2)':
//         return o2_2_min;
//       default:
//         throw ArgumentError('Invalid value: $value');
//     }
//   }
// }

// extension on PressDataTableData {
//   String getlogslist(String value) {
//     switch (value) {
//       case 'O2(1)':
//         return o2_1_error;
//       case 'TEMP':
//         return temp_error;
//       case 'HUMI':
//         return humi_error;
//       case 'AIR':
//         return air_error;
//       case 'CO2':
//         return co2_error;
//       case 'N2O':
//         return n2o_error;
//       case 'VAC':
//         return vac_error;
//       case 'O2(2)':
//         return o2_2_error;
//       default:
//         throw ArgumentError('Invalid value: $value');
//     }
//   }
// }
