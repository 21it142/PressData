import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/models/model.dart';
import 'package:pressdata/screens/Limit%20Setting/AIR.dart';
import 'package:pressdata/screens/Limit%20Setting/HUMI.dart';
import 'package:pressdata/screens/Limit%20Setting/N2O.dart';
import 'package:pressdata/screens/Limit%20Setting/O2.dart';
import 'package:pressdata/screens/Limit%20Setting/O2_2.dart';
import 'package:pressdata/screens/Limit%20Setting/TEMP.dart';
import 'package:http/http.dart' as http;
import 'package:pressdata/screens/report_screen.dart';
import 'package:pressdata/screens/setting.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../screens/Limit Setting/CO2.dart';
import '../screens/Limit Setting/VAC.dart';

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

  List<LineSeries<ChartData, DateTime>> _getLineSeries() {
    Map<String, List<ChartData>> groupedData = {};

    // Find the maximum y value to normalize the data
    double maxY =
        chartData.map((data) => data.y).reduce((a, b) => a > b ? a : b);

    for (var data in chartData) {
      if (!groupedData.containsKey(data.type)) {
        groupedData[data.type] = [];
      }
      groupedData[data.type]!.add(data);
    }

    return seriesOrder
        .map((type) {
          final data = groupedData[type];
          if (data != null) {
            final color = colorMap[type] ?? Colors.black;
            return LineSeries<ChartData, DateTime>(
              name: type,
              color: color,
              dataSource: data,
              xValueMapper: (ChartData data, _) =>
                  DateTime.fromMillisecondsSinceEpoch(data.x.toInt()),
              yValueMapper: (ChartData data, _) =>
                  (data.y / maxY) * 100, // Convert to percentage
            );
          }
          return null;
        })
        .where((series) => series != null)
        .cast<LineSeries<ChartData, DateTime>>()
        .toList();
  }

  List<ChartData> chartData = [];
  final StreamController<List<ChartData>> _streamController =
      StreamController<List<ChartData>>.broadcast();

  // Fixed color map for predefined types
  final Map<String, Color> colorMap = {
    'temperature': Color.fromARGB(255, 255, 0, 0),
    'humidity': Colors.blue,
    'o21': Color.fromARGB(255, 255, 255, 255),
    'vac': Colors.yellow,
    'n2o': Color.fromARGB(255, 0, 34, 145),
    'air': Color.fromARGB(114, 1, 2, 1),
    'co2': Color.fromRGBO(62, 66, 70, 1),
    'o22': Colors.white,
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
      if (chartData.length > 60) {
        chartData = chartData.sublist(chartData.length - 60);
      }

      // Add the updated data to the stream
      _streamController.add(List.from(chartData));
    });
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
        MaterialPageRoute(builder: (context) => O2_2()),
      );
    } else if (index == 7) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CO2()),
      );
    }
  }

  late StreamController<void> _updateController;
  late StreamSubscription<void> _streamSubscription;

  @override
  void initState() {
    super.initState();

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

  Map<int, String> specialValues = {
    -333: 'Gas Not found',
    -11: 'Not Connected',
    -1111: 'Out of Range (Positive)',
    -1112: 'Out of Range (Negative)',
  };

  Map<int, Color> specialValueColors = {
    -333: Colors.red,
    -11: Colors.red,
    -1111: Colors.red,
    -1112: Colors.red,
  };
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
      body: Row(
        children: [
          // Graph on the left
          Expanded(
            child: Container(
              height: 350, // Adjust height here
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isDataAvailable
                    ? SfCartesianChart(
                        primaryXAxis: DateTimeAxis(
                          intervalType: DateTimeIntervalType.seconds,
                          interval: 1, // 1-second interval
                          dateFormat: DateFormat('mm:ss'),
                          minimum: chartData.isNotEmpty
                              ? DateTime.fromMillisecondsSinceEpoch(
                                  chartData.first.x.toInt())
                              : DateTime.now().subtract(Duration(seconds: 60)),
                          maximum: DateTime.now(),
                        ),
                        primaryYAxis: NumericAxis(
                          minimum: 0, // Set the minimum value of y-axis to 0
                          maximum:
                              100, // Set the maximum value of y-axis to 100
                        ),
                        legend: Legend(isVisible: true),
                        series: _getLineSeries(),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
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
                      height: 80,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          value,
                                          style: TextStyle(
                                            color: parameterTextColor[0],
                                            fontSize: 32,
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
                      height: 80,
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
                                          Text(
                                            value,
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
                      height: 80,
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
                                          Text(
                                            value,
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
                      height: 80,
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
                                          Text(
                                            value,
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
                      height: 80,
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
                                          Text(
                                            value,
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
                      height: 80,
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
                                          Text(
                                            value,
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
                      height: 80,
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
                                          Text(
                                            value,
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
                      height: 80,
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
                                          Text(
                                            value,
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
    );
    // : Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(
    //           Icons.wifi_off,
    //           size: 30,
    //         ),
    //         Text("Internet is not connected"),
    //       ],
    //     ),
    //   )
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
      if (pressdata.type == 'temperature') {
        _streamDatatemp.sink.add(pressdata);
      } else if (pressdata.type == 'humidity') {
        _streamDatahumi.sink.add(pressdata);
      } else if (pressdata.type == 'o21') {
        _streamDatao21.sink.add(pressdata);
      } else if (pressdata.type == 'vac') {
        _streamDatavac.sink.add(pressdata);
      } else if (pressdata.type == 'n2o') {
        _streamDatan2o.sink.add(pressdata);
      } else if (pressdata.type == 'air') {
        _streamDataair.sink.add(pressdata);
      } else if (pressdata.type == 'co2') {
        _streamDataco2.sink.add(pressdata);
      } else if (pressdata.type == 'o22') {
        _streamDatao22.sink.add(pressdata);
      }
      _streamData.sink.add(pressdata);
    }
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _updateData(data);
    } else {
      print('Failed to load data');
    }
    // Delay before fetching data again (optional)
    await Future.delayed(Duration(seconds: 1));
  }
}
