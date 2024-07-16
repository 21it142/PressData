import 'dart:async';
import 'dart:convert';
import 'dart:ui';
//import 'package:path/path.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
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
import 'package:pressdata/screens/ReportScreen.dart';
import 'package:pressdata/screens/main_page.dart';
import 'package:pressdata/screens/setting.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:intl/intl.dart';

import '../screens/Limit Setting/CO2.dart';
import '../screens/Limit Setting/VAC.dart';

class LineCharWid extends StatefulWidget {
  const LineCharWid({Key? key}) : super(key: key);

  @override
  State<LineCharWid> createState() => _LineCharWidState();
}

class ChartData {
  ChartData(this.x, this.y, this.type, this.deviceNo);

  final double x;
  final double y;
  final String type;
  dynamic deviceNo;
}

class _LineCharWidState extends State<LineCharWid> {
  final db = PressDataDb();
  final _tempDataStreamController = StreamController<int>.broadcast();
  int _elapsedTime = 0;
  Timer? _timer;
  final MutableLiveData<String> messageerror =
      MutableLiveData("SYSTEM IS RUNNING OK");
  int value = 0;
  List<PressData> pressdata = [];
  StreamController<PressData> _streamData = StreamController();
  StreamController<int> _storetemp = StreamController();
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
  int _currentIndex = 0;
  String message = "SYSTEM IS RUNNING OK";
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
  //Map<String, AccumulatedData> accumulatedData = {};
  List<LineSeries<ChartData, DateTime>> _getLineSeries() {
    Map<String, List<ChartData>> groupedData = {};

    // Get the current time in milliseconds
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    // Filter out data older than 60 seconds
    chartData = chartData.where((data) {
      return currentTime - data.x <= 60000;
    }).toList();

    for (var data in chartData) {
      if (!groupedData.containsKey(data.type)) {
        groupedData[data.type] = [];
      }
      groupedData[data.type]!.add(data);
    }

    return seriesOrder.map((type) {
      var data = groupedData[type];
      if (data != null) {
        final color = colorMap[type] ?? Colors.black;
        return LineSeries<ChartData, DateTime>(
          name: type,
          color: color,
          dataSource: data,
          xValueMapper: (ChartData data, _) =>
              DateTime.fromMillisecondsSinceEpoch(data.x.toInt()),
          yValueMapper: (ChartData data, _) {
            if (type == 'vac') {
              return (data.y / 750) * 100; // Convert 'vac' to percentage
            }
            return (data.y / 100) * 100; // Convert other types to percentage
          },
        );
      } else {
        print("The Else Value---->  ${data?.first.y}");
        return LineSeries<ChartData, DateTime>(
          dataSource: [],
          xValueMapper: (ChartData data, _) => DateTime.now(),
          yValueMapper: (ChartData data, _) => 0,
        ); // Return an empty series if data is null
      }
    }).toList();
  }

