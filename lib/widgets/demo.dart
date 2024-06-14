import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/screens/Limit%20Setting/AIR.dart';
import 'package:pressdata/screens/Limit%20Setting/HUMI.dart';
import 'package:pressdata/screens/Limit%20Setting/N2O.dart';
import 'package:pressdata/screens/Limit%20Setting/O2.dart';
import 'package:pressdata/screens/Limit%20Setting/O2_2.dart';
import 'package:pressdata/screens/Limit%20Setting/TEMP.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../screens/Limit Setting/CO2.dart';
import '../screens/Limit Setting/VAC.dart';

class LiveData {
  LiveData(this.time, this.o2_1, this.vac, this.n2o, this.air, this.co2,
      this.o2_2, this.temp, this.humi);
  final int time;
  final num o2_1;
  final num vac;
  final num n2o;
  final num air;
  final num co2;
  final num o2_2;
  final num temp;
  final num humi;
}

class DemoWid extends StatefulWidget {
  const DemoWid({Key? key}) : super(key: key);

  @override
  State<DemoWid> createState() => _DemoWidState();
}

class ParameterData {
  final String name;
  final Color color;
  int value;

  ParameterData(this.name, this.color, this.value);
}

class _DemoWidState extends State<DemoWid> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController0;
  late ChartSeriesController _chartSeriesController1;
  late ChartSeriesController _chartSeriesController2;
  late ChartSeriesController _chartSeriesController3;
  late ChartSeriesController _chartSeriesController4;
  late ChartSeriesController _chartSeriesController5;
  late ChartSeriesController _chartSeriesController6;
  late ChartSeriesController _chartSeriesController7;
  int? O2_maxLimit;
  int? O2_minLimit;
  int? VAC_maxLimit;
  int? VAC_minLimit;
  int? N2O_maxLimit;
  int? N2O_minLimit;
  int? AIR_maxLimit;
  int? AIR_minLimit;
  int? CO2_maxLimit;
  int? CO2_minLimit;
  int? O2_2_maxLimit;
  int? O2_2_minLimit;
  int? TEMP_maxLimit;
  int? TEMP_minLimit;
  int? HUMI_maxLimit;
  int? HUMI_minLimit;
  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(
        0,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        1,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        2,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        3,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        4,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        5,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        6,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        7,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        8,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        9,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        10,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        11,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        12,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        13,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        14,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        15,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        16,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        17,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      ),
      LiveData(
        18,
        Random().nextInt(10) + 1,
        Random().nextInt(10) + 11,
        Random().nextInt(10) + 21,
        Random().nextInt(10) + 31,
        Random().nextInt(10) + 41,
        Random().nextInt(10) + 51,
        Random().nextInt(10) + 61,
        Random().nextInt(10) + 71,
      )
    ];
  }

  List<ParameterData> parameters = [
    ParameterData("O2(1)", Colors.white, Random().nextInt(100)),
    ParameterData("VAC", Colors.yellow, Random().nextInt(100)),
    ParameterData(
        "N2O", const Color.fromARGB(255, 0, 34, 145), Random().nextInt(100)),
    ParameterData(
        "AIR", const Color.fromARGB(255, 198, 230, 255), Random().nextInt(100)),
    ParameterData(
        "CO2", const Color.fromRGBO(62, 66, 70, 1), Random().nextInt(100)),
    ParameterData("O2(2)", const Color.fromARGB(255, 255, 255, 255),
        Random().nextInt(100)),
    ParameterData(
        "TEMP", const Color.fromARGB(255, 255, 0, 0), Random().nextInt(100)),
    ParameterData("HUMI", Colors.blue, Random().nextInt(100)),
  ];

  List parameterNames = [
    "O2(1)",
    "VAC",
    "N₂O", // Subscript NO₂ for NO2
    "AIR",
    "CO₂", // Subscript CO₂ for CO2
    "O₂(2)", // Subscript O₂ for O2(2)
    "TEMP",
    "HUMI",
  ];
  List parameterUnit = [
    "PSI",
    "mmHg",
    "PSI",
    "PSI",
    "PSI",
    "PSI",
    "°C",
    "%",
  ];
  final LinearGradient gradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.blue, Colors.green], // Two colors for the gradient
  );

  final List<Color> parameterColors = [
    Colors.white,
    Colors.yellow,
    const Color.fromARGB(255, 0, 34, 145),
    const Color.fromARGB(255, 198, 230, 255),
    const Color.fromRGBO(62, 66, 70, 1),
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 195, 0, 0),
    Colors.blue,
  ];
  final List<Color> parameterTextColor = [
    const Color.fromARGB(255, 0, 0, 0),
    const Color.fromARGB(255, 0, 0, 0),
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 0, 0, 0),
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 0, 0, 0),
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 255, 255, 255),
  ];
  void _storeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      O2_maxLimit = prefs.getInt('O2_maxLimit') ?? 0;
      O2_minLimit = prefs.getInt('O2_minLimit') ?? 0;
      VAC_maxLimit = prefs.getInt('VAC_maxLimit') ?? 0;
      VAC_minLimit = prefs.getInt('VAC_minLimit') ?? 0;
      N2O_maxLimit = prefs.getInt('N2O_maxLimit') ?? 0;
      N2O_minLimit = prefs.getInt('N2O_minLimit') ?? 0;
      AIR_maxLimit = prefs.getInt('AIR_maxLimit') ?? 0;
      AIR_minLimit = prefs.getInt('AIR_minLimit') ?? 0;
      CO2_maxLimit = prefs.getInt('CO2_maxLimit') ?? 0;
      CO2_minLimit = prefs.getInt('CO2_minLimit') ?? 0;
      O2_2_maxLimit = prefs.getInt('O2_2_maxLimit') ?? 0;
      O2_2_minLimit = prefs.getInt('O2_2_minLimit') ?? 0;
      TEMP_maxLimit = prefs.getInt('TEMP_maxLimit') ?? 0;
      TEMP_minLimit = prefs.getInt('TEMP_minLimit') ?? 0;
      HUMI_maxLimit = prefs.getInt('HUMI_maxLimit') ?? 0;
      HUMI_minLimit = prefs.getInt('HUMI_minLimit') ?? 0;
    });
  }

  void _navigateToDetailPage(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => O2()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VAC()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => N2O()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AIR()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CO2()),
      );
    } else if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => O2_2()),
      );
    } else if (index == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TEMP()),
      );
    } else if (index == 7) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HUMI()),
      );
    }
  }

  late StreamController<void> _updateController;
  late StreamSubscription<void> _streamSubscription;

  @override
  void initState() {
    super.initState();

    chartData = getChartData();
    Timer.periodic(Duration(seconds: 1), updateDataSource);
    _updateController = StreamController<void>.broadcast();
    _storeData();
    _streamSubscription = _updateController.stream.listen((_) {
      _updateData();
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateController.add(null);
    });
  }

  void _updateData() {
    setState(() {
      parameters = parameters.map((param) {
        if (param.name == "O2(1)") {
          int newvalue = Random().nextInt(10);
          if (newvalue > O2_maxLimit! || newvalue < O2_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 550),
                  content: Text('${param.name} is not in range!'),
                ),
              );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(param.name, Colors.white, newvalue);
          }
        } else if (param.name == "VAC") {
          int newvalue = Random().nextInt(10) + 11;
          if (newvalue > VAC_maxLimit! || newvalue < VAC_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 550),
                  content: Text('${param.name} is not in range!'),
                ),
              );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(param.name, Colors.yellow, newvalue);
          }
        } else if (param.name == "N2O") {
          int newvalue = Random().nextInt(10) + 21;
          if (newvalue > N2O_maxLimit! || newvalue < N2O_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${param.name} is not in range!'),
                ),
              );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(
                param.name, const Color.fromARGB(255, 0, 34, 145), newvalue);
          }
        } else if (param.name == "AIR") {
          int newvalue = Random().nextInt(10) + 31;
          if (newvalue > AIR_maxLimit! || newvalue < AIR_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 550),
                  content: Text('${param.name} is not in range!'),
                ),
              );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(
                param.name, const Color.fromARGB(255, 198, 230, 255), newvalue);
          }
        } else if (param.name == "CO2") {
          int newvalue = Random().nextInt(10) + 41;
          if (newvalue > CO2_maxLimit! || newvalue < CO2_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     backgroundColor: Colors.red,
              //     duration: const Duration(milliseconds: 550),
              //     content: Text('${param.name} is not in range!'),
              //   ),
              // );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(
                param.name, const Color.fromRGBO(62, 66, 70, 1), newvalue);
          }
        } else if (param.name == "O2(2)") {
          int newvalue = Random().nextInt(10) + 51;
          if (newvalue > O2_2_maxLimit! || newvalue < O2_2_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  duration: const Duration(milliseconds: 550),
                  content: Text('${param.name} is not in range!'),
                ),
              );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(param.name, Colors.white, newvalue);
          }
        } else if (param.name == "TEMP") {
          int newvalue = Random().nextInt(10) + 61;
          if (newvalue > TEMP_maxLimit! || newvalue < TEMP_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 550),
                  content: Text('${param.name} is not in range!'),
                ),
              );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(
                param.name, const Color.fromARGB(255, 195, 0, 0), newvalue);
          }
        } else {
          int newvalue = Random().nextInt(10) + 71;
          if (newvalue > HUMI_maxLimit! || newvalue < HUMI_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${param.name} is not in range!'),
                ),
              );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(param.name, Colors.blue, newvalue);
          }
        }
      }).toList();
    });
  }

  int time = 19;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(
      time++,
      Random().nextInt(10) + 1,
      Random().nextInt(10) + 11,
      Random().nextInt(10) + 21,
      Random().nextInt(10) + 31,
      Random().nextInt(10) + 41,
      Random().nextInt(10) + 51,
      Random().nextInt(10) + 61,
      Random().nextInt(10) + 71,
    ));
    chartData.removeAt(0);
    _chartSeriesController0.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
    _chartSeriesController1.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
    _chartSeriesController2.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
    _chartSeriesController3.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
    _chartSeriesController4.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
    _chartSeriesController4.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
    _chartSeriesController5.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
    _chartSeriesController6.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
    _chartSeriesController7.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  @override
  void dispose() {
    _updateController.close(); // Close the stream controller
    _streamSubscription.cancel(); // Cancel the subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      body: Row(
        children: [
          // Graph on the left
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SfCartesianChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(isVisible: true),
                primaryXAxis: const NumericAxis(
                  majorGridLines: MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  interval: 3,
                  title: AxisTitle(
                      text: 'Reading for Press Data',
                      textStyle: TextStyle(fontSize: 10)),
                ),
                primaryYAxis: const NumericAxis(
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(size: 0),
                  title: AxisTitle(text: 'Values'),
                ),
                series: <LineSeries<LiveData, int>>[
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController0 = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (LiveData press, _) => press.time,
                    yValueMapper: (LiveData press, _) => press.o2_1,
                    //  markerSettings: const MarkerSettings(isVisible: true),
                    color: Color.fromARGB(255, 255, 255, 255),
                    name: "O2(1)",
                  ),
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController1 = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (LiveData press, _) => press.time,
                    yValueMapper: (LiveData press, _) => press.vac,
                    // markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.yellow,
                    name: "VAC",
                  ),
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController2 = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (LiveData press, _) => press.time,
                    yValueMapper: (LiveData press, _) => press.n2o,
                    //markerSettings: const MarkerSettings(isVisible: true),
                    color: const Color.fromARGB(255, 0, 34, 145),
                    name: "N2o",
                  ),
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController3 = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (LiveData press, _) => press.time,
                    yValueMapper: (LiveData press, _) => press.air,
                    //markerSettings: const MarkerSettings(isVisible: true),
                    color: Color.fromARGB(114, 1, 2, 1),
                    name: "AIR",
                  ),
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController4 = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (LiveData press, _) => press.time,
                    yValueMapper: (LiveData press, _) => press.co2,
                    //markerSettings: const MarkerSettings(isVisible: true),
                    color: const Color.fromRGBO(62, 66, 70, 1),
                    name: "co2",
                  ),
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController5 = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (LiveData press, _) => press.time,
                    yValueMapper: (LiveData press, _) => press.o2_2,
                    // markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.white,
                    name: "O2_2",
                  ),
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController6 = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (LiveData press, _) => press.time,
                    yValueMapper: (LiveData press, _) => press.temp,
                    // markerSettings: const MarkerSettings(isVisible: true),
                    color: const Color.fromARGB(255, 255, 0, 0),
                    name: "Temp",
                  ),
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController7 = controller;
                    },
                    dataSource: chartData,
                    xValueMapper: (LiveData press, _) => press.time,
                    yValueMapper: (LiveData press, _) => press.humi,
                    //  markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.blue,
                    name: "HUMI",
                  ),
                ],
              ),
            ),
          ),
          // Parameters on the right
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Expanded(
                    child: 
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 3.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 1.55 / 1,
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        //  String dataValue = '';
                        // Access the data based on the index of the card

                        return GestureDetector(
                          onTap: () => _navigateToDetailPage(index),
                          child: Card(
                            color: parameters[index].color,
                            elevation: 4.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: parameters[index].color,
                                gradient: index == 3
                                    ? const LinearGradient(
                                        colors: [Colors.black, Colors.white],
                                        begin: Alignment.topLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  children: [
                                    Text(
                                      ' ${parameters[index].value}',
                                      style: TextStyle(
                                        color: parameterTextColor[index],
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' ${parameterUnit[index]}',
                                      style: TextStyle(
                                        color: parameterTextColor[index],
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      parameterNames[index],
                                      style: TextStyle(
                                        color: parameterTextColor[index],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
