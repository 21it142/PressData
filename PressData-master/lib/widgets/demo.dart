import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/air.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/co2.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/humi.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/n2o.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/o2-1.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/o2-2.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/temp.dart';
import 'package:pressdata/screens/LimitSetting(Demo)/vac.dart';
import 'package:pressdata/screens/report_screenDemo.dart';
// import 'package:pressdata/screens/main_page.dart';
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

class ParameterData {
  final String name;
  final Color color;
  int value;

  ParameterData(this.name, this.color, this.value);
}

class DemoWid extends StatefulWidget {
  const DemoWid({Key? key}) : super(key: key);

  @override
  State<DemoWid> createState() => _DemoWidState();
}

class _DemoWidState extends State<DemoWid> with RouteAware {
  final O21 _o21widget = const O21();
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
  String date = '';
  bool isMuted1 = false;
  String o2_1_error = '';
  String o2_2_error = '';
  String n2o_error = '';
  String air_error = '';
  String vac_error = '';
  String co2_error = '';
  String temp_error = '';
  String humi_error = '';
  bool _showButton = false;
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);
  List<String> errors = [];
  Timer? _errorTimer;
  int _currentErrorIndex = 0;
  final AudioPlayer bgAudio = AudioPlayer();
  List<LiveData> getChartData() {
    List<LiveData> data = [];
    for (int i = 0; i < 60; i++) {
      data.add(
        LiveData(
          i,
          Random().nextInt(10) + 31,
          Random().nextInt(10) + 211,
          Random().nextInt(10) + 41,
          Random().nextInt(10) + 51,
          Random().nextInt(10) + 61,
          Random().nextInt(10) + 71,
          Random().nextInt(10) + 1,
          Random().nextInt(10) + 21,
        ),
      );
    }
    return data;
  }

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
        errorNotifier.value = "SYSTEM IS RUNNING OK";
        timer.cancel();
      } else {
        print("Displaying error: ${errors[_currentErrorIndex]}");
        errorNotifier.value = errors[_currentErrorIndex];
        _currentErrorIndex = (_currentErrorIndex + 1) % errors.length;
      }
    });
  }

  List<Color> _getGradientColors() {
    return [Colors.black, Colors.white];
  }

  List<ParameterData> parameters = [
    ParameterData(
      "TEMP",
      const Color.fromARGB(255, 255, 0, 0),
      Random().nextInt(10) + 1,
    ),
    ParameterData(
      "HUMI",
      Colors.blue,
      Random().nextInt(10) + 21,
    ),
    ParameterData(
      "O2(1)",
      Colors.white,
      Random().nextInt(10) + 31,
    ),
    ParameterData(
      "VAC",
      Colors.yellow,
      Random().nextInt(10) + 211,
    ),
    ParameterData(
      "N2O",
      const Color.fromARGB(255, 0, 34, 145),
      Random().nextInt(10) + 41,
    ),
    ParameterData(
      "AIR",
      const Color.fromARGB(255, 198, 230, 255),
      Random().nextInt(10) + 51,
    ),
    ParameterData(
      "CO2",
      const Color.fromRGBO(62, 66, 70, 1),
      Random().nextInt(10) + 61,
    ),
    ParameterData(
      "O2(2)",
      const Color.fromARGB(255, 255, 255, 255),
      Random().nextInt(10) + 71,
    ),
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
    const Color.fromARGB(255, 202, 63, 4),
    Colors.blue,
    Colors.white,
    Colors.yellow,
    const Color.fromARGB(255, 0, 34, 145),
    const Color.fromARGB(255, 198, 230, 255),
    Colors.grey,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("Hellohello hello he lloo dfwrve");
    //_storeData();
  }

  @override
  void didPopNext() {
    // Called when this route is resumed after another route has been popped off
    super.didPopNext();
    _storeData();
  }

  void _storeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      O2_maxLimit = prefs.getInt('O2_maxLimit') ?? 50;
      O2_minLimit = prefs.getInt('O2_minLimit') ?? 30;
      VAC_maxLimit = prefs.getInt('VAC_maxLimit') ?? 250;
      VAC_minLimit = prefs.getInt('VAC_minLimit') ?? 50;
      N2O_maxLimit = prefs.getInt('N2O_maxLimit') ?? 60;
      N2O_minLimit = prefs.getInt('N2O_minLimit') ?? 30;
      AIR_maxLimit = prefs.getInt('AIR_maxLimit') ?? 60;
      AIR_minLimit = prefs.getInt('AIR_minLimit') ?? 30;
      CO2_maxLimit = prefs.getInt('CO2_maxLimit') ?? 60;
      CO2_minLimit = prefs.getInt('CO2_minLimit') ?? 30;
      O2_2_maxLimit = prefs.getInt('O2_2_maxLimit') ?? 60;
      O2_2_minLimit = prefs.getInt('O2_2_minLimit') ?? 30;
      TEMP_maxLimit = prefs.getInt('TEMP_maxLimit') ?? 40;
      TEMP_minLimit = prefs.getInt('TEMP_minLimit') ?? 10;
      HUMI_maxLimit = prefs.getInt('HUMI_maxLimit') ?? 70;
      HUMI_minLimit = prefs.getInt('HUMI_minLimit') ?? 15;
    });
    // print("O2(1): $O2_minLimit");
    // print("O2(1) value ${parameters[2].value}");
    // if (parameters[2].value > O2_maxLimit!) {
    //   print("helllooooooooooooooo");
    //   errors.add("O2(1) is Above High Limit");
    // }
    // if (parameters[2].value < O2_minLimit!) {
    //   print("helllooooooooooooooo");
    //   errors.add("O2(1) is Below Low Limit");
    // }
    // print("Errors detected: ${errors.join(', ')}");

    // // Start error cycle if there are errors
    // if (errors.isNotEmpty && (_errorTimer == null || !_errorTimer!.isActive)) {
    //   _startErrorCycle();
    // } else if (errors.isEmpty && _errorTimer != null && _errorTimer!.isActive) {
    //   // Stop the timer if there are no errors
    //   print("Stopping error cycle as there are no errors.");
    //   _errorTimer!.cancel();
    //   errorNotifier.value = "SYSTEM IS RUNNING OK";
    // }
  }

  void _navigateToDetailPage(int index) async {
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
      List<int> result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AIRD()),
      );

      //  print("Received data: ${result[0]}, ${result[1]}");
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
    } else if (index == 8) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportScreen()),
      );
    }
  }

  late StreamController<void> _updateController;
  late StreamSubscription<void> _streamSubscription;
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

  @override
  void initState() {
    super.initState();

    chartData = getChartData();
    Timer.periodic(Duration(seconds: 1), _updateDataSource);
    _updateController = StreamController<void>.broadcast();

    _streamSubscription = _updateController.stream.listen((_) {
      _updateData();
    });
    date = DateFormat('dd-MM-yyyy  HH:mm').format(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _storeData();
      _updateController.add(null);
      date = DateFormat('dd-MM-yyyy  HH:mm').format(DateTime.now());
    });
  }

  void _updateData() {
    setState(() {
      parameters = parameters.map((param) {
        if (param.name == "O2(1)") {
          int newvalue = Random().nextInt(10) + 31;
          if (newvalue > O2_maxLimit! || newvalue < O2_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     duration: const Duration(milliseconds: 550),
              //     content: Text('${param.name} is not in range!'),
              //   ),
              // );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(param.name, Colors.white, newvalue);
          }
        } else if (param.name == "VAC") {
          int newvalue = Random().nextInt(10) + 211;
          if (newvalue > VAC_maxLimit! || newvalue < VAC_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     duration: const Duration(milliseconds: 550),
              //     content: Text('${param.name} is not in range!'),
              //   ),
              // );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(param.name, Colors.yellow, newvalue);
          }
        } else if (param.name == "N2O") {
          int newvalue = Random().nextInt(10) + 41;
          if (newvalue > N2O_maxLimit! || newvalue < N2O_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: Text('${param.name} is not in range!'),
              //   ),
              // );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(
                param.name, const Color.fromARGB(255, 0, 34, 145), newvalue);
          }
        } else if (param.name == "AIR") {
          int newvalue = Random().nextInt(10) + 51;
          if (newvalue > AIR_maxLimit! || newvalue < AIR_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     duration: const Duration(milliseconds: 550),
              //     content: Text('${param.name} is not in range!'),
              //   ),
              // );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(
                param.name, const Color.fromARGB(255, 198, 230, 255), newvalue);
          }
        } else if (param.name == "CO2") {
          int newvalue = Random().nextInt(10) + 61;
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
          int newvalue = Random().nextInt(10) + 71;
          if (newvalue > O2_2_maxLimit! || newvalue < O2_2_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   // SnackBar(
              //   //   backgroundColor: Colors.red,
              //   //   duration: const Duration(milliseconds: 550),
              //   //   content: Text('${param.name} is not in range!'),
              //   // ),
              // );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(param.name, Colors.white, newvalue);
          }
        } else if (param.name == "TEMP") {
          int newvalue = Random().nextInt(10) + 1;
          if (newvalue > TEMP_maxLimit! || newvalue < TEMP_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   // SnackBar(
              //   //   duration: const Duration(milliseconds: 550),
              //   //   content: Text('${param.name} is not in range!'),
              //   // ),
              // );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(
                param.name, const Color.fromARGB(255, 195, 0, 0), newvalue);
          }
        } else {
          int newvalue = Random().nextInt(10) + 21;
          if (newvalue > HUMI_maxLimit! || newvalue < HUMI_minLimit!) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   // SnackBar(
              //   //   content: Text('${param.name} is not in range!'),
              //   // ),
              // );
            });
            return ParameterData(param.name, Colors.red, newvalue);
          } else {
            return ParameterData(param.name, Colors.blue, newvalue);
          }
        }
      }).toList();
    });
  }

  int time = 60;
  void _updateDataSource(Timer timer) {
    chartData.add(LiveData(
      time++,
      Random().nextInt(10) + 31,
      Random().nextInt(10) + 211,
      Random().nextInt(10) + 41,
      Random().nextInt(10) + 51,
      Random().nextInt(10) + 61,
      Random().nextInt(10) + 71,
      Random().nextInt(10) + 1,
      Random().nextInt(10) + 21,
    ));

    // Remove the oldest data point
    chartData.removeAt(0);

    // List of controllers
    final List<ChartSeriesController> controllers = [
      _chartSeriesController0,
      _chartSeriesController1,
      _chartSeriesController2,
      _chartSeriesController3,
      _chartSeriesController4,
      _chartSeriesController5,
      _chartSeriesController6,
      _chartSeriesController7,
    ];

    // Update all controllers in a loop
    for (var controller in controllers) {
      controller.updateDataSource(
        addedDataIndex: chartData.length - 1,
        removedDataIndex: 0,
      );
    }
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
    String parammeterAir = parameters[5].value.toString();
    print("AIR maximum and AIR minimum: ${AIR_maxLimit}, ${AIR_minLimit}");
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 20,
              ),
            ),
          ],
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "PDA06249999",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Press',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 25, 152, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(
                          text: 'Data', // Adding the trademark symbol here
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '®', // Registered trademark symbol
                    style: TextStyle(
                      color: Colors.red, // Red color
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        ' Medical Gas Alarm + Analyser ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              date,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        toolbarHeight: 30,
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
                    child: Stack(
                      children: [
                        SfCartesianChart(
                          tooltipBehavior: TooltipBehavior(enable: true),
                          legend: Legend(isVisible: true),
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
                            majorGridLines: MajorGridLines(width: 0),
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                            interval: 10,
                            title: AxisTitle(
                              text: 'Time (s)',
                              textStyle: TextStyle(fontSize: 10),
                            ),
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
                            name: 'Hello',
                            axisLine: AxisLine(width: 0),
                            majorTickLines: MajorTickLines(size: 0),
                            // title: AxisTitle(text: 'V'),
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
                              color: Color.fromARGB(255, 0, 0, 0),
                              name: "O2(1)",
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
                              name: "N2O",
                            ),
                            LineSeries<LiveData, int>(
                              onRendererCreated:
                                  (ChartSeriesController controller) {
                                _chartSeriesController3 = controller;
                              },
                              dataSource: chartData,
                              xValueMapper: (LiveData press, _) => press.time,
                              yValueMapper: (LiveData press, _) => press.air,
                              color: Color.fromARGB(255, 17, 255, 148),
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
                              name: "CO2",
                            ),
                            LineSeries<LiveData, int>(
                              onRendererCreated:
                                  (ChartSeriesController controller) {
                                _chartSeriesController5 = controller;
                              },
                              dataSource: chartData,
                              xValueMapper: (LiveData press, _) => press.time,
                              yValueMapper: (LiveData press, _) => press.o2_2,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              name: "O2(2)",
                            ),
                            LineSeries<LiveData, int>(
                              onRendererCreated:
                                  (ChartSeriesController controller) {
                                _chartSeriesController1 = controller;
                              },
                              dataSource: chartData,
                              xValueMapper: (LiveData press, _) => press.time,
                              yValueMapper: (LiveData press, _) => press.vac,
                              yAxisName: 'hello123456789',
                              color: Colors.yellow,
                              name: "VAC",
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
                              name: "TEMP",
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
                        Center(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Opacity(
                              opacity: 0.2,
                              child: Text(
                                'DEMO',
                                style: TextStyle(
                                  fontSize: 150,
                                  color: Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
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
                                          SizedBox(
                                            width: 10,
                                          ),
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
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                              onTap: () => _navigateToDetailPage(5),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.19,
                                width: 110,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _getGradientColors(),
                                    stops: [0.5, 0.5], // Half black, half white
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      14.0), // Adjust the radius if needed
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.3), // Shadow color
                                      spreadRadius:
                                          1, // How much the shadow will spread
                                      blurRadius:
                                          6, // The blur effect of the shadow
                                      offset: Offset(0,
                                          3), // Offset: (horizontal, vertical)
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 33,
                                            ),
                                            if (parameters[5].value < 10)
                                              Text(
                                                '${parammeterAir}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (parameters[5].value > 10)
                                              Text(
                                                '${parammeterAir[0]}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (parameters[5].value > 10)
                                              Text(
                                                '${parammeterAir[1]}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            SizedBox(width: 10),
                                            Text(
                                              parameterUnit[5],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 70,
                                            ),
                                            Text(
                                              parameterNames[5],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            width: 7,
                          ),
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
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            ' ${parameters[7].value}',
                                            style: TextStyle(
                                              color: parameterTextColor[7],
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
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
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            ' ${parameters[3].value}',
                                            style: TextStyle(
                                              color: parameterTextColor[3],
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
                                          SizedBox(
                                            width: 12,
                                          ),
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
                                              fontSize: 15,
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
                                              fontSize: 15,
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
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            child: ValueListenableBuilder<String?>(
              valueListenable: errorNotifier,
              builder: (context, errorMessage, child) {
                if (errorMessage != "SYSTEM IS RUNNING OK") {
                  // Play beep sound if not muted
                  if (!isMuted1 && errorMessage != null) {
                    print("Heloooooooooooooooooooo");
                    // if (errorMessage == null) {
                    //   print("Heloooooooooooooooooooo");
                    //   print("Error Message:${errorMessage}");
                    //   print("helooooooooooooooo inside the else if");
                    //   stopBackgroundMusic();
                    // }
                    playBackgroundMusic();
                  }
                  // else if (errors.isNotEmpty) {
                  //   print("Error Message:${errorMessage}");
                  //   print("helooooooooooooooo inside the else if");
                  //   stopBackgroundMusic();
                  // }
                } else {
                  // Stop beep sound if no error
                  stopBackgroundMusic();
                }
                return Container(
                  height: 30,
                  color: errorMessage != null
                      ? (errorMessage.contains("High")
                          ? Colors.red
                          : (errorMessage.contains("low")
                              ? Color.fromRGBO(255, 158, 0, 50)
                              : (errorMessage.contains("Available")
                                  ? Colors.yellow
                                  : Colors.green)))
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
                      SizedBox(width: 10),
                      if (_showButton ==
                          false) // Add spacing between the buttons
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
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