  void _startBeep(BuildContext context) {
    FlutterBeep.beep();
  }

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
      TEMP_maxLimit = prefs.getInt('TEMP_maxLimit') ?? 32;
      TEMP_minLimit = prefs.getInt('TEMP_minLimit') ?? 20;
      HUMI_maxLimit = prefs.getInt('HUMI_maxLimit') ?? 50;
      HUMI_minLimit = prefs.getInt('HUMI_minLimit') ?? 30;
      //   print(O2_2_maxLimit);
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
    'temperature',
    'humidity',
    'o21',
    'vac',
    'n2o',
    'air',
    'co2',
    'o22',
  ];

  final LinearGradient gradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.blue, Colors.green], // Two colors for the gradient
  );
  void _updateData(List<dynamic> data) {
    double x = DateTime.now().millisecondsSinceEpoch.toDouble();
    print('Received Data: $data');
    List<ChartData> newData = [];

    for (var entry in data) {
      if (entry['type'] != 'deviceNo') {
        newData.add(
            ChartData(x, entry['value'].toDouble(), entry['type'], entry['']));
      }
    }

    print('New Data: $newData');

    // Combine new data with existing data and keep only the most recent 60 data points
    setState(() {
      chartData.addAll(newData);
      // if (chartData.length > 60) {
      //   chartData.removeAt(0);
      // }

      // Add the updated data to the stream
      _streamController.add(List.from(newData));
    });
  }

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
    final BuildContext context = this.context;
    if (index == 0) {
      final value = Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TEMP()),
      );
      if (value == 1) {
        _storeData();
      }
    } else if (index == 1) {
      final value = Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HUMI()),
      );
      if (value == 1) {
        _storeData();
      }
    } else if (index == 2) {
      final value = Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => O2()),
      );
      if (value == 1) {
        _storeData();
      }
    } else if (index == 3) {
      final value = Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VAC()),
      );
      if (value == 1) {
        _storeData();
      }
    } else if (index == 4) {
      final value = Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => N2O()),
      );
      if (value == 1) {
        _storeData();
      }
    } else if (index == 5) {
      final value = Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AIR()),
      );
      if (value == 1) {
        _storeData();
      }
    } else if (index == 6) {
      final value = Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CO2()),
      );
      if (value == 1) {
        _storeData();
      }
    } else if (index == 7) {
      final value = Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => O2_2()),
      );
      if (value == 1) {
        _storeData();
      }
    }
  }

  late StreamController<void> _updateController;
  late StreamSubscription<void> _streamSubscription;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _storeData();
    });
    // startFetchingData();
    _message.clear();
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
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Trigger the cleanup and update the chart

        _getLineSeries();
      });

      Stream.periodic(Duration(seconds: 2), (_) {
        _streamDataerror;
      });
    });
    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   hello();
    // });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateController.add(null);
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      getdata();
    });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDataAvailable = chartData.isNotEmpty;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: Row(
            children: [
              // Graph on the left
              Expanded(
                child: Container(
                  height: 350, // Adjust height here
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isConnected
                        ? isDataAvailable
                            ? SfCartesianChart(
                                tooltipBehavior: TooltipBehavior(enable: false),
                                primaryXAxis: DateTimeAxis(
                                  intervalType: DateTimeIntervalType.seconds,
                                  //majorGridLines: MajorGridLines(width: 1),
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  interval: 10, // 1-second interval
                                  dateFormat: DateFormat('hh:mm:ss'),
                                  minimum: chartData.isNotEmpty
                                      ? DateTime.fromMillisecondsSinceEpoch(
                                          chartData.first.x.toInt())
                                      : DateTime.now()
                                          .subtract(Duration(seconds: 20)),
                                  maximum: DateTime.now(),
                                ),
                                primaryYAxis: NumericAxis(
                                  //  majorTickLines: MajorTickLines(size: 0),
                                  interval: 20,
                                  minimum:
                                      0, // Set the minimum value of y-axis to 0
                                  maximum:
                                      100, // Set the maximum value of y-axis to 100
                                ),
                                legend: Legend(isVisible: true),
                                series: _getLineSeries(),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              )
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
                        onTap: () => _navigateToDetailPage(0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: parameterColors[0],
                            elevation: 4.0,
                            child: StreamBuilder<int>(
                              stream: _streamDatatemp.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  int pressData = snapshot.data!;
                                  String value = pressData.toString();
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
                                            if (value != '-333')
                                              Text(
                                                value,
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
                                } else {
                                  return CircularProgressIndicator(
                                    color: parameterTextColor[0],
                                  );
                                }
                              },
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
                                                        parameterTextColor[0],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
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
                                  } else {
                                    return CircularProgressIndicator(
                                      color: parameterTextColor[1],
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
                        onTap: () => _navigateToDetailPage(2),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: parameterColors[2],
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
                                              if (value != '-333')
                                                Text(
                                                  value,
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[2],
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
                                  } else {
                                    return CircularProgressIndicator(
                                      color: parameterTextColor[2],
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
                            color: parameterColors[3],
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
                                              if (value != '-333')
                                                Text(
                                                  value,
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[3],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              const SizedBox(width: 15),
                                              if (value != '-333')
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
                                    return CircularProgressIndicator(
                                      color: parameterTextColor[3],
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
                        onTap: () => _navigateToDetailPage(4),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: parameterColors[4],
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
                                              if (value != '-333')
                                                Text(
                                                  value,
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[4],
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
                                  } else {
                                    return CircularProgressIndicator(
                                      color: parameterTextColor[4],
                                    );
                                  }
                                }),
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
                            child: StreamBuilder<int>(
                                stream: _streamDataair.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    int pressData = snapshot.data!;
                                    int data = pressData;
                                    //String type = data.type;
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
                                                        parameterTextColor[5],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (value != '-333')
                                                Text(
                                                  value,
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[5],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              const SizedBox(width: 15),
                                              if (value != '-333')
                                                Text(
                                                  parameterUnit[5],
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[5],
                                                    fontSize: 7,
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
                                    );
                                  } else {
                                    return CircularProgressIndicator(
                                      color: parameterTextColor[5],
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
                        onTap: () => _navigateToDetailPage(6),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.21,
                          width: 120,
                          child: Card(
                            color: parameterColors[6],
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
                                              if (value != '-333')
                                                Text(
                                                  value,
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[6],
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (value != '-333')
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
                                  } else {
                                    return CircularProgressIndicator(
                                      color: parameterTextColor[6],
                                    );
                                  }
                                }),
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
                                              const SizedBox(width: 15),
                                              if (value != '-333')
                                                Text(
                                                  value,
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[7],
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
                                  } else {
                                    return CircularProgressIndicator(
                                      color: parameterTextColor[7],
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
        Align(
          child: StreamBuilder<String>(
              stream: _streamDataerror.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(_currentIndex);
                  if (!_message.contains(snapshot.data.toString())) {
                    _message.add(snapshot.data.toString());
                  }

                  message = _message.isNotEmpty
                      ? _message[_currentIndex]
                      : "SYSTEM IS RUNNING OK";
                  // if (message != "SYSTEM IS RUNNING OK") {
                  //   _startBeep(context);
                  // } else {
                  //   _stopBeep();
                  // }
                  return Container(
                    height: 30,
                    color: message == "SYSTEM IS RUNNING OK"
                        ? Colors.grey[200]
                        : Colors.red, // Background color of the bar
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Spacer(flex: 20),
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(flex: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black87),
                              borderRadius:
                                  BorderRadius.circular(5), // Square corners
                            ),
                            minimumSize: Size(
                                90, 25), // Set minimum size to maintain height
                            backgroundColor: Color.fromARGB(255, 192, 191, 191),
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Setting1()),
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
                        SizedBox(width: 12), // Add spacing between the buttons
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black87),
                              borderRadius:
                                  BorderRadius.circular(5), // Square corners
                            ),
                            minimumSize: Size(
                                90, 25), // Set minimum size to maintain height
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
                        Spacer(),
                      ],
                    ),
                  );
                } else {
                  return Text("SYSTEM IS RUNNING OK");
                }
              }),
        ),
      ]),
    );
  }

  void copy_database() {
    print('heloooooooooooooooo->>>>>>>>>>>>>>>${db.getAllPressData()}');
  }
