import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetpack/jetpack.dart';

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
// import 'package:pressdata/screens/report_screenDemo.dart';
// import 'package:pressdata/screens/setting.dart';
// import 'package:pressdata/widgets/bar.dart';
// import 'package:pressdata/widgets/demo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../screens/Limit Setting/CO2.dart';
import '../screens/Limit Setting/VAC.dart';

class AccumulatedData {
  double sum;
  int count;

  AccumulatedData(this.sum, this.count);

  double get average => sum / count;
}

class LineCharWid extends StatefulWidget {
  const LineCharWid({Key? key}) : super(key: key);

  @override
  State<LineCharWid> createState() => _LineCharWidState();

  captureChartImage() {}
}

class ParameterData {
  final String name;
  final Color color;
  int value;

  ParameterData(this.name, this.color, this.value);
}

class ChartData {
  ChartData(this.x, this.y, this.type);

  final double x;
  final double y;
  final String type;
}

class _LineCharWidState extends State<LineCharWid> {
  final StreamController<String> _messageController =
      StreamController<String>();
  Timer? _timer;
  int _messageIndex = 0;
  final List<String> _messages = [
    "Message 1",
    "Message 2",
    "Message 3",
    "Message 4",
    "Message 5",
    "Message 6",
    "Message 7",
    "Message 8",
  ];
  final MutableLiveData<String> messageerror =
      MutableLiveData("SYSTEM IS RUNNING OK");

  List<PressData> pressdata = [];
  StreamController<PressData> _streamData = StreamController();
  StreamController<PressData> _streamDatatemp = StreamController();
  StreamController<PressData> _streamDatahumi = StreamController();
  StreamController<PressData> _streamDatao21 = StreamController();
  StreamController<PressData> _streamDatavac = StreamController();
  StreamController<PressData> _streamDatan2o = StreamController();
  StreamController<PressData> _streamDataair = StreamController();
  StreamController<PressData> _streamDataco2 = StreamController();
  StreamController<PressData> _streamDatao22 = StreamController();
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

  Map<String, AccumulatedData> accumulatedData = {};

  Future<void> storeAveragedData(String formattedDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, double> averagedData = {};

    accumulatedData.forEach((type, data) {
      averagedData[type] = data.sum / data.count;
    });

    String jsonAveragedData = jsonEncode(averagedData);
    await prefs.setString(formattedDate, jsonAveragedData);

    // Clear accumulated data for the next minute
    accumulatedData.clear();
  }

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
      print(O2_2_maxLimit);
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
      newData.add(ChartData(x, entry['value'].toDouble(), entry['type']));
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

