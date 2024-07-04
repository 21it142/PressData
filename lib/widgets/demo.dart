import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pressdata/screens/LimitSetting(Demo)/air.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/co2.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/humi.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/n2o.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/o2-1.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/o2-2.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/temp.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/vac.dart';
import 'package:pressdata/screens/main_page.dart';
import 'package:pressdata/screens/report_screenDemo.dart';
import 'package:pressdata/screens/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
    ParameterData(
        "TEMP", const Color.fromARGB(255, 255, 0, 0), Random().nextInt(100)),
    ParameterData("HUMI", Colors.blue, Random().nextInt(100)),
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
  final LinearGradient gradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.blue, Colors.green], // Two colors for the gradient
  );

  final List<Color> parameterColors = [
    const Color.fromARGB(255, 195, 0, 0),
    Colors.blue,
    Colors.white,
    Colors.yellow,
    const Color.fromARGB(255, 0, 34, 145),
    const Color.fromARGB(255, 198, 230, 255),
    const Color.fromRGBO(62, 66, 70, 1),
    const Color.fromARGB(255, 255, 255, 255),
  ];
  final List<Color> parameterTextColor = [
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 0, 0, 0),
    const Color.fromARGB(255, 0, 0, 0),
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 0, 0, 0),
    const Color.fromARGB(255, 255, 255, 255),
    const Color.fromARGB(255, 0, 0, 0),
  ];
  void _storeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      O2_maxLimit = prefs.getInt('O2_maxLimit') ?? 10;
      O2_minLimit = prefs.getInt('O2_minLimit') ?? 0;
      VAC_maxLimit = prefs.getInt('VAC_maxLimit') ?? 20;
      VAC_minLimit = prefs.getInt('VAC_minLimit') ?? 0;
      N2O_maxLimit = prefs.getInt('N2O_maxLimit') ?? 30;
      N2O_minLimit = prefs.getInt('N2O_minLimit') ?? 0;
      AIR_maxLimit = prefs.getInt('AIR_maxLimit') ?? 40;
      AIR_minLimit = prefs.getInt('AIR_minLimit') ?? 0;
      CO2_maxLimit = prefs.getInt('CO2_maxLimit') ?? 50;
      CO2_minLimit = prefs.getInt('CO2_minLimit') ?? 0;
      O2_2_maxLimit = prefs.getInt('O2_2_maxLimit') ?? 60;
      O2_2_minLimit = prefs.getInt('O2_2_minLimit') ?? 0;
      TEMP_maxLimit = prefs.getInt('TEMP_maxLimit') ?? 70;
      TEMP_minLimit = prefs.getInt('TEMP_minLimit') ?? 0;
      HUMI_maxLimit = prefs.getInt('HUMI_maxLimit') ?? 80;
      HUMI_minLimit = prefs.getInt('HUMI_minLimit') ?? 0;
    });
  }

  void _navigateToDetailPage(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TEMPD()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HUMID()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => O21()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VACD()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => N2OD()),
      );
    } else if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AIRD()),
      );
    } else if (index == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CO2D()),
      );
    } else if (index == 7) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => O22()),
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RichText(
                text: const TextSpan(
                  text: 'Press ',
                  style: TextStyle(color: Colors.blue, fontSize: 25),
                  children: [
                    TextSpan(
                      text: 'Data ',
                      style: TextStyle(color: Colors.red, fontSize: 25),
                    ),
                    TextSpan(
                      text: 'Medical Gas Alarm + Analyser ',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        toolbarHeight: 40,
        backgroundColor: Color.fromRGBO(228, 100, 128, 100),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
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
                        interval: 1,
                        title: AxisTitle(
                          text: 'Reading for Press Data',
                          textStyle: TextStyle(fontSize: 10),
                        ),
                      ),
                      primaryYAxis: const NumericAxis(
                        axisLine: AxisLine(width: 0),
                        majorTickLines: MajorTickLines(size: 0),
                        title: AxisTitle(text: 'Values'),
                      ),
                      series: <LineSeries<LiveData, int>>[
                        LineSeries<LiveData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController0 = controller;
                          },
                          dataSource: chartData,
                          xValueMapper: (LiveData press, _) => press.time,
                          yValueMapper: (LiveData press, _) => press.o2_1,
                          color: Color.fromARGB(255, 255, 255, 255),
                          name: "O2(1)",
                        ),
                        LineSeries<LiveData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController1 = controller;
                          },
                          dataSource: chartData,
                          xValueMapper: (LiveData press, _) => press.time,
                          yValueMapper: (LiveData press, _) => press.vac,
                          color: Colors.yellow,
                          name: "VAC",
                        ),
                        LineSeries<LiveData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController2 = controller;
                          },
                          dataSource: chartData,
                          xValueMapper: (LiveData press, _) => press.time,
                          yValueMapper: (LiveData press, _) => press.n2o,
                          color: const Color.fromARGB(255, 0, 34, 145),
                          name: "N2o",
                        ),
                        LineSeries<LiveData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController3 = controller;
                          },
                          dataSource: chartData,
                          xValueMapper: (LiveData press, _) => press.time,
                          yValueMapper: (LiveData press, _) => press.air,
                          color: Color.fromARGB(114, 1, 2, 1),
                          name: "AIR",
                        ),
                        LineSeries<LiveData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController4 = controller;
                          },
                          dataSource: chartData,
                          xValueMapper: (LiveData press, _) => press.time,
                          yValueMapper: (LiveData press, _) => press.co2,
                          color: const Color.fromRGBO(62, 66, 70, 1),
                          name: "co2",
                        ),
                        LineSeries<LiveData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController5 = controller;
                          },
                          dataSource: chartData,
                          xValueMapper: (LiveData press, _) => press.time,
                          yValueMapper: (LiveData press, _) => press.o2_2,
                          color: Colors.white,
                          name: "O2_2",
                        ),
                        LineSeries<LiveData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController6 = controller;
                          },
                          dataSource: chartData,
                          xValueMapper: (LiveData press, _) => press.time,
                          yValueMapper: (LiveData press, _) => press.temp,
                          color: const Color.fromARGB(255, 255, 0, 0),
                          name: "Temp",
                        ),
                        LineSeries<LiveData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController7 = controller;
                          },
                          dataSource: chartData,
                          xValueMapper: (LiveData press, _) => press.time,
                          yValueMapper: (LiveData press, _) => press.humi,
                          color: Colors.blue,
                          name: "HUMI",
                        ),
                      ],
                    ),
                  ),
                ),
                // Parameters on the right
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _navigateToDetailPage(0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.21,
                              width: 120,
                              child: Card(
                                color: parameterColors[0],
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${parameters[0].value}',
                                            style: TextStyle(
                                              color: parameterTextColor[0],
                                              fontSize: 31.5,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
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
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToDetailPage(1),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.21,
                              width: 120,
                              child: Card(
                                color: parameterColors[1],
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${parameters[1].value}',
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
                                              fontSize: 10,
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
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _navigateToDetailPage(2),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.21,
                              width: 120,
                              child: Card(
                                color: parameterColors[2],
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${parameters[2].value}',
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
                                              fontSize: 10,
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
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToDetailPage(3),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.21,
                              width: 120,
                              child: Card(
                                color: parameterColors[3],
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${parameters[3].value}',
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
                                              fontSize: 10,
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
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _navigateToDetailPage(4),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.21,
                              width: 120,
                              child: Card(
                                color: parameterColors[4],
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${parameters[4].value}',
                                            style: TextStyle(
                                              color: parameterTextColor[4],
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            parameterUnit[4],
                                            style: TextStyle(
                                              color: parameterTextColor[4],
                                              fontSize: 10,
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
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToDetailPage(5),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.21,
                              width: 120,
                              child: Card(
                                color: parameterColors[5],
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${parameters[5].value}',
                                            style: TextStyle(
                                              color: parameterTextColor[5],
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            parameterUnit[5],
                                            style: TextStyle(
                                              color: parameterTextColor[5],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        parameterNames[5],
                                        style: TextStyle(
                                          color: parameterTextColor[5],
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _navigateToDetailPage(6),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.21,
                              width: 120,
                              child: Card(
                                color: parameterColors[6],
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${parameters[6].value}',
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
                                              fontSize: 10,
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _navigateToDetailPage(7),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.21,
                              width: 120,
                              child: Card(
                                color: parameterColors[7],
                                elevation: 4.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ' ${parameters[7].value}',
                                            style: TextStyle(
                                              color: parameterTextColor[7],
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            parameterUnit[7],
                                            style: TextStyle(
                                              color: parameterTextColor[7],
                                              fontSize: 10,
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
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // Bar at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 30,
              color: Colors.grey[200], // Background color of the bar
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Spacer(flex: 20),
                  const Text(
                    'SYSTEM IS RUNNING OK',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(
                    flex: 12,
                  ),
                  Positioned(
                    right: 130,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              style: BorderStyle.solid, color: Colors.black87),
                          borderRadius:
                              BorderRadius.circular(5), // Square corners
                        ),
                        minimumSize:
                            Size(90, 25), // Set minimum size to maintain height
                        backgroundColor: Color.fromARGB(255, 192, 191, 191),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Setting1()),
                        );
                      },
                      child: const Text(
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
                    ),
                  ),
                  SizedBox(width: 12), // Add spacing between the buttons
                  Positioned(
                    right: 20,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              style: BorderStyle.solid, color: Colors.black87),
                          borderRadius:
                              BorderRadius.circular(5), // Square corners
                        ),
                        minimumSize:
                            Size(90, 25), // Set minimum size to maintain height
                        backgroundColor: Color.fromARGB(255, 192, 191, 191),
                      ),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Report',
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
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