// Future<void> storeAverageData() async {
//     print("hiiii");
//     if (purityList.isNotEmpty &&
//         flowRateList.isNotEmpty &&
//         pressureList.isNotEmpty &&
//         temperatureList.isNotEmpty) {
//       double averagePurity =
//           purityList.reduce((a, b) => a + b) / purityList.length;
//       double averageFlowRate =
//           flowRateList.reduce((a, b) => a + b) / flowRateList.length;
//       double averagePressure =
//           pressureList.reduce((a, b) => a + b) / pressureList.length;
//       double averageTemperature =
//           temperatureList.reduce((a, b) => a + b) / temperatureList.length;

//       String? serialNo =
//           _serialNo; // You need to fetch the actual serial number
//       DateTime dateTime = DateTime.now();

//       final entity = OxyDatabaseCompanion(
//         purity: drift.Value(averagePurity),
//         flow: drift.Value(averageFlowRate),
//         pressure: drift.Value(averagePressure),
//         temp: drift.Value(averageTemperature),
//         serialNo: drift.Value(serialNo!),
//         recordedAt: drift.Value(dateTime),
//       );
//       print(
//           'Print before store:  Purity: ${averagePurity}, Flow Rate: ${averageFlowRate}, Pressure: ${averagePressure}, Temperature: ${averageTemperature}, Serial No: ${serialNo!}, DateTime: ${dateTime}');
//       await _db.insertOxyData(entity);
//       await printStoredData();

