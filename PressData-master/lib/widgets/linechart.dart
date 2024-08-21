import 'dart:async';
import 'dart:convert';

import 'package:jetpack/livedata.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';
//import 'package:path/path.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:jetpack/jetpack.dart';
import 'package:pressdata/data/db.dart';
//import 'package:pressdata/data/entity/press_data_entity.dart';

import 'package:pressdata/models/model.dart';
import 'package:pressdata/screens/Limit%20Setting/AIR.dart';
import 'package:pressdata/screens/Limit%20Setting/HUMI.dart';
import 'package:pressdata/screens/Limit%20Setting/N2O.dart';
import 'package:pressdata/screens/Limit%20Setting/O2.dart';
import 'package:pressdata/screens/Limit%20Setting/O2_2.dart';
import 'package:pressdata/screens/Limit%20Setting/TEMP.dart';
import 'package:http/http.dart' as http;
import 'package:pressdata/screens/Past_Report.dart';
import 'package:pressdata/screens/ReportScreen.dart';
import 'package:pressdata/screens/main_page.dart';
import 'package:pressdata/screens/setting.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tuple/tuple.dart';
// import 'package:tuple/tuple.dart';

import '../screens/Limit Setting/CO2.dart';
import '../screens/Limit Setting/VAC.dart';

class LineCharWid extends StatefulWidget {
  LineCharWid({
    Key? key,
  }) : super(key: key);

  @override
  State<LineCharWid> createState() => _LineCharWidState();
}

class ChartData {
  ChartData(this.time, this.value);
  final int time;
  final double value;
}

class _LineCharWidState extends State<LineCharWid> with RouteAware {
  String serrialNo = "";
  String location = "";
  int time = 0;
  String o2_1_error = '';
  String o2_2_error = '';
  String n2o_error = '';
  String air_error = '';
  String vac_error = '';
  String co2_error = '';
  String temp_error = '';
  String humi_error = '';
  final db = PressDataDb();
  ChartSeriesController? _tempChartController;
  ChartSeriesController? _humiRateChartController;
  ChartSeriesController? _n2oRateChartController;
  ChartSeriesController? _airRateChartController;
  ChartSeriesController? _vacRateChartController;
  ChartSeriesController? _o21RateChartController;
  ChartSeriesController? _o22RateChartController;
  ChartSeriesController? _co2RateChartController;
  String buttonText = 'Mute';
  final StreamController<double> streamtemp = StreamController<double>();
  final StreamController<double> streamhumi = StreamController<double>();
  final StreamController<double> streamo22 = StreamController<double>();
  final StreamController<double> streamo21 = StreamController<double>();
  final StreamController<double> streamn2o = StreamController<double>();
  final StreamController<double> streamvac = StreamController<double>();
  final StreamController<double> streamair = StreamController<double>();
  final StreamController<double> streamco2 = StreamController<double>();
  StreamSubscription<double>? humisub;
  StreamSubscription<double>? tempsub;
  StreamSubscription<double>? o21sub;
  StreamSubscription<double>? o22sub;
  StreamSubscription<double>? co2sub;
  StreamSubscription<double>? airsub;
  StreamSubscription<double>? vacsub;
  StreamSubscription<double>? n2osub;
  final ValueNotifier<bool> isMuted = ValueNotifier<bool>(false);
  final AudioPlayer audioPlayer = AudioPlayer();
  List<ChartData> tempData = [];
  List<ChartData> humiData = [];
  List<ChartData> o21Data = [];
  List<ChartData> o22Data = [];
  List<ChartData> co2Data = [];
  List<ChartData> airData = [];
  List<ChartData> vacData = [];
  List<ChartData> n2oData = [];
  String unit_value = "0";
  String forair = '';
  dynamic retrive;
  final _tempDataStreamController = StreamController<int>.broadcast();
//  int _elapsedTime = 0;
  Timer? _timer;
  Timer? _errorTimer;
  int _currentErrorIndex = 0;
  // final MutableLiveData<String> errorNotifier =
  //     MutableLiveData("SYSTEM IS RUNNING OK");
  // Define a ValueNotifier for a list of error messages
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);
  List<String> errors = [];
  int value = 0;
  List<PressData> pressdata = [];
  StreamController<PressData> _streamData = StreamController();