  void _navigateToDetailPage(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TEMP()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HUMI()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => O2()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VAC()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => N2O()),
      );
    } else if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AIR()),
      );
    } else if (index == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CO2()),
      );
    } else if (index == 7) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => O2_2()),
      );
    }
  }

  late StreamController<void> _updateController;
  late StreamSubscription<void> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _storeData();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _messageController.add(_messages[_messageIndex]);
      _messageIndex = (_messageIndex + 1) % _messages.length;
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // Trigger the cleanup and update the chart
        _getLineSeries();
      });
    });
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
    _streamSubscription.cancel(); // Cancel the subscription
    _streamDatatemp.close();
    _streamDataair.close();
    _streamDatao21.close();
    _streamDatahumi.close();
    _streamDatao22.close();
    _streamDatavac.close();
    _streamDataco2.close();
    _streamDatan2o.close();
    _streamData.close();

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
                                  dateFormat: DateFormat('mm:ss'),
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
                            child: StreamBuilder<PressData>(
                              stream: _streamDatatemp.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  PressData pressData = snapshot.data!;
                                  String value = pressData.value.toString();
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
                            child: StreamBuilder<PressData>(
                                stream: _streamDatahumi.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    PressData pressData = snapshot.data!;
                                    PressData data = pressData;
                                    // String type = data.type;
                                    String value = data.value.toString();
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
                            child: StreamBuilder<PressData>(
                                stream: _streamDatao21.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    PressData pressData = snapshot.data!;
                                    PressData data = pressData;
                                    // String type = data.type;
                                    String value = data.value.toString();
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
                            child: StreamBuilder<PressData>(
                                stream: _streamDatavac.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    PressData pressData = snapshot.data!;
                                    PressData data = pressData;
                                    // String type = data.type;
                                    String value = data.value.toString();
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
                            child: StreamBuilder<PressData>(
                                stream: _streamDatan2o.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    PressData pressData = snapshot.data!;
                                    PressData data = pressData;
                                    //  String type = data.type;
                                    String value = data.value.toString();
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
                            child: StreamBuilder<PressData>(
                                stream: _streamDataair.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    PressData pressData = snapshot.data!;
                                    PressData data = pressData;
                                    //String type = data.type;
                                    String value = data.value.toString();
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
                            child: StreamBuilder<PressData>(
                                stream: _streamDataco2.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    PressData pressData = snapshot.data!;
                                    PressData data = pressData;
                                    //  String type = data.type;
                                    String value = data.value.toString();
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
                            child: StreamBuilder<PressData>(
                                stream: _streamDatao22.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    PressData pressData = snapshot.data!;
                                    PressData data = pressData;
                                    // String type = data.type;
                                    String value = data.value.toString();
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
                                              Text(
                                                value,
                                                style: TextStyle(
                                                  color: parameterTextColor[7],
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              if (value != '-333')
                                                Text(
                                                  parameterUnit[7],
                                                  style: TextStyle(
                                                    color:
                                                        parameterTextColor[7],
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
          child: Container(
            height: 30,
            color: Colors.grey[200], // Background color of the bar
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(flex: 20),

                LiveDataBuilder<String>(
                    liveData: messageerror,
                    builder: (BuildContext context, String message) => Text(
                          message,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )),

                const Spacer(flex: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          style: BorderStyle.solid, color: Colors.black87),
                      borderRadius: BorderRadius.circular(5), // Square corners
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
                SizedBox(width: 12), // Add spacing between the buttons
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          style: BorderStyle.solid, color: Colors.black87),
                      borderRadius: BorderRadius.circular(5), // Square corners
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
                Spacer(),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> getdata() async {
    var url = Uri.parse('http://192.168.4.1/event');
    final response = await http.get(url);

    final data = json.decode(response.body);

    // Debugging: Print out the type and structure of the data
    print('Type of data: ${data.runtimeType}');
    print('Data structure: $data');

    // Iterate over each map in the list and create PressData objects
    for (var jsonData in data) {
      PressData pressdata = PressData.fromJson(jsonData);
      if (!accumulatedData.containsKey(pressdata.type)) {
        accumulatedData[pressdata.type] = AccumulatedData(0, 0);
      }

      accumulatedData[pressdata.type]!.sum += pressdata.value;
      accumulatedData[pressdata.type]!.count += 1;
      print("accumulatedData.length->>>>>>>${accumulatedData.length}");
      switch (pressdata.type) {
        case 'temperature':
          _streamDatatemp.sink.add(pressdata);
          if (pressdata.value > TEMP_maxLimit) {
            messageerror.value = "Temp is Above High Setting";
          }
          if (pressdata.value < TEMP_minLimit!) {
            messageerror.value = "Temp is below Low Setting";
          }
          break;
        case 'humidity':
          _streamDatahumi.sink.add(pressdata);
          if (pressdata.value > HUMI_maxLimit) {
            //outOfRangeMessagesHumi = "HUMI is Above High Setting";
            messageerror.value = "Humi is Above High Setting";
          }
          if (pressdata.value < HUMI_minLimit!) {
            //outOfRangeMessagesHumi = "HUMI is below Low Setting";
            messageerror.value = "Humi is Below Low Setting";
          }
          break;
        case 'o21':
          _streamDatao21.sink.add(pressdata);
          if (pressdata.value > O2_maxLimit) {
            messageerror.value = "O2 (1) is Above High Setting";
          }
          if (pressdata.value < O2_minLimit!) {
            // outOfRangeMessageso2 = "O2 (1) is below Low Setting";
            messageerror.value = "O2 (1) is Below Low Setting";
          }
          break;

        case 'vac':
          _streamDatavac.sink.add(pressdata);
          if (pressdata.value > VAC_maxLimit) {
            messageerror.value = "VAC is Above HighSetting";
          }
          if (pressdata.value < VAC_minLimit!) {
            // outOfRangeMessagesvac = " VAC is below Low Setting";
            messageerror.value = "VAC is below Low Setting";
          }
          break;
        case 'n2o':
          _streamDatan2o.sink.add(pressdata);
          if (pressdata.value > N2O_maxLimit) {
            messageerror.value = "N2O is Above HighSetting";
          }
          if (pressdata.value < N2O_minLimit!) {
            messageerror.value = "N2O is Below Low Setting";
          }
          break;
        case 'air':
          _streamDataair.sink.add(pressdata);
          if (pressdata.value > AIR_maxLimit) {
            messageerror.value = "AIR is Above High Setting";
          }
          if (pressdata.value < AIR_minLimit!) {
            messageerror.value = "AIR is Below Low Setting";
          }
          break;
        case 'co2':
          _streamDataco2.sink.add(pressdata);
          if (pressdata.value > CO2_maxLimit) {
            messageerror.value = "CO2 is Above High Setting";
          }
          if (pressdata.value < CO2_minLimit!) {
            messageerror.value = "CO2 is Below Low Setting";
          }
          break;
        case 'o22':
          _streamDatao22.sink.add(pressdata);
          if (pressdata.value > O2_2_maxLimit) {
            messageerror.value = "O2 (2) is Above High Setting";
          }
          if (pressdata.value < O2_2_minLimit!) {
            messageerror.value = "O2 (2) is Below low Setting";
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

    // if (temp_range &&
    //     humi_range &&
    //     o21_range &&
    //     n2o_range &&
    //     vac_range &&
    //     air_range &&
    //     co2_range &&
    //     o22_range) {
    //   systemMessage = "SYSTEM IS RUNNING OK";
    //   _messageTimer?.cancel();
    // }
  }
}