//       // Clear the lists after storing data
//       purityList.clear();
//       flowRateList.clear();
//       pressureList.clear();
//       temperatureList.clear();
//     }
//   }
  int temp = 0, vac = 0, humi = 0, co2 = 0, o22 = 0, o21 = 0, air = 0, n2o = 0;

  Future<void> getdata() async {
    var url = Uri.parse('http://192.168.4.1/event');
    final response = await http.get(url);

    final data = json.decode(response.body);
    DateTime dateTime = DateTime.now();
    for (var jsonData in data) {
      PressData pressdata = PressData.fromJson(jsonData);
      switch (pressdata.type) {
        case 'temperature':
          temp = pressdata.value;
          _streamDatatemp.sink.add(pressdata.value);
          //    _storetemp.sink.add(pressdata.value);
          print("Temp Limit:${TEMP_maxLimit}");
          if (pressdata.value > TEMP_maxLimit) {
            print("I am IN inside temp::");
            _streamDataerror.sink.add("Temp is Above High Setting");
            //   messageerror.value = "Temp is Above High Setting";
          }
          if (pressdata.value < TEMP_minLimit!) {
            _streamDataerror.sink.add("Temp is Below Low Setting");
            //  messageerror.value = "Temp is below Low Setting";
          }
          break;
        case 'humidity':
          print("humi Limit:${HUMI_maxLimit}");
          _streamDatahumi.sink.add(pressdata.value);
          humi = pressdata.value;
          if (pressdata.value > HUMI_maxLimit) {
            //outOfRangeMessagesHumi = "HUMI is Above High Setting";
            _streamDataerror.sink.add("HUMI is Above High Setting");
            // messageerror.value = "Humi is Above High Setting";
          }
          if (pressdata.value < HUMI_minLimit!) {
            //outOfRangeMessagesHumi = "HUMI is below Low Setting";
            _streamDataerror.sink.add("HUMI is Below Low Setting");
          }
          break;
        case 'o21':
          print("O2  1 Limit:${O2_maxLimit}");
          _streamDatao21.sink.add(pressdata.value);
          o21 = pressdata.value;
          if (pressdata.value > O2_maxLimit) {
            //  messageerror.value = "O2 (1) is Above High Setting";
            _streamDataerror.sink.add("O2 (1) is Above High Setting");
          }
          if (pressdata.value < O2_minLimit!) {
            // outOfRangeMessageso2 = "O2 (1) is below Low Setting";
            // messageerror.value = "O2 (1) is Below Low Setting";
            Future.delayed(Duration(seconds: 1), () {
              _streamDataerror.sink.add("O2 (1) is  Below Low Setting");
            });
          }
          break;

        case 'vac':
          _streamDatavac.sink.add(pressdata.value);
          print("VAC VALUE${VAC_maxLimit}");
          vac = pressdata.value;
          if (pressdata.value > VAC_maxLimit) {
            // messageerror.value = "VAC is Above HighSetting";
            _streamDataerror.sink.add("VAC is Above High Setting");
          }
          if (pressdata.value < VAC_minLimit!) {
            // outOfRangeMessagesvac = " VAC is below Low Setting";
            // messageerror.value = "VAC is below Low Setting";
            _streamDataerror.sink.add("VAC is Below Low Setting");
          }
          break;
        case 'n2o':
          print("N2o v$N2O_maxLimit");
          _streamDatan2o.sink.add(pressdata.value);
          n2o = pressdata.value;
          if (pressdata.value > N2O_maxLimit) {
            // messageerror.value = "N2O is Above HighSetting";
            _streamDataerror.sink.add("N2O is Above High Setting");
          }
          if (pressdata.value < N2O_minLimit!) {
            // messageerror.value = "N2O is Below Low Setting";
            _streamDataerror.sink.add("N2O is Below Low Setting");
          }
          break;
        case 'air':
          air = pressdata.value;
          _streamDataair.sink.add(pressdata.value);
          if (pressdata.value > AIR_maxLimit) {
            //messageerror.value = "AIR is Above High Setting";
            _streamDataerror.sink.add("AIR is Above High Setting");
          }
          if (pressdata.value < AIR_minLimit!) {
            // messageerror.value = "AIR is Below Low Setting";

            _streamDataerror.sink.add("AIR is Below Low Setting");
          }
          break;
        case 'co2':
          co2 = pressdata.value;
          _streamDataco2.sink.add(pressdata.value);
          if (pressdata.value > CO2_maxLimit) {
            //  messageerror.value = "CO2 is Above High Setting";
            _streamDataerror.sink.add("CO2 is Above High Setting");
          }
          if (pressdata.value < CO2_minLimit!) {
            //  messageerror.value = "CO2 is Below Low Setting";
            _streamDataerror.sink.add("CO2 is Below Low Setting");
          }
          break;
        case 'o22':
          o22 = pressdata.value;
          _streamDatao22.sink.add(pressdata.value);
          if (pressdata.value > O2_2_maxLimit) {
            //  messageerror.value = "O2 (2) is Above High Setting";
            _streamDataerror.sink.add("O2 (2) is Above High Setting");
          }
          if (pressdata.value < O2_2_minLimit!) {
            // messageerror.value = "O2 (2) is Below low Setting";
            _streamDataerror.sink.add("O2 (2) is Below Low Setting");
          }
          break;
        default:
          messageerror.value = " SYSTEM IS RUNNING OK ";
          break;
      }
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _updateData(data);
      }

      // Delay before fetching data again (optional)
      await Future.delayed(Duration(seconds: 1));
    }

    final entity = PressDataTableCompanion(
      temperature: drift.Value(temp),
      humidity: drift.Value(humi),
      o2: drift.Value(o21),
      vac: drift.Value(vac),
      n2o: drift.Value(n2o),
      airPressure: drift.Value(air),
      co2: drift.Value(co2),
      o22: drift.Value(o22),
      recordedAt: drift.Value(dateTime),
    );
    copy_database();
    print("entity->>>>>>>>>>>>>>>>>>>>>$entity");
    await db.getAllPressData().toString();
    await db.insertPressData(entity);
  }
}