//  StreamController<int> _storetemp = StreamController();
  StreamController<int> _streamDatatemp = StreamController();
  StreamController<int> _streamDatahumi = StreamController();
  StreamController<int> _streamDatao21 = StreamController();
  StreamController<int> _streamDatavac = StreamController();
  StreamController<int> _streamDatan2o = StreamController();
  StreamController<int> _streamDataair = StreamController();
  StreamController<int> _streamDataco2 = StreamController();
  StreamController<int> _streamDatao22 = StreamController();
  StreamController<String> _streamDataerror =
      StreamController<String>.broadcast();
  List<String> _message = [];
  bool _showButton = false;
  String message = "SYSTEM IS RUNNING OK";
  late int O2_maxLimit;
  late int O2_minLimit;
  late int VAC_maxLimit;
  late int VAC_minLimit;
  late int N2O_maxLimit;
  late int N2O_minLimit;
  late int AIR_maxLimit;
  late int AIR_minLimit;
  late int CO2_maxLimit;
  late int CO2_minLimit;
  late int O2_2_maxLimit;
  late int O2_2_minLimit;
  late int TEMP_maxLimit;
  late int TEMP_minLimit;
  late int HUMI_maxLimit;
  late int HUMI_minLimit;
  bool isMuted1 = false;
  int _currentIndex = 0;
  String _currentString = 'SYSTEM IS RUNNING OK';
  Set<String> _uniqueStrings = {};
  List<String> _uniqueStringList = [];
  int secondsElapsed = 0;
  late MutableLiveData<ChartData> chartDataNew;
  int count = 0;
  late int temp = 0,
      humi = 0,
      vac = 0,
      co2 = 0,
      o22 = 0,
      o21 = 0,
      air = 0,
      n2o = 0;
  String deviceNo = '';
  String locationId = '';
  late int temp1min = 0,
      humi1min = 0,
      vac1min = 0,
      co21min = 0,
      o221min = 0,
      o211min = 0,
      air1min = 0,
      n2o1min = 0;

  // Tuple2<int, int> get_min_max(String type) {
  //   fetchMin_Max8();

  //   return Tuple2(0, 0);
  // }
  Future<Tuple2<int, int>?> setMinMax(String gasName, String endpoint) async {
    var url = Uri.parse('http://192.168.4.1/$endpoint');
    final response = await http.get(url);

    final data = json.decode(response.body);
    print("DATA JSON RESPONSE-->$data");
    for (var jsondata in data) {
      Minmax minmax = Minmax.fromJson(jsondata);
      print("MIn max Type:${minmax.type}");
      if (minmax.type == gasName) {
        print("Max: ${minmax.max}");
        print("Min: ${minmax.min}");
        return Tuple2(minmax.max, minmax.min);
      }

      // switch (gasName) {
      //   case "O2_1_DATA":
      //     return Tuple2(minmax.max, minmax.min);

      //   default:
      //     return null;
    }
    return null;
  }

  void _initialData() {
    tempData.add(ChartData(60, -1));
    humiData.add(ChartData(60, -1));
    o21Data.add(ChartData(60, -1));
    o22Data.add(ChartData(60, -1));
    airData.add(ChartData(60, -1));
    vacData.add(ChartData(60, -1));
    co2Data.add(ChartData(60, -1));
    n2oData.add(ChartData(60, -1));
    airData.add(ChartData(0, -1));
    vacData.add(ChartData(0, -1));
    co2Data.add(ChartData(0, -1));
    n2oData.add(ChartData(0, -1));
    tempData.add(ChartData(0, -1));
    humiData.add(ChartData(0, -1));
    o21Data.add(ChartData(0, -1));
    o22Data.add(ChartData(0, -1));
  }

  int counter_temp_min = 0;
  int counter_temp_max = 0;
  int counter_temp_not = 0;
  int counter_humi_min = 0;
  int counter_humi_max = 0;
  int counter_humi_not = 0;
  int counter_o21_min = 0;
  int counter_o21_max = 0;
  int counter_o21_not = 0;
  int counter_o22_min = 0;
  int counter_o22_max = 0;
  int counter_o22_not = 0;
  int counter_co2_min = 0;
  int counter_co2_max = 0;
  int counter_co2_not = 0;
  int counter_air_min = 0;
  int counter_air_max = 0;
  int counter_air_not = 0;
  int counter_n2o_min = 0;
  int counter_n2o_max = 0;
  int counter_n2o_not = 0;
  int counter_vac_min = 0;
  int counter_vac_max = 0;
  int counter_vac_not = 0;

  Future<void> getdata() async {
    var url = Uri.parse('http://192.168.4.1/getdata');
    final response = await http.get(url);

    final data = json.decode(response.body);
    DateTime dateTime = DateTime.now();
    //List<String> errors = [];
    errors.clear();

    for (var jsonData in data) {
      PressData pressData = PressData.fromJson(jsonData);
      serrialNo = pressData.serialNo;
      location = pressData.locationName;
      // Temperature
      temp = int.parse(pressData.temperature);
      _streamDatatemp.sink.add(int.parse(pressData.temperature));
      streamtemp.add(temp.toDouble());
      if (temp == -333) {
        temp = 0;
        temp_error = 'No Error';
      } else if (temp < 3) {
        temp_error = 'Not Available';
        if (counter_temp_not < 2) {
          counter_temp_not++;
        }

        if (counter_temp_not == 1) {
          store_error('Temp', 'Not Available', TEMP_minLimit, TEMP_maxLimit,
              pressData.serialNo);
        }

        errors.add("TEMP is Not Available");
      } else if (temp > TEMP_maxLimit) {
        if (counter_temp_max < 2) {
          counter_temp_max++;
        }

        if (counter_temp_max == 1) {
          store_error(
              'Temp', 'HIGH', TEMP_minLimit, TEMP_maxLimit, pressData.serialNo);
        }
        print("->>>>I am Inside TEmp");

        errors.add("Temp is Above High Setting");
        print("heloooo i am inside this temp");
        temp_error = 'HIGH';
      } else if (temp < TEMP_minLimit) {
        if (counter_temp_min < 2) {
          counter_temp_min++;
        }

        if (counter_temp_min == 1) {
          store_error(
              'Temp', 'LOW', TEMP_minLimit, TEMP_maxLimit, pressData.serialNo);
        }

        errors.add("Temp is Below Low Setting");

        temp_error = 'LOW';
      } else {
        counter_temp_not = 0;
        counter_temp_max = 0;
        counter_temp_min = 0;
        temp_error = 'NO Error';
      }

      // Humidity
      humi = int.parse(pressData.humidity);
      _streamDatahumi.sink.add(humi);
      streamhumi.add(humi.toDouble());
      if (humi == -333) {
        humi = 0;
        humi_error = 'No Error';
      } else if (humi < 3) {
        if (counter_humi_not < 2) {
          counter_humi_not++;
        }

        if (counter_humi_not == 1) {
          store_error('Humi', 'Not Available', HUMI_minLimit, HUMI_maxLimit,
              pressData.serialNo);
        }
        errors.add("HUMI is Not Available");
        humi_error = 'Not Available';
      } else if (humi > HUMI_maxLimit) {
        if (counter_humi_max < 2) {
          counter_humi_max++;
        }

        if (counter_humi_max == 1) {
          store_error(
              'Humi', 'HIGH', HUMI_minLimit, HUMI_maxLimit, pressData.serialNo);
        }

        print("->>>humi is above high setting");
        errors.add("HUMI is Above High Setting");
        humi_error = 'HIGH';
      } else if (humi < HUMI_minLimit) {
        if (counter_humi_min < 2) {
          counter_humi_min++;
        }

        if (counter_humi_min == 1) {
          store_error(
              'Humi', 'LOW', HUMI_minLimit, HUMI_maxLimit, pressData.serialNo);
        }
        //
        errors.add("HUMI is Below Low Setting");
        humi_error = 'LOW';
      } else {
        counter_humi_max = 0;
        counter_humi_min = 0;
        counter_humi_not = 0;
        humi_error = 'No Error';
      }

      // O2_1
      o21 = int.parse(pressData.o2_1);
      _streamDatao21.sink.add(int.parse(pressData.o2_1));
      streamo21.add(o21.toDouble());
      if (o21 == -333) {
        o21 = 0;
        o2_1_error = 'No Error';
      } else if (o21 < 3) {
        if (counter_o21_not < 2) {
          print("not working fine");
          counter_o21_not++;
        }
        print("value of counter o21 =====$counter_o21_not");
        if (counter_o21_not == 1) {
          print("hello not working fine");

          store_error('O2(1)', 'Not Available', O2_minLimit, O2_maxLimit,
              pressData.serialNo);
        }

        errors.add("O2 (1) is Not Available");
        o2_1_error = 'Not Available';
      } else if (o21 > O2_maxLimit) {
        if (counter_o21_max < 2) {
          counter_o21_max++;
        }
        if (counter_o21_max == 1) {
          store_error(
              'O2(1)', 'HIGH', O2_minLimit, O2_maxLimit, pressData.serialNo);
        }

        errors.add("O2 (1) is Above High Setting");
        o2_1_error = 'HIGH';
      } else if (o21 < O2_minLimit) {
        if (counter_o21_min < 2) {
          counter_o21_min++;
        }
        if (counter_o21_min == 1) {
          store_error(
              'O2(1)', 'LOW', O2_minLimit, O2_maxLimit, pressData.serialNo);
        }

        print("->>>>I am Inside the O21");
        errors.add("O2 (1) is Below Low Setting");
        o2_1_error = 'LOW';
      } else {
        counter_o21_max = 0;
        counter_o21_min = 0;
        counter_o21_not = 0;
        o2_1_error = 'No Error';
      }

      // Vacuum
      vac = int.parse(pressData.vacuum);
      _streamDatavac.sink.add(int.parse(pressData.vacuum));
      streamvac.add(vac.toDouble());
      if (vac == -333) {
        vac = 0;
        vac_error = 'No Error';
      } else if (vac < 3) {
        if (counter_vac_not < 2) {
          counter_vac_not++;
        }
        if (counter_vac_not == 1) {
          store_error('VAC', 'Not Available', VAC_minLimit, VAC_maxLimit,
              pressData.serialNo);
        }

        errors.add("VAC is Not Available");
        vac_error = 'Not Available';
      } else if (vac > VAC_maxLimit) {
        if (counter_vac_max < 2) {
          counter_vac_max++;
        }
        if (counter_vac_max == 1) {
          store_error(
              'VAC', 'HIGH', VAC_minLimit, VAC_maxLimit, pressData.serialNo);
        }

        errors.add("VAC is Above High Setting");
        vac_error = 'HIGH';
      } else if (vac < VAC_minLimit) {
        if (counter_vac_min < 2) {
          counter_vac_min++;
        }
        if (counter_vac_min == 1) {
          store_error(
              'VAC', 'LOW', VAC_minLimit, VAC_maxLimit, pressData.serialNo);
        }

        errors.add("VAC is Below Low Setting");
        vac_error = 'LOW';
      } else {
        counter_vac_not = 0;
        counter_vac_max = 0;
        counter_vac_min = 0;
        vac_error = 'No Error';
      }

      // N2O
      n2o = int.parse(pressData.n2o);
      _streamDatan2o.sink.add(int.parse(pressData.n2o));
      streamn2o.add(n2o.toDouble());
      if (n2o == -333) {
        n2o = 0;
        n2o_error = 'No Error';
      } else if (n2o < 3) {
        if (counter_n2o_not < 2) {
          counter_n2o_not++;
        }
        if (counter_n2o_not == 1) {
          store_error('N2O', 'Not Available', N2O_minLimit, N2O_maxLimit,
              pressData.serialNo);
        }

        errors.add("N2O is Not Available");
        n2o_error = 'Not Available';
      } else if (n2o > N2O_maxLimit) {
        if (counter_n2o_max < 2) {
          counter_n2o_max++;
        }
        if (counter_n2o_max == 1) {
          store_error(
              'N2O', 'HIGH', N2O_minLimit, N2O_maxLimit, pressData.serialNo);
        }

        errors.add("N2O is Above High Setting");
        n2o_error = 'HIGH';
      } else if (n2o < N2O_minLimit) {
        if (counter_n2o_min < 2) {
          counter_n2o_min++;
        }
        if (counter_n2o_min == 1) {
          store_error(
              'N2O', 'LOW', N2O_minLimit, N2O_maxLimit, pressData.serialNo);
        }

        errors.add("N2O is Below Low Setting");
        n2o_error = 'LOW';
      } else {
        counter_n2o_min = 0;
        counter_n2o_max = 0;
        counter_n2o_not = 0;
        n2o_error = 'No Error';
      }

      // Air
      air = int.parse(pressData.air);
      _streamDataair.sink.add(int.parse(pressData.air));
      streamair.add(air.toDouble());
      if (air == -333) {
        air = 0;
        air_error = 'No Error';
        forair = '-333';
      } else if (air < 3) {
        if (counter_air_not < 2) {
          counter_air_not++;
        }
        if (counter_air_not == 1) {
          store_error('AIR', 'Not Available', AIR_minLimit, AIR_maxLimit,
              pressData.serialNo);
        }

        errors.add("AIR is Not Available");
        air_error = 'Not Available';
      } else if (air > AIR_maxLimit) {
        if (counter_air_max < 2) {
          counter_air_max++;
        }
        if (counter_air_max == 1) {
          store_error(
              'AIR', 'HIGH', AIR_minLimit, AIR_maxLimit, pressData.serialNo);
        }

        errors.add("AIR is Above High Setting");
        air_error = 'HIGH';
      } else if (air < AIR_minLimit) {
        if (counter_air_min < 2) {
          counter_air_min++;
        }
        if (counter_air_min == 1) {
          store_error(
              'AIR', 'LOW', AIR_minLimit, AIR_maxLimit, pressData.serialNo);
        }

        errors.add("AIR is Below Low Setting");
        air_error = 'LOW';
      } else {
        counter_air_max = 0;
        counter_air_max = 0;
        counter_air_not = 0;

        air_error = 'No Error';
        forair = 'No Error';
      }

      // CO2
      co2 = int.parse(pressData.co2);
      _streamDataco2.sink.add(int.parse(pressData.co2));
      streamco2.add(co2.toDouble());
      if (co2 == -333) {
        co2 = 0;
        co2_error = 'No Error';
      } else if (co2 < 3) {
        if (counter_co2_not < 2) {
          counter_co2_not++;
        }
        if (counter_co2_not == 1) {
          store_error('CO2', 'Not Available', CO2_minLimit, CO2_maxLimit,
              pressData.serialNo);
        }

        errors.add("CO2 is Not Available");
        co2_error = 'Not Available';
      } else if (co2 > CO2_maxLimit) {
        if (counter_co2_max < 2) {
          counter_co2_max++;
        }
        if (counter_co2_max == 1) {
          store_error(
              'CO2', 'HIGH', CO2_minLimit, CO2_maxLimit, pressData.serialNo);
        }

        // storedata_database();
        errors.add("CO2 is Above High Setting");
        co2_error = 'HIGH';
      } else if (co2 < CO2_minLimit) {
        if (counter_co2_min < 2) {
          counter_co2_min++;
        }
        if (counter_co2_min == 1) {
          store_error(
              'CO2', 'LOW', CO2_minLimit, CO2_maxLimit, pressData.serialNo);
        }

        // storedata_database();
        errors.add("CO2 is Below Low Setting");
        co2_error = 'LOW';
      } else {
        counter_co2_max = 0;
        counter_co2_min = 0;
        counter_co2_not = 0;
        co2_error = 'No Error';
      }

      // O2_2
      o22 = int.parse(pressData.o2_2);
      _streamDatao22.sink.add(int.parse(pressData.o2_2));
      streamo22.add(o22.toDouble());
      if (o22 == -333) {
        o22 = 0;
        o2_2_error = 'No Error';
      }
      //print("O22 Maximum$O2_2_maxLimit");
      else if (o22 < 3) {
        if (counter_o22_not < 2) {
          counter_co2_not++;
        }
        if (counter_o22_not == 1) {
          store_error('O2(2)', 'Not Available', O2_2_minLimit, O2_2_maxLimit,
              pressData.serialNo);
        }
        errors.add("O2 (2) is Not Available");
        o2_2_error = 'Not Available';
      } else if (o22 > O2_2_maxLimit) {
        if (counter_o22_max < 2) {
          counter_co2_max++;
        }
        if (counter_o22_max == 1) {
          store_error('O2(2)', 'HIGH', O2_2_minLimit, O2_2_maxLimit,
              pressData.serialNo);
        }

        print("O22 Maximum$O2_2_maxLimit");
        errors.add("O2 (2) is Above High Setting");
        o2_2_error = 'HIGH';
      } else if (o22 < O2_2_minLimit) {
        if (counter_o22_min < 2) {
          counter_co2_min++;
        }
        if (counter_o22_min == 1) {
          store_error(
              'O2(2)', 'LOW', O2_2_minLimit, O2_2_maxLimit, pressData.serialNo);
        }

        errors.add("O2 (2) is Below Low Setting");
        print("O22 Maximum$O2_2_minLimit");
        o2_2_error = 'LOW';
      } else {
        counter_o22_max = 0;
        counter_o22_min = 0;
        counter_o22_not = 0;
        o2_2_error = 'No Error';
      }
    }

    // Update the ValueNotifier with a single concatenated error message
    print("Errors detected: ${errors.join(', ')}");

    // Start error cycle if there are errors
    if (errors.isNotEmpty && (_errorTimer == null || !_errorTimer!.isActive)) {
      _startErrorCycle();
    } else if (errors.isEmpty && _errorTimer != null && _errorTimer!.isActive) {
      // Stop the timer if there are no errors
      print("Stopping error cycle as there are no errors.");
      _errorTimer!.cancel();
      errorNotifier.value = "All systems normal";
    }
    print("chartData.length ${chartData.length}");

    // Delay before fetching data again (optional)
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> store_error(
      String params, String log, int min, int max, String deviceno) async {
    final entity = ErrorTableCompanion(
      parameter: drift.Value(params), // Replace with actual parameter
      logValue: drift.Value(log), // Replace with actual log value
      minValue: drift.Value(min), // Replace with actual min value
      maxValue: drift.Value(max), // Replace with actual max value
      DeviceNo: drift.Value(deviceno),
      recordedAt: drift.Value(DateTime.now()),
    );
    copy_database();
    print("entity->>>>>>>>>>>>>>>>>>>>>$entity");
    await db.insertErrorData(entity);
  }

  Future<void> get1minData() async {
    var url = Uri.parse('http://192.168.4.1/getdata_1m');
    final response = await http.get(url);

    final data = json.decode(response.body);
    for (var jsonData in data) {
      PressData pressData = PressData.fromJson(jsonData);

      temp1min = int.parse(pressData.temperature);
      humi1min = int.parse(pressData.humidity);
      o211min = int.parse(pressData.o2_1);
      o221min = int.parse(pressData.o2_2);
      co21min = int.parse(pressData.co2);
      vac1min = int.parse(pressData.vacuum);
      n2o1min = int.parse(pressData.n2o);
      air1min = int.parse(pressData.air);
      print("I am beign called After 1 min");
      storedata_database();
    }
  }

  List<Color> _getGradientColors() {
    if (forair == '-333') {
      return [Colors.black, Colors.white];
    } else if (air < 3) {
      return [Colors.yellow, Colors.yellow];
    } else if (air < AIR_minLimit) {
      return [Colors.yellow, Colors.yellow];
    } else if (air > AIR_maxLimit) {
      return [Color.fromARGB(255, 182, 12, 0), Color.fromARGB(255, 182, 12, 0)];
    } else {
      return [Colors.black, Colors.white];
    }
  }

  List<LineSeries<ChartData, int>> _getlineSeries() {
    // Function to smooth data using a simple moving average
    //double x = DateTime.now().millisecondsSinceEpoch.toDouble();
    return [
      LineSeries<ChartData, int>(
          onRendererCreated: (ChartSeriesController controller) {
            _o21RateChartController = controller;
          },
          name: "O2(1)",
          color: Color.fromARGB(255, 0, 0, 0),
          dataSource: o21Data,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value),
      LineSeries<ChartData, int>(
        onRendererCreated: (ChartSeriesController controller) {
          _n2oRateChartController = controller;
        },
        name: "N2O",
        color: Color.fromARGB(255, 0, 34, 145),
        dataSource: n2oData,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
      ),
      LineSeries<ChartData, int>(
        onRendererCreated: (ChartSeriesController controller) {
          _airRateChartController = controller;
        },
        name: "AIR",
        color: Color.fromARGB(255, 17, 255, 148),
        dataSource: airData,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
      ),
      LineSeries<ChartData, int>(
        onRendererCreated: (ChartSeriesController controller) {
          _co2RateChartController = controller;
        },
        name: "CO2",
        color: Color.fromARGB(255, 90, 72, 72),
        dataSource: co2Data,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
      ),
      LineSeries<ChartData, int>(
        onRendererCreated: (ChartSeriesController controller) {
          _o22RateChartController = controller;
        },
        name: "o2 (2)",
        color: Color.fromARGB(255, 0, 0, 0),
        dataSource: o22Data,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
      ),
      LineSeries<ChartData, int>(
        onRendererCreated: (ChartSeriesController controller) {
          _vacRateChartController = controller;
        },
        name: "VAC",
        color: Colors.yellow,
        dataSource: vacData,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
        yAxisName: 'hello123456789',
      ),
      LineSeries<ChartData, int>(
        onRendererCreated: (ChartSeriesController controller) {
          _tempChartController = controller;
        },
        name: "Temp",
        color: Colors.red,
        dataSource: tempData,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
      ),
      LineSeries<ChartData, int>(
        onRendererCreated: (ChartSeriesController controller) {
          _humiRateChartController = controller;
        },
        name: "Humi",
        color: Colors.blue,
        dataSource: humiData,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
      ),
    ];
  }

  void updatedata() {}

  void _storeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      O2_maxLimit = prefs.getInt('O2_maxLimit') ?? 50;
      O2_minLimit = prefs.getInt('O2_minLimit') ?? 30;
      VAC_maxLimit = prefs.getInt('VAC_maxLimit') ?? 150;
      VAC_minLimit = prefs.getInt('VAC_minLimit') ?? 30;
      N2O_maxLimit = prefs.getInt('N2O_maxLimit') ?? 60;
      N2O_minLimit = prefs.getInt('N2O_minLimit') ?? 40;
      AIR_maxLimit = prefs.getInt('AIR_maxLimit') ?? 70;
      AIR_minLimit = prefs.getInt('AIR_minLimit') ?? 40;
      CO2_maxLimit = prefs.getInt('CO2_maxLimit') ?? 50;
      CO2_minLimit = prefs.getInt('CO2_minLimit') ?? 40;
      O2_2_maxLimit = prefs.getInt('O2_2_maxLimit') ?? 39;
      O2_2_minLimit = prefs.getInt('O2_2_minLimit') ?? 35;
      TEMP_maxLimit = prefs.getInt('TEMP_maxLimit') ?? 35;
      TEMP_minLimit = prefs.getInt('TEMP_minLimit') ?? 20;
      HUMI_maxLimit = prefs.getInt('HUMI_maxLimit') ?? 80;
      HUMI_minLimit = prefs.getInt('HUMI_minLimit') ?? 30;
      //   print(O2_2_maxLimit);
      print("ergfqweedf->>>>$AIR_maxLimit");
      print("dfetgbergetg->>>>$AIR_minLimit");
    });
  }

  List<ChartData> chartData = [];
  final StreamController<List<ChartData>> _streamController =
      StreamController<List<ChartData>>.broadcast();

  // Fixed color map for predefined types
  final Map<String, Color> colorMap = {
    'temperature': Color.fromARGB(255, 255, 0, 0),
    'humidity': Colors.blue,
    'o21': Color.fromARGB(255, 0, 0, 0),
    'vac': Colors.yellow,
    'n2o': Color.fromARGB(255, 0, 34, 145),
    'air': Color.fromARGB(113, 152, 181, 152),
    'co2': Color.fromRGBO(62, 66, 70, 1),
    'o22': const Color.fromARGB(255, 0, 0, 0),
  };

  // Fixed order of types for series
  final List<String> seriesOrder = [
    'o21',
    'n2o',
    'air',
    'co2',
    'o22',
    'vac',
    'temperature',
    'humidity',
  ];

  final LinearGradient gradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.blue, Colors.green], // Two colors for the gradient
  );
  // void _updateData(List<dynamic> data) {
  //   double x = DateTime.now().millisecondsSinceEpoch.toDouble();
  //   print('Received Data: $data');
  //   List<ChartData> newData = [];

  //   for (var entry in data) {
  //     if (entry['type'] != 'serialNo' && entry['type'] != 'locationName') {
  //       newData.add(ChartData(
  //           x, entry['value'].toDouble(), entry['type'], entry[''], entry['']));
  //     }
  //   }

  //   print('New Data: $newData');

  //   // Combine new data with existing data and keep only the most recent 60 data points
  //   setState(() {
  //     chartData.addAll(newData);
  //     // if (chartData.length > 60) {
  //     //   chartData.removeAt(0);
  //     // }

  //     // Add the updated data to the stream
  //     _streamController.add(List.from(newData));
  //   });
  // }

  bool isDataAvailable = true;
  bool isConnected = true;

  void checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          setState(() {
            isConnected = result != ConnectivityResult.none;
          });
        } as void Function(List<ConnectivityResult> event)?);
  }

  void _navigateToDetailPage(int index) async {
    print("helo123456789654324567890654");
    final BuildContext context = this.context;

    // Define a variable to hold the navigation result
    dynamic result;

    // Use a switch statement for clarity
    switch (index) {
      case 0:
        var minMax = await setMinMax("TEMP_DATA", "MinMax1");
        if (minMax != null)
          result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TEMP(
                      maxtemp: minMax.item1,
                      mintemp: minMax.item2,
                    )),
          );
        if (result == 1) {
          fetchMin_Max4();

          errors.clear();

          print("List of Errors: $errors");
        }
        break;
      case 1:
        fetchMin_Max4();
        print("Method Called");
        var minMax = await setMinMax("HUMI_DATA", "MinMax1");
        if (minMax != null)
          result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HUMI(
                      maxhumi: minMax.item1,
                      minhumi: minMax.item2,
                    )),
          );

        if (result == 1) {
          // errors.clear();
          // errorNotifier.value = null;
          // print("Error notifier.value ${errorNotifier.value}");
          // print("List of Errors: $errors");
          fetchMin_Max4();
        }
        break;
      case 2:
        print("I am In case 2 ");
        var minMax = await setMinMax("O2_1_DATA", "MinMax1");
        print("Hello below the minmax");
        if (minMax != null) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => O2(
                maxo2: minMax.item1,
                mino2: minMax.item2,
              ),
            ),
          );

          if (result == 1) {
            fetchMin_Max4();
            //  _loadLimits();
          }
        } else {
          print("MIn Max Null-- ${minMax}");
        }
        // Tuple2<int, int> minmax = setMinMax('Humi', 'MinMax1');
        // result = await Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => O2(
        //             maxo2: minmax,
        //             mino2: O2_minLimit,
        //           )),
        // );

        // if (result == 1) {
        //   //  print("helo123435679876543267896543");
        // }
        break;
      case 3:
        print("I am In case 3 ");
        var minMax = await setMinMax("VAC_DATA", "MinMax2");
        if (minMax != null)
          result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VAC(
                      maxvac: minMax.item1,
                      minvac: minMax.item2,
                    )),
          );
        if (result == 1) {
          fetchMin_Max8();
        }
        break;
      case 4:
        var minMax = await setMinMax("N2O_DATA", "MinMax1");
        if (minMax != null)
          result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => N2O(
                      max_n2o: minMax.item1,
                      min_n2o: minMax.item2,
                    )),
          );
        if (result == 1) {
          print("INside n20 pop");
          fetchMin_Max4();
        }
        break;
      case 5:
        var minMax = await setMinMax("AIR_DATA", "MinMax2");
        if (minMax != null)
          result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AIR(
                      max_air: minMax.item1,
                      min_air: minMax.item2,
                    )),
          );
        if (result == 1) {
          print("ebgertnrtgryh");
          fetchMin_Max8(); // Call the function when returning from the AIR screen
        }
        break;
      case 6:
        var minMax = await setMinMax("CO2_DATA", "MinMax2");
        if (minMax != null)
          result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CO2(
                      maxco2: minMax.item1,
                      minco2: minMax.item2,
                    )),
          );
        if (result == 1) {
          fetchMin_Max8();
        }
        break;
      case 7:
        var minMax = await setMinMax("O2_2_DATA", "MinMax2");
        if (minMax != null)
          result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => O2_2(
                      maxo22: minMax.item1,
                      mino22: minMax.item2,
                    )),
          );
        if (result == 1) {
          fetchMin_Max8();
        }
        break;
      case 8:
        result = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => ReportScreenPast()));
        if (result == 1) {
          fetchMin_Max4();
          fetchMin_Max8();
        }
      case 9:
        result = await Navigator.push(
            context, MaterialPageRoute(builder: (context) => Setting1()));
        if (result == 1) {
          fetchMin_Max4();
          fetchMin_Max8();
        }
      default:
        print("Invalid index");
        break;
    }
  }

  late StreamController<void> _updateController;
  late StreamSubscription<void> _streamSubscription;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchMin_Max4();
  //   fetchMin_Max8();
  //   _storeData();
  //   _message.clear();
  //   _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
  //     setState(() {
  //       if (_currentIndex > _message.length + 19) {
  //         _currentIndex = 0;
  //       }

  //       if (_message.isNotEmpty) {
  //         _currentIndex = (_currentIndex + 1) % _message.length;
  //       }
  //     });
  //   });

  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       // Trigger the cleanup and update the chart
  //       _storeData();
  //       //  _getSplineSeries();
  //     });

  //     Stream.periodic(Duration(seconds: 1), (_) {
  //       _streamDataerror;
  //     });
  //   });
  //   // Timer.periodic(const Duration(seconds: 1), (timer) {
  //   //   hello();
  //   // });
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     _updateController.add(null);
  //   });
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     getdata();
  //   });
  // }
  // void didChangeDependencies() {
  //   print("hellooo i am inside didchangedependency");
  //   super.didChangeDependencies();
  //   // Call your methods here
  //   fetchMin_Max4();
  //   fetchMin_Max8();
  // }
  bool _isFirstBuild = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstBuild) {
      print("is called isBuild");
      // It's the first time the page is being built
      _isFirstBuild = false;
      errorNotifier.value = null;
      print("Hello this is in did change dependencies: ${errorNotifier.value}");
      fetchMin_Max4();

      // Obtain the RouteObserver from the widget tree
      final RouteObserver<PageRoute>? routeObserver = ModalRoute.of(context)
          ?.settings
          .arguments as RouteObserver<PageRoute>?;
      if (routeObserver != null) {
        routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
      } // Update the flag to avoid calling this code again
    } else {
      // Not the first time the page is being built
      print("Inside did change dependencies");
      errorNotifier.value = null;
      storedata_database();
      print("Hello this is in did change dependencies: ${errorNotifier.value}");
      fetchMin_Max4();

      // Obtain the RouteObserver from the widget tree
      final RouteObserver<PageRoute>? routeObserver = ModalRoute.of(context)
          ?.settings
          .arguments as RouteObserver<PageRoute>?;
      if (routeObserver != null) {
        routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
      }
    }
  }

  int timeime = 0;
  @override
  void didPopNext() {
    // Called when this route is resumed after another route has been popped off
    super.didPopNext();
    // Call your methods here when coming back to this page
    //  errorNotifier.value = null;
    fetchMin_Max4();
    fetchMin_Max8();
    errors.clear();
  }

  final AudioPlayer bgAudio = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initialData();
    loadMuteState();
    fetchMin_Max4();
    fetchMin_Max8();
    _storeData();
    _startTimer();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _storeData();
    });

    _message.clear();
    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      get1minData();
    });
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      setState(() {
        if (_currentIndex > _message.length + 9) {
          _currentIndex = 0;
        }

        if (_message.isNotEmpty) {
          _currentIndex = (_currentIndex + 1) % _message.length;
        }
      });
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchMin_Max4();
      fetchMin_Max8();
    });
    updatedata();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      updatedata();
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateController.add(null);
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      timeime++;
      getdata();
      _updateString();
    });

    tempsub = streamtemp.stream.listen((data) {
      setState(() {
        tempData.add(ChartData(timeime, data));
        if (tempData.length > 60) tempData.removeAt(0);
      });

      _updateDataSource();
    });
    humisub = streamhumi.stream.listen((data) {
      setState(() {
        humiData.add(ChartData(timeime, data));
        if (humiData.length > 60) humiData.removeAt(0);
        // _latestPurity = data;
      });

      _updateDataSource();
    });
    o21sub = streamo21.stream.listen((data) {
      setState(() {
        o21Data.add(ChartData(timeime, data));
        if (o21Data.length > 60) o21Data.removeAt(0);
        // _latestPurity = data;
      });

      _updateDataSource();
    });
    o22sub = streamo22.stream.listen((data) {
      setState(() {
        o22Data.add(ChartData(timeime, data));
        if (o22Data.length > 60) o22Data.removeAt(0);
        // _latestPurity = data;
      });

      _updateDataSource();
    });
    co2sub = streamco2.stream.listen((data) {
      setState(() {
        co2Data.add(ChartData(timeime, data));
        if (co2Data.length > 60) co2Data.removeAt(0);
        // _latestPurity = data;
      });

      _updateDataSource();
    });
    n2osub = streamn2o.stream.listen((data) {
      setState(() {
        n2oData.add(ChartData(timeime, data));
        if (n2oData.length > 60) n2oData.removeAt(0);
        // _latestPurity = data;
      });

      _updateDataSource();
    });
    airsub = streamair.stream.listen((data) {
      setState(() {
        airData.add(ChartData(timeime, data));
        if (airData.length > 60) airData.removeAt(0);
        // _latestPurity = data;
      });

      _updateDataSource();
    });
    vacsub = streamvac.stream.listen((data) {
      setState(() {
        vacData.add(ChartData(timeime, data));
        if (vacData.length > 60) vacData.removeAt(0);
        // _latestPurity = data;
      });

      _updateDataSource();
    });
  }

  Future<void> loadMuteState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isMuted1 = prefs.getBool('isMuted1') ?? false;
    });
  }

  Future<void> saveMuteState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMuted1', value);
  }

  void playBackgroundMusic() {
    bgAudio.play(
      AssetSource('beep.mp3'),
      volume: isMuted1 ? 0.0 : 1.0,
    );
  }

  void stopBackgroundMusic() {
    print("Stopinng background sound");
    bgAudio.stop();
  }

  void toggleMute() {
    setState(() {
      isMuted1 = !isMuted1;
      saveMuteState(isMuted1);

      if (isMuted1) {
        bgAudio.setVolume(0.0);
      } else {
        playBackgroundMusic();
      }
    });
  }

  void _startTimer() {
    Timer(Duration(minutes: 1), () {
      setState(() {
        _showButton = true;
      });
    });
  }

  // String secondsToTime(int seconds) {
  //   int minutes = seconds ~/ 60;
  //   int remainingSeconds = seconds % 60;
  //   String minutesStr = minutes.toString().padLeft(2, '0');
  //   String secondsStr = remainingSeconds.toString().padLeft(2, '0');
  //   return '$minutesStr:$secondsStr';
  // }

  void _updateDataSource() {
    _tempChartController?.updateDataSource(
      addedDataIndex: tempData.length - 1,
      removedDataIndex: tempData.length > 1 ? 0 : -1,
    );
    _humiRateChartController?.updateDataSource(
      addedDataIndex: humiData.length - 1,
      removedDataIndex: humiData.length > 1 ? 0 : -1,
    );
    _o21RateChartController?.updateDataSource(
      addedDataIndex: o21Data.length - 1,
      removedDataIndex: o21Data.length > 1 ? 0 : -1,
    );
    _n2oRateChartController?.updateDataSource(
      addedDataIndex: tempData.length - 1,
      removedDataIndex: tempData.length > 1 ? 0 : -1,
    );
    _o22RateChartController?.updateDataSource(
      addedDataIndex: o22Data.length - 1,
      removedDataIndex: o22Data.length > 1 ? 0 : -1,
    );
    _vacRateChartController?.updateDataSource(
      addedDataIndex: vacData.length - 1,
      removedDataIndex: vacData.length > 1 ? 0 : -1,
    );
    _airRateChartController?.updateDataSource(
      addedDataIndex: airData.length - 1,
      removedDataIndex: airData.length > 1 ? 0 : -1,
    );
    _co2RateChartController?.updateDataSource(
      addedDataIndex: co2Data.length - 1,
      removedDataIndex: co2Data.length > 1 ? 0 : -1,
    );
  }

  void _addString(String value) {
    setState(() {
      _uniqueStrings.add(value);
      _uniqueStringList = _uniqueStrings.toList();
      _resetIndexIfNeeded();
    });
  }

  void _removeString(String value) {
    setState(() {
      _uniqueStrings.remove(value);
      _uniqueStringList = _uniqueStrings.toList();
      _resetIndexIfNeeded();
    });
  }

  void _resetIndexIfNeeded() {
    if (_currentIndex >= _uniqueStringList.length) {
      _currentIndex = 0;
    }
  }

  void _updateCurrentString() {
    setState(() {
      if (_uniqueStringList.isNotEmpty) {
        _currentString = _uniqueStringList[_currentIndex];
        _currentIndex = (_currentIndex + 1) % _uniqueStringList.length;
      } else {
        _currentString = 'SYSTEM IS RUNNING OK';
      }
    });
  }

  void _updateString() {
    if (o21 > O2_maxLimit || o21 < O2_minLimit) {
      _addString("Purity is out of range");
    } else {
      _removeString("Purity is out of range");
    }
    if (o21 < 3) {
      _addString("O21 is Not available");
    } else {
      _removeString("O21 is Not available");
    }

    if (temp > TEMP_maxLimit || temp < TEMP_minLimit) {
      _addString("Flow is out of range");
    } else {
      _removeString("Flow is out of range");
    }

    if (co2 > CO2_maxLimit || co2 < CO2_minLimit) {
      _addString("Pressure is out of range");
    } else {
      _removeString("Pressure is out of range");
    }
    if (co2 < 3) {
      print("co2$co2");
      print("helllllooooooooo");
      _addString("CO2 is Not available");
    } else {
      _removeString("CO2 is not available ");
    }

    if (vac > VAC_maxLimit || vac < VAC_minLimit) {
      _addString("Temp is out of range");
    } else {
      _removeString("Temp is out of range");
    }
  }

  @override
  void dispose() {
    _updateController.close(); // Close the stream controller
    _streamSubscription.cancel();
    _streamDataerror.close(); // Cancel the subscription
    _streamDatatemp.close();
    _streamDataair.close();
    _streamDatao21.close();
    _streamDatahumi.close();
    _streamDatao22.close();
    _streamDatavac.close();
    _streamDataco2.close();
    _streamDatan2o.close();
    _tempDataStreamController.close();
    _streamData.close();
    _timer?.cancel();
    final RouteObserver<PageRoute>? routeObserver =
        ModalRoute.of(context)?.settings.arguments as RouteObserver<PageRoute>?;
    if (routeObserver != null) {
      routeObserver.unsubscribe(this);
    }
    super.dispose();
  }

  Future<void> fetchMin_Max4() async {
    var url = Uri.parse('http://192.168.4.1/MinMax1');
    final response = await http.get(url);

    final data = json.decode(response.body);

    for (var jsondata in data) {
      Minmax minmax = Minmax.fromJson(jsondata);
      if (minmax.type == 'TEMP_DATA') {
        int min = minmax.min;
        int max = minmax.max;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setInt(
            'TEMP_maxLimit',
            max,
          );
          prefs.setInt(
            'TEMP_minLimit',
            min,
          );
        });
      }
      if (minmax.type == 'O2_1_DATA') {
        int min = minmax.min;
        int max = minmax.max;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setInt(
            'O2_maxLimit',
            max,
          );
          prefs.setInt(
            'O2_minLimit',
            min,
          );
        });
      }
      if (minmax.type == 'N2O_DATA') {
        int min = minmax.min;
        int max = minmax.max;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setInt(
            'N2O_maxLimit',
            max,
          );
          prefs.setInt(
            'N2O_minLimit',
            min,
          );
        });
      }
      if (minmax.type == 'HUMI_DATA') {
        int min = minmax.min;
        int max = minmax.max;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setInt(
            'HUMI_maxLimit',
            max,
          );
          prefs.setInt(
            'HUMI_minLimit',
            min,
          );
        });
      }
    }
  }

  Future<void> fetchMin_Max8() async {
    var url = Uri.parse('http://192.168.4.1/MinMax2');
    final response = await http.get(url);

    final data = json.decode(response.body);

    for (var jsondata in data) {
      Minmax minmax = Minmax.fromJson(jsondata);
      if (minmax.type == 'CO2_DATA') {
        int min = minmax.min;
        int max = minmax.max;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setInt(
            'CO2_maxLimit',
            max,
          );
          prefs.setInt(
            'CO2_minLimit',
            min,
          );
        });
      }
      if (minmax.type == 'O2_2_DATA') {
        int min = minmax.min;
        int max = minmax.max;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setInt(
            'O2_2_maxLimit',
            max,
          );
          prefs.setInt(
            'O2_2_minLimit',
            min,
          );
        });
      }
      if (minmax.type == 'AIR_DATA') {
        int min = minmax.min;
        int max = minmax.max;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setInt(
            'AIR_maxLimit',
            max,
          );
          print("erfwrer->>>>>>>$AIR_maxLimit");
          prefs.setInt(
            'AIR_minLimit',
            min,
          );
        });
      }
      if (minmax.type == 'VAC_DATA') {
        int min = minmax.min;
        int max = minmax.max;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setInt(
            'VAC_maxLimit',
            max,
          );
          prefs.setInt(
            'VAC_minLimit',
            min,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDataAvailable = chartData.isNotEmpty;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    final List<Color> parameterColors = [
      const Color.fromARGB(255, 195, 0, 0),
      Color.fromARGB(255, 177, 218, 253),
      Colors.white,
      Colors.yellow,
      const Color.fromARGB(255, 17, 136, 234),
      const Color.fromARGB(255, 198, 230, 255),
      Colors.grey,
      const Color.fromARGB(255, 255, 255, 255),
    ];
    final List<Color> parameterTextColor = [
      const Color.fromARGB(255, 255, 255, 255),
      Color.fromARGB(255, 0, 0, 0),
      const Color.fromARGB(255, 0, 0, 0),
      const Color.fromARGB(255, 0, 0, 0),
      const Color.fromARGB(255, 255, 255, 255),
      const Color.fromARGB(255, 0, 0, 0),
      const Color.fromARGB(255, 255, 255, 255),
      const Color.fromARGB(255, 0, 0, 0),
    ];

    int count = 0;
    List parameterUnit = [
      "°C",
      "%",
      "PSI",
      "mmHg",
      "PSI",
      "PSI",
      "PSI",
      "PSI",
    ];
    List parameterNames = [
      "TEMP",
      "HUMI",
      "O2(1)",
      "VAC",
      "N₂O", // Subscript NO₂ for NO2
      "AIR",
      "CO₂", // Subscript CO₂ for CO2
      "O₂(2)", // Subscript O₂ for O2(2)
    ];
    Color cardColorn2o = Color.fromARGB(255, 0, 34, 145);
    Color cardColoro21 = Colors.white;
    Color cardColoro22 = Colors.white;
    Color cardColortemp = Color.fromARGB(288, 100, 128, 100);
    Color cardColorhumi = Colors.blue;
    Color cardColorair = Colors.grey;
    Color cardColorco2 = Colors.grey;
    Color cardColorvac = Colors.yellow;
    switch (o2_1_error) {
      case 'LOW':
        cardColoro21 = Colors.yellow;
        break;
      case 'Not Available':
        cardColoro21 = Colors.yellow;
      case 'HIGH':
        cardColoro21 = Color.fromARGB(255, 182, 12, 0);
        break;
      default:
        cardColoro21 = parameterColors[2];
    }
    switch (o2_2_error) {
      case 'LOW':
        print("I am inside swithc case low");
        cardColoro22 = Colors.yellow;
        break;
      case 'Not Available':
        print("I am inside swithc case low");
        cardColoro22 = Colors.yellow;
        break;
      case 'HIGH':
        cardColoro22 = Color.fromARGB(255, 182, 12, 0);
        break;
      default:
        cardColoro22 = parameterColors[7];
    }
    switch (temp_error) {
      case 'LOW':
        cardColortemp = Colors.yellow;
        break;
      case 'Not Available':
        cardColortemp = Colors.yellow;
        break;
      case 'HIGH':
        parameterTextColor[0] = Colors.black;
        cardColortemp = Color.fromARGB(255, 182, 12, 0);
        break;
      default:
        cardColortemp = Color.fromARGB(255, 202, 63, 4);
    }
    switch (humi_error) {
      case 'LOW':
        cardColorhumi = Colors.yellow;
        break;
      case 'Not Available':
        cardColorhumi = Colors.yellow;
        break;
      case 'HIGH':
        cardColorhumi = Color.fromARGB(255, 182, 12, 0);
        break;
      default:
        cardColorhumi = parameterColors[1];
    }
    switch (vac_error) {
      case 'LOW':
        cardColorvac = Colors.yellow;
        break;
      case 'Not Available':
        cardColorvac = Colors.yellow;
        break;
      case 'HIGH':
        cardColorvac = Color.fromARGB(255, 182, 12, 0);
        break;
      default:
        cardColorvac = parameterColors[3];
    }
    switch (n2o_error) {
      case 'LOW':
        cardColorn2o = Colors.yellow;
        parameterTextColor[4] = Colors.black;
        break;
      case 'Not Available':
        cardColorn2o = Colors.yellow;
        parameterTextColor[4] = Colors.black;
        break;
      case 'HIGH':
        cardColorn2o = Color.fromARGB(255, 182, 12, 0);

        break;
      default:
        cardColorn2o = parameterColors[4];
        parameterTextColor[4] = Colors.white;
    }
    switch (co2_error) {
      case 'LOW':
        cardColorco2 = Colors.yellow;
        parameterTextColor[6] = Colors.black;
        break;
      case 'Not Available':
        cardColorco2 = Colors.yellow;
        parameterTextColor[6] = Colors.black;
        break;
      case 'HIGH':
        cardColorco2 = Color.fromARGB(255, 182, 12, 0);
        break;
      default:
        cardColorco2 = parameterColors[6];
    }
    switch (air_error) {
      case 'LOW':
        cardColorair = Colors.yellow;
        break;
      case 'Not Available':
        cardColorair = Colors.yellow;
        break;
      case 'HIGH':
        cardColorair = Color.fromARGB(255, 182, 12, 0);
        break;
      default:
        cardColorair = parameterColors[5];
    }

    return Scaffold(
      body: Column(children: [
        Expanded(
          flex: 11,
          child: Row(
            children: [
              // Graph on the left
              Expanded(
                child: Container(
                  // height: 350, // Adjust height here
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isConnected
                        ? SfCartesianChart(
                            tooltipBehavior: TooltipBehavior(enable: false),
                            axes: <ChartAxis>[
                              NumericAxis(
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(132, 0, 0, 0)),
                                name: 'hello123456789',
                                opposedPosition: false,
                                interval: 150,
                                minimum: 0,
                                maximum: 750,
                              ),
                            ],
                            primaryXAxis: NumericAxis(
                              interval: 10,
                              labelFormat: '{value}',
                              axisLabelFormatter:
                                  (AxisLabelRenderDetails details) {
                                int value = details.value.toInt();
                                int minutes = value ~/ 60;
                                int seconds = value % 60;
                                String formattedTime =
                                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                                return ChartAxisLabel(formattedTime,
                                    TextStyle(color: Colors.black));
                              },
                            ),
                            primaryYAxis: NumericAxis(
                              name: "nohello",
                              interval: 20,
                              minimum: 0,
                              maximum: 100,
                            ),
                            legend: Legend(isVisible: true),
                            series: _getlineSeries(),
                          )
                        // child: StreamBuilder<int>(
                        //     stream: _streamDatahumi.stream,
                        //     builder: (context, snapshot) {
                        //       print("DAta is ${snapshot.data}");
                        //       List<int> list = [];
                        //       list.add(snapshot.data!);
                        //       return SfCartesianChart(
                        //         // isTransposed: true,
                        //         zoomPanBehavior: ZoomPanBehavior(
                        //           enablePinching: true,
                        //           enableMouseWheelZooming: true,
                        //           zoomMode:
                        //               ZoomMode.xy, // Specify zoom mode if needed
                        //           maximumZoomLevel: 0.5,
                        //         ),
                        //         tooltipBehavior: TooltipBehavior(enable: false),
                        //         axes: <ChartAxis>[
                        //           NumericAxis(
                        //             labelStyle: TextStyle(
                        //               color: Color.fromARGB(
                        //                   255, 0, 0, 0), // Black color
                        //               fontWeight: FontWeight.bold, // Bold text
                        //             ),
                        //             name: 'hello123456789',
                        //             opposedPosition: false,
                        //             interval: 150,
                        //             minimum: 0,
                        //             maximum: 750,
                        //           ),
                        //         ],
                        //         // primaryXAxis: NumericAxis(
                        //         //   labelStyle: TextStyle(
                        //         //     color: Color.fromARGB(
                        //         //         255, 0, 0, 0), // Black color
                        //         //     fontWeight: FontWeight.bold, // Bold text
                        //         //   ),
                        //         //   title: AxisTitle(
                        //         //     text: 'Time (s)',
                        //         //     textStyle: TextStyle(
                        //         //       color: Color.fromARGB(
                        //         //           255, 0, 0, 0), // Black color
                        //         //       fontWeight: FontWeight.bold, // Bold text
                        //         //     ),
                        //         //   ),
                        //         //   interval: 10,
                        //         //   edgeLabelPlacement: EdgeLabelPlacement.shift,
                        //         //   majorGridLines: MajorGridLines(width: 1),
                        //         // ),
                        //         primaryXAxis: CategoryAxis(
                        //           interval: 10,
                        //         ),
                        //         primaryYAxis: NumericAxis(
                        //           edgeLabelPlacement: EdgeLabelPlacement.shift,
                        //           name: "nohello",
                        //           labelStyle: TextStyle(
                        //             color: Color.fromARGB(
                        //                 255, 0, 0, 0), // Black color
                        //             fontWeight: FontWeight.bold, // Bold text
                        //           ),
                        //           interval: 20,
                        //           minimum: 0,
                        //           maximum: 100,
                        //         ),
                        //         legend: Legend(isVisible: true),

                        //         series: _getSplineSeries(list),
                        //       );
                        // })
                        // : Center(
                        //     child: CircularProgressIndicator(),
                        //   )
                        : Dashboard(),
                  ),
                ),
              ),
              // Parameters on the right

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToDetailPage(2),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: cardColoro21,
                            elevation: 4.0,
                            child: StreamBuilder<int>(
                                stream: _streamDatao21.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    int pressData = snapshot.data!;
                                    int data = pressData;

                                    // String type = data.type;
                                    String value = data.toString();

                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (value == '-333')
                                                Text(
                                                  'NC',
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[2],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (data > 10)
                                                if (value != '-333')
                                                  Text(
                                                    value,
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[2],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data > 10)
                                                const SizedBox(width: 15),
                                              if (data > 10)
                                                if (value != '-333')
                                                  Text(
                                                    parameterUnit[2],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[2],
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                if (value != '-333')
                                                  Text(
                                                    '0',
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[2],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data != -333)
                                                if (data < 10)
                                                  Text(
                                                    value[0],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[2],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                const SizedBox(width: 15),
                                              if (data < 10)
                                                if (value != '-333')
                                                  Text(
                                                    parameterUnit[2],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[2],
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[2],
                                            style: TextStyle(
                                              color: parameterTextColor[2],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                  color: parameterTextColor[2],
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                parameterUnit[2],
                                                style: TextStyle(
                                                  color: parameterTextColor[2],
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[2],
                                            style: TextStyle(
                                              color: parameterTextColor[2],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToDetailPage(4),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: cardColorn2o,
                            elevation: 4.0,
                            child: StreamBuilder<int>(
                                stream: _streamDatan2o.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    int pressData = snapshot.data!;
                                    int data = pressData;
                                    //  String type = data.type;
                                    String value = data.toString();
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (value == '-333')
                                                Text(
                                                  'NC',
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[4],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (data > 10)
                                                if (value != '-333')
                                                  Text(
                                                    value,
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[4],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data > 10)
                                                const SizedBox(width: 15),
                                              if (data > 10)
                                                if (value != '-333')
                                                  Text(
                                                    parameterUnit[4],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[4],
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                if (value != '-333')
                                                  Text(
                                                    '0',
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[4],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                if (data != -333)
                                                  Text(
                                                    value[0],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[4],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                const SizedBox(width: 15),
                                              if (data < 10)
                                                if (value != '-333')
                                                  Text(
                                                    parameterUnit[4],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[4],
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[4],
                                            style: TextStyle(
                                              color: parameterTextColor[4],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                  color: parameterTextColor[4],
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              if (value != '-333')
                                                Text(
                                                  parameterUnit[4],
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[4],
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[4],
                                            style: TextStyle(
                                              color: parameterTextColor[4],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToDetailPage(5),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.19,
                          width: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _getGradientColors(),
                              stops: [0.5, 0.5], // Half black, half white
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                14.0), // Adjust the radius if needed
                          ),
                          child: Stack(
                            children: [
                              StreamBuilder<int>(
                                stream: _streamDataair.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    int pressData = snapshot.data!;
                                    int data = pressData;
                                    String value = data.toString();
                                    print("data $data");
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 12,
                                              ),
                                              if (value == '-333')
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              if (value == '-333')
                                                Text(
                                                  'N',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255,
                                                        255,
                                                        255,
                                                        255), // On black background
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (value == '-333')
                                                SizedBox(
                                                  width: 12,
                                                ),
                                              if (value == '-333')
                                                Text(
                                                  'C',
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0), // On black background
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (data > 10)
                                                SizedBox(
                                                  width: 15,
                                                ),
                                              if (data > 10)
                                                Text(
                                                  value[0],
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255,
                                                        255,
                                                        255,
                                                        255), // On black background
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),

                                              if (value != '-333')
                                                if (data > 10)
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                              if (data > 10)
                                                Text(
                                                  value[1],
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0), // On black background
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              //if (value.length > 1)
                                              if (data > 10)
                                                if (value != '-333')
                                                  const SizedBox(width: 5),
                                              if (data > 10)
                                                if (value != '-333')
                                                  Text(
                                                    parameterUnit[5],
                                                    style: TextStyle(
                                                      color: const Color
                                                          .fromARGB(255, 0, 0,
                                                          0), // On black background
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                              if (data < 10 && data < 3)
                                                if (data != -333)
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                              if (data < 10 && data < 3)
                                                if (data != -333)
                                                  Text(
                                                    '0',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0), // On black background
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10 && data > 3)
                                                Text(
                                                  '0',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0), // On black background
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (value != '-333')
                                                if (data < 10)
                                                  Text(
                                                    value[0],
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0), // On black background
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              //if (value.length > 1)
                                              if (data < 10)
                                                if (value != '-333')
                                                  const SizedBox(width: 10),
                                              if (data < 10)
                                                if (value != '-333')
                                                  Text(
                                                    parameterUnit[5],
                                                    style: TextStyle(
                                                      color: const Color
                                                          .fromARGB(255, 0, 0,
                                                          0), // On black background
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                            ],
                                          ),
                                          Text(
                                            '       ${parameterNames[5]}',
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255,
                                                  0,
                                                  0,
                                                  0), // On black background
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                  color: Colors
                                                      .white, // On black background
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                parameterUnit[5],
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0), // On black background
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[5],
                                            style: TextStyle(
                                              color: Colors
                                                  .white, // On black background
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToDetailPage(6),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: cardColorco2,
                            elevation: 4.0,
                            child: StreamBuilder<int>(
                                stream: _streamDataco2.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    int pressData = snapshot.data!;
                                    int data = pressData;
                                    //  String type = data.type;
                                    String value = data.toString();
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (value == '-333')
                                                Text(
                                                  'NC',
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[6],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (data > 10)
                                                if (value != '-333')
                                                  Text(
                                                    value,
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[6],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data > 10)
                                                const SizedBox(width: 15),
                                              if (data > 10)
                                                if (value != '-333')
                                                  Text(
                                                    parameterUnit[6],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[6],
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                if (value != '-333')
                                                  Text(
                                                    '0',
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[6],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                if (data != -333)
                                                  Text(
                                                    value[0],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[6],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                const SizedBox(width: 15),
                                              if (data < 10)
                                                if (value != '-333')
                                                  Text(
                                                    parameterUnit[6],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[6],
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[6],
                                            style: TextStyle(
                                              color: parameterTextColor[6],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // You can add additional widgets or logic based on type here
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                  color: parameterTextColor[6],
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                parameterUnit[6],
                                                style: TextStyle(
                                                  color: parameterTextColor[6],
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[6],
                                            style: TextStyle(
                                              color: parameterTextColor[6],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // You can add additional widgets or logic based on type here
                                        ],
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToDetailPage(7),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: cardColoro22,
                            elevation: 4.0,
                            child: StreamBuilder<int>(
                                stream: _streamDatao22.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    int pressData = snapshot.data!;
                                    int data = pressData;
                                    // String type = data.type;
                                    String value = data.toString();
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (value == '-333')
                                                Text(
                                                  'NC',
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[7],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (value != '-333')
                                                if (data > 10)
                                                  Text(
                                                    value,
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[7],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data > 10)
                                                const SizedBox(width: 15),
                                              if (data > 10)
                                                if (value != '-333')
                                                  Text(
                                                    parameterUnit[7],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[7],
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (value != '-333')
                                                if (data < 10)
                                                  Text(
                                                    '0',
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[7],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                if (data != -333)
                                                  Text(
                                                    value[0],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[7],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                const SizedBox(width: 15),
                                              if (data < 10)
                                                if (value != '-333')
                                                  Text(
                                                    parameterUnit[7],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[7],
                                                      fontSize: 7,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[7],
                                            style: TextStyle(
                                              color: parameterTextColor[7],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(width: 15),
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                  color: parameterTextColor[7],
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                parameterUnit[7],
                                                style: TextStyle(
                                                  color: parameterTextColor[7],
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[7],
                                            style: TextStyle(
                                              color: parameterTextColor[7],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToDetailPage(3),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: cardColorvac,
                            elevation: 4.0,
                            child: StreamBuilder<int>(
                                stream: _streamDatavac.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    int pressData = snapshot.data!;
                                    int data = pressData;
                                    // String type = data.type;
                                    String value = data.toString();
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (value == '-333')
                                                Text(
                                                  'NC',
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[3],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (data > 10)
                                                if (value != '-333')
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                              if (data > 10)
                                                if (value != '-333')
                                                  Text(
                                                    value,
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[3],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data > 10)
                                                const SizedBox(width: 15),
                                              if (data > 10)
                                                Text(
                                                  parameterUnit[3],
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[3],
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (data < 10)
                                                if (value != '-333')
                                                  Text(
                                                    '0',
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[3],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                if (data != -333)
                                                  Text(
                                                    value[0],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[3],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                const SizedBox(width: 15),
                                              if (data < 10)
                                                Text(
                                                  parameterUnit[3],
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[3],
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[3],
                                            style: TextStyle(
                                              color: parameterTextColor[3],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                  color: parameterTextColor[3],
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                parameterUnit[3],
                                                style: TextStyle(
                                                  color: parameterTextColor[3],
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[3],
                                            style: TextStyle(
                                              color: parameterTextColor[3],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToDetailPage(0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: cardColortemp,
                            elevation: 4.0,
                            child: StreamBuilder<int>(
                              stream: _streamDatatemp.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  int pressData = snapshot.data!;
                                  String value = pressData.toString();
                                  int data = pressData;
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (value == '-333')
                                              Text(
                                                'NC',
                                                style: TextStyle(
                                                  color: parameterTextColor[0],
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (data > 10)
                                              if (value != '-333')
                                                Text(
                                                  value,
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[0],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            if (data > 10)
                                              const SizedBox(width: 15),
                                            if (data > 10)
                                              if (value != '-333')
                                                Text(
                                                  parameterUnit[0],
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[0],
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            if (data < 10)
                                              if (value != '-333')
                                                Text(
                                                  '0',
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[0],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            if (data < 10)
                                              if (data != -333)
                                                Text(
                                                  value[0],
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[0],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            if (data < 10)
                                              const SizedBox(width: 15),
                                            if (data < 10)
                                              if (value != '-333')
                                                Text(
                                                  parameterUnit[0],
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[0],
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                          ],
                                        ),
                                        Text(
                                          parameterNames[0],
                                          style: TextStyle(
                                            color: parameterTextColor[0],
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                color: parameterTextColor[0],
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            if (value != '-333')
                                              Text(
                                                parameterUnit[0],
                                                style: TextStyle(
                                                  color: parameterTextColor[0],
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ],
                                        ),
                                        Text(
                                          parameterNames[0],
                                          style: TextStyle(
                                            color: parameterTextColor[0],
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          fetchMin_Max4();
                          print("Method called");
                          _navigateToDetailPage(1);
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: cardColorhumi,
                            elevation: 4.0,
                            child: StreamBuilder<int>(
                                stream: _streamDatahumi.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    int pressData = snapshot.data!;
                                    int data = pressData;
                                    // String type = data.type;
                                    String value = data.toString();
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (value == '-333')
                                                Text(
                                                  'NC',
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[1],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (data > 10)
                                                if (value != '-333')
                                                  Text(
                                                    value,
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[1],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data > 10)
                                                const SizedBox(width: 15),
                                              if (data > 10)
                                                Text(
                                                  parameterUnit[1],
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[1],
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (data < 10)
                                                if (value != '-333')
                                                  Text(
                                                    '0',
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[1],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                if (data != -333)
                                                  Text(
                                                    value[0],
                                                    style: TextStyle(
                                                      color:
                                                          parameterTextColor[1],
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                              if (data < 10)
                                                const SizedBox(width: 15),
                                              if (data < 10)
                                                Text(
                                                  parameterUnit[1],
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[1],
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[1],
                                            style: TextStyle(
                                              color: parameterTextColor[1],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "0",
                                                style: TextStyle(
                                                  color: parameterTextColor[1],
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                parameterUnit[1],
                                                style: TextStyle(
                                                  color: parameterTextColor[1],
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            parameterNames[1],
                                            style: TextStyle(
                                              color: parameterTextColor[1],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Align(
        //   child: ValueListenableBuilder<String?>(
        //     valueListenable: errorNotifier,
        //     builder: (context, errorMessage, child) {
        //       if (errorMessage != "SYSTEM IS RUNNING OK") {
        //         // Play beep sound if not muted
        //         if (!isMuted.value) {
        //           audioPlayer.play(AssetSource('assets/beep.mp3'));
        //         } else {
        //           audioPlayer.stop();
        //         }
        //       } else {
        //         // Stop beep sound if no error
        //         audioPlayer.stop();
        //       }

        //       return Container(
        //         height: 30,
        //         color: errorMessage != null
        //             ? Colors.red
        //             : Colors.green, // Background color of the bar
        //         padding: const EdgeInsets.symmetric(horizontal: 4.0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             if (errorMessage != "SYSTEM IS RUNNING OK")
        //               ValueListenableBuilder<bool>(
        //                 valueListenable: isMuted,
        //                 builder: (context, muted, child) {
        //                   return IconButton(
        //                     icon: Icon(
        //                       muted ? Icons.volume_off : Icons.volume_up,
        //                       color: Colors.black,
        //                     ),
        //                     onPressed: () {
        //                       isMuted.value = !isMuted.value;
        //                       if (isMuted.value) {
        //                         audioPlayer.stop();
        //                       } else if (errorMessage !=
        //                           "SYSTEM IS RUNNING OK") {
        //                         audioPlayer.play(
        //                           AssetSource('assets/beep.mp3'),
        //                         );
        //                       }
        //                     },
        //                   );
        //                 },
        //               ),
        //             Spacer(flex: 10),
        //             Text(
        //               errorMessage ?? "SYSTEM IS RUNNING OK",
        //               style: TextStyle(
        //                 fontSize: 15,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.black,
        //               ),
        //             ),
        //             Spacer(flex: 10),
        //             ElevatedButton(
        //               style: ElevatedButton.styleFrom(
        //                 padding: EdgeInsets.symmetric(horizontal: 12.0),
        //                 shape: RoundedRectangleBorder(
        //                   side: BorderSide(
        //                       style: BorderStyle.solid, color: Colors.black87),
        //                   borderRadius:
        //                       BorderRadius.circular(5), // Square corners
        //                 ),
        //                 minimumSize: Size(
        //                     100, 25), // Set minimum size to maintain height
        //                 backgroundColor: Color.fromARGB(255, 192, 191, 191),
        //               ),
        //               onPressed: () async {
        //                 _navigateToDetailPage(9);
        //               },
        //               child: const Text(
        //                 'Settings',
        //                 style: TextStyle(
        //                   fontSize: 15,
        //                   color: Color.fromARGB(255, 0, 0, 0),
        //                   shadows: [
        //                     Shadow(
        //                       blurRadius: 4,
        //                       color: Colors.grey,
        //                       offset: Offset(2, 1.5),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             SizedBox(width: 20), // Add spacing between the buttons
        //             ElevatedButton(
        //               style: ElevatedButton.styleFrom(
        //                 padding: EdgeInsets.symmetric(horizontal: 12.0),
        //                 shape: RoundedRectangleBorder(
        //                   side: BorderSide(
        //                       style: BorderStyle.solid, color: Colors.black87),
        //                   borderRadius:
        //                       BorderRadius.circular(5), // Square corners
        //                 ),
        //                 minimumSize: Size(
        //                     100, 25), // Set minimum size to maintain height
        //                 backgroundColor: Color.fromARGB(255, 192, 191, 191),
        //               ),
        //               onPressed: () async {
        //                 _navigateToDetailPage(8);
        //               },
        //               child: const Text(
        //                 'Report',
        //                 style: TextStyle(
        //                   fontSize: 15,
        //                   color: Color.fromARGB(255, 0, 0, 0),
        //                   shadows: [
        //                     Shadow(
        //                       blurRadius: 4,
        //                       color: Colors.grey,
        //                       offset: Offset(2, 1.5),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             SizedBox(
        //               width: 5,
        //             )
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        // ),
        Expanded(
          flex: 1,
          child: Align(
            child: ValueListenableBuilder<String?>(
              valueListenable: errorNotifier,
              builder: (context, errorMessage, child) {
                if (errorMessage != "SYSTEM IS RUNNING OK") {
                  // Play beep sound if not muted
                  if (!isMuted1) {
                    playBackgroundMusic();
                  } else {
                    stopBackgroundMusic();
                  }
                } else {
                  // Stop beep sound if no error
                  stopBackgroundMusic();
                }

                return Container(
                  // height: 30,
                  color: errorMessage != null
                      ? Colors.red
                      : Colors.green, // Background color of the bar
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black87,
                            ),
                            borderRadius:
                                BorderRadius.circular(5), // Square corners
                          ),
                          minimumSize: Size(
                              100, 25), // Set minimum size to maintain height
                          backgroundColor: isMuted1
                              ? const Color.fromARGB(
                                  255, 192, 191, 191) // Color when muted
                              : const Color.fromARGB(
                                  255, 192, 191, 191), // Default color
                        ),
                        onPressed: toggleMute,
                        child: Text(
                          isMuted1 ? 'Unmute' : 'Mute',
                          style: TextStyle(
                            fontSize: 15,
                            color: isMuted1
                                ? const Color.fromARGB(
                                    255, 0, 0, 0) // Text color when muted
                                : const Color.fromARGB(
                                    255, 0, 0, 0), // Default text color
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.grey,
                                offset: Offset(2, 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(flex: 10),
                      Text(
                        errorMessage ?? "SYSTEM IS RUNNING OK",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(flex: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              style: BorderStyle.solid,
                              color: Colors.black87,
                            ),
                            borderRadius:
                                BorderRadius.circular(5), // Square corners
                          ),
                          minimumSize: Size(
                              100, 25), // Set minimum size to maintain height
                          backgroundColor:
                              const Color.fromARGB(255, 192, 191, 191),
                        ),
                        onPressed: () async {
                          _navigateToDetailPage(9);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: Colors.black,
                            ),
                            Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 0, 0, 0),
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.grey,
                                    offset: Offset(2, 1.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      if (_showButton ==
                          true) // Add spacing between the buttons
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.black87,
                              ),
                              borderRadius:
                                  BorderRadius.circular(5), // Square corners
                            ),
                            minimumSize: Size(
                                100, 25), // Set minimum size to maintain height
                            backgroundColor:
                                const Color.fromARGB(255, 192, 191, 191),
                          ),
                          onPressed: () async {
                            _navigateToDetailPage(8);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.insert_chart,
                                color: Colors.black,
                              ),
                              const Text(
                                'Reports',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.grey,
                                      offset: Offset(2, 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_showButton == false)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                style: BorderStyle.solid,
                                color: Colors.black87,
                              ),
                              borderRadius:
                                  BorderRadius.circular(5), // Square corners
                            ),
                            minimumSize: Size(
                                100, 25), // Set minimum size to maintain height
                            backgroundColor:
                                const Color.fromARGB(255, 192, 191, 191),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.insert_chart,
                                color: const Color.fromARGB(255, 129, 129, 129),
                              ),
                              const Text(
                                'Reports',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 150, 150, 150),
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Color.fromARGB(255, 223, 223, 223),
                                      offset: Offset(2, 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        //   child: LiveDataBuilder<String>(
        //     liveData: errorNotifier,
        //     //stream: _streamDataerror.stream,
        //     builder: (BuildContext context, String message) {
        //       return Text(message);
        //       // if (snapshot.hasData) {
        //       //   print("->>>>>>>>>${snapshot.data}");
        //       //   print(_currentIndex);
        //       //   if (!_message.contains(snapshot.data.toString())) {
        //       //     _message.add(snapshot.data.toString());
        //       //     print("efbvfwergf----$_message");
        //       //   }

        //       //   message = _message.isNotEmpty
        //       //       ? _message[_currentIndex]
        //       //       : "SYSTEM IS RUNNING OK";
        //       //   // if (message != "SYSTEM IS RUNNING OK") {
        //       //   //   _startBeep(context);
        //       //   // } else {
        //       //   //   _stopBeep();
        //       //   // }
        //       //   return Container(
        //       //     height: 30,
        //       //     color: _currentString == 'SYSTEM IS RUNNING OK'
        //       //         ? Colors.grey[200]
        //       //         : Colors.red, // Background color of the bar
        //       //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
        //       //     child: Row(
        //       //       mainAxisAlignment: MainAxisAlignment.start,
        //       //       children: [
        //       //         Spacer(flex: 20),
        //       //         Text(
        //       //           _currentString,
        //       //           style: TextStyle(
        //       //             fontSize: 15,
        //       //             fontWeight: FontWeight.bold,
        //       //             color: Colors.black,
        //       //           ),
        //       //         ),
        //       //         Spacer(flex: 10),
        //       //         ElevatedButton(
        //       //           style: ElevatedButton.styleFrom(
        //       //             padding: EdgeInsets.symmetric(horizontal: 12.0),
        //       //             shape: RoundedRectangleBorder(
        //       //               side: BorderSide(
        //       //                   style: BorderStyle.solid,
        //       //                   color: Colors.black87),
        //       //               borderRadius:
        //       //                   BorderRadius.circular(5), // Square corners
        //       //             ),
        //       //             minimumSize: Size(
        //       //                 100, 25), // Set minimum size to maintain height
        //       //             backgroundColor: Color.fromARGB(255, 192, 191, 191),
        //       //           ),
        //       //           onPressed: () async {
        //       //             _navigateToDetailPage(9);
        //       //           },
        //       //           child: const Text(
        //       //             'Settings',
        //       //             style: TextStyle(
        //       //               fontSize: 15,
        //       //               color: Color.fromARGB(255, 0, 0, 0),
        //       //               shadows: [
        //       //                 Shadow(
        //       //                   blurRadius: 4,
        //       //                   color: Colors.grey,
        //       //                   offset: Offset(2, 1.5),
        //       //                 ),
        //       //               ],
        //       //             ),
        //       //           ),
        //       //         ),
        //       //         SizedBox(width: 20), // Add spacing between the buttons
        //       //         ElevatedButton(
        //       //           style: ElevatedButton.styleFrom(
        //       //             padding: EdgeInsets.symmetric(horizontal: 12.0),
        //       //             shape: RoundedRectangleBorder(
        //       //               side: BorderSide(
        //       //                   style: BorderStyle.solid,
        //       //                   color: Colors.black87),
        //       //               borderRadius:
        //       //                   BorderRadius.circular(5), // Square corners
        //       //             ),
        //       //             minimumSize: Size(
        //       //                 100, 25), // Set minimum size to maintain height
        //       //             backgroundColor: Color.fromARGB(255, 192, 191, 191),
        //       //           ),
        //       //           onPressed: () async {
        //       //             _navigateToDetailPage(8);
        //       //           },
        //       //           child: const Text(
        //       //             'Report',
        //       //             style: TextStyle(
        //       //               fontSize: 15,
        //       //               color: Color.fromARGB(255, 0, 0, 0),
        //       //               shadows: [
        //       //                 Shadow(
        //       //                   blurRadius: 4,
        //       //                   color: Colors.grey,
        //       //                   offset: Offset(2, 1.5),
        //       //                 ),
        //       //               ],
        //       //             ),
        //       //           ),
        //       //         ),
        //       //         SizedBox(
        //       //           width: 5,
        //       //         )
        //       //       ],
        //       //     ),
        //       //   );
        //       // } else {
        //       //   return Text("SYSTEM IS RUNNING OK");
        //       // }
        //     },
        //   ),
        // ),
      ]),
    );
  }

  void storedata_database() async {
    // int tempstore = int.parse(temp) ;
    final entity = PressDataTableCompanion(
      temperature: drift.Value(temp1min),
      humidity: drift.Value(humi1min),
      o2: drift.Value(o211min),
      vac: drift.Value(vac1min),
      n2o: drift.Value(n2o1min),
      airPressure: drift.Value(air1min),
      co2: drift.Value(co21min),
      o22: drift.Value(o221min),
      DeviceNo: drift.Value(serrialNo),
      LocationID: drift.Value(location),
      Temp_min: drift.Value(TEMP_maxLimit),
      Temp_max: drift.Value(TEMP_minLimit),
      Humi_min: drift.Value(HUMI_minLimit),
      Humi_max: drift.Value(HUMI_maxLimit),
      O2_1_min: drift.Value(O2_minLimit),
      O2_1_max: drift.Value(O2_maxLimit),
      o2_2_min: drift.Value(O2_2_minLimit),
      o2_2_max: drift.Value(O2_2_maxLimit),
      n2o_max: drift.Value(N2O_maxLimit),
      n2o_min: drift.Value(N2O_minLimit),
      vac_min: drift.Value(VAC_minLimit),
      vac_max: drift.Value(VAC_maxLimit),
      air_max: drift.Value(AIR_maxLimit),
      air_min: drift.Value(AIR_minLimit),
      co2_min: drift.Value(CO2_minLimit),
      co2_max: drift.Value(CO2_maxLimit),
      temp_error: drift.Value(temp_error),
      humi_error: drift.Value(humi_error),
      o2_1_error: drift.Value(o2_1_error),
      o2_2_error: drift.Value(o2_2_error),
      co2_error: drift.Value(co2_error),
      vac_error: drift.Value(vac_error),
      n2o_error: drift.Value(n2o_error),
      air_error: drift.Value(air_error),
      recordedAt: drift.Value(DateTime.now()),
    );
    copy_database();
    //  print("entity->>>>>>>>>>>>>>>>>>>>>$entity");
    await db.getAllPressData().toString();
    await db.insertPressData(entity);
  }

  void copy_database() {
    print('heloooooooooooooooo->>>>>>>>>>>>>>>${db.getAllErrorData()}');
  }

  void fetchDataForSpecificDay(DateTime date) async {
    print("hellooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
    List<PressDataTableData> dataForDay =
        await db.getDataForDay(date, serrialNo);
    // Do something with the data
    dataForDay.forEach((data) {
      print("data->>>>>>>>>>>$data");
    });
  }

  void fetchDataForDateRange(DateTime startDate, DateTime endDate) async {
    List<PressDataTableData> dataForRange =
        await db.getDataForDateRange(startDate, endDate, serrialNo);
    // Do something with the data
    dataForRange.forEach((data) {
      print("data->>>>>>>>>>>$data");
    });
  }

  // void fetchDataForMonth(DateTime date) async {
  //   List<PressDataTableData> dataForMonth = await db.getDataForMonth(date);
  //   // Do something with the data
  //   dataForMonth.forEach((data) {
  //     print("data->>>>>>>>>>>$data");
  //   });
  void _startErrorCycle() {
    print("Starting error cycle");

    // Ensure any previous timer is cancelled before starting a new one
    if (_errorTimer != null && _errorTimer!.isActive) {
      print("Existing timer found and cancelled.");
      _errorTimer!.cancel();
    }

    _currentErrorIndex = 0; // Reset the index to start from the first error
    print("currrent Index:$_currentErrorIndex");
    _errorTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (errors.isEmpty) {
        print("No errors left to display.");
        errorNotifier.value = "All systems normal";
        timer.cancel();
      } else {
        print("Displaying error: ${errors[_currentErrorIndex]}");
        errorNotifier.value = errors[_currentErrorIndex];
        _currentErrorIndex = (_currentErrorIndex + 1) % errors.length;
      }
    });
  }

  // List<double> humidity = [];
}

void _updateData(List<ChartData> dataList, ChartData newValue) {
  if (dataList.length >= 60) {
    dataList.removeAt(0); // Remove the oldest data
  }
  dataList.add(newValue);
}

class Minmax {
  final String type;
  final int max;
  final int min;
  Minmax({required this.type, required this.max, required this.min});

  factory Minmax.fromJson(Map<String, dynamic> json) {
    return Minmax(
      type: json['type'],
      max: json['MAX'],
      min: json['MIN'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'MAX': max,
      'MIN': min,
    };
  }
}
