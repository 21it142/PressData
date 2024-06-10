import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/screens/limit_settings.dart';
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

class LineCharWid extends StatefulWidget {
  const LineCharWid({Key? key, required int maxLimit, required int minLimit})
      : super(key: key);

  @override
  State<LineCharWid> createState() => _LineCharWidState();
}

class ParameterData {
  final String name;
  final Color color;
  int value;

  ParameterData(this.name, this.color, this.value);
}

class _LineCharWidState extends State<LineCharWid> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController0;
  late ChartSeriesController _chartSeriesController1;
  late ChartSeriesController _chartSeriesController2;
  late ChartSeriesController _chartSeriesController3;
  late ChartSeriesController _chartSeriesController4;
  late ChartSeriesController _chartSeriesController5;
  late ChartSeriesController _chartSeriesController6;
  late ChartSeriesController _chartSeriesController7;

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
        "AIR", const Color.fromARGB(255, 195, 0, 0), Random().nextInt(100)),
    ParameterData("CO2", Colors.blue, Random().nextInt(100)),
    ParameterData("O2(2)", const Color.fromARGB(255, 198, 230, 255),
        Random().nextInt(100)),
    ParameterData(
        "TEMP", const Color.fromRGBO(62, 66, 70, 1), Random().nextInt(100)),
    ParameterData("HUMI", const Color.fromARGB(255, 255, 255, 255),
        Random().nextInt(100)),
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
  void _navigateToDetailPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LimitSettings(
          title: parameterNames[index],
          card_color: parameterColors[index],
          subtitle: parameterUnit[index],
          Font_color: parameterTextColor[
              index], // Additional subtitle information if required
        ),
      ),
    );
  }

  late StreamController<void> _updateController;
  late StreamSubscription<void> _streamSubscription;

  @override
  void initState() {
    super.initState();

    chartData = getChartData();
    Timer.periodic(Duration(seconds: 1), updateDataSource);
    _updateController = StreamController<void>.broadcast();

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
          return ParameterData(param.name, param.color, Random().nextInt(10));
        } else if (param.name == "VAC") {
          return ParameterData(
              param.name, param.color, Random().nextInt(10) + 11);
        } else if (param.name == "N2O") {
          return ParameterData(
              param.name, param.color, Random().nextInt(10) + 21);
        } else if (param.name == "AIR") {
          return ParameterData(
              param.name, param.color, Random().nextInt(10) + 31);
        } else if (param.name == "CO2") {
          return ParameterData(
              param.name, param.color, Random().nextInt(10) + 41);
        } else if (param.name == "O2(2)") {
          return ParameterData(
              param.name, param.color, Random().nextInt(10) + 51);
        } else if (param.name == "TEMP") {
          return ParameterData(
              param.name, param.color, Random().nextInt(10) + 61);
        }
        return ParameterData(
            param.name, param.color, Random().nextInt(10) + 71);
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
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 3.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 1.55 /
                            1, // Adjust the aspect ratio to change card size
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _navigateToDetailPage(index),
                          child: Card(
                            color: parameterColors[index],
                            elevation: 4.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: parameterColors[index],
                                gradient: index == 3
                                    ? const LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.white,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    2.0), // Adjust the padding inside the card
                                child: Column(
                                  children: [
                                    Text(
                                      ' ${parameters[index].value}', // Random number displayed alongside the parameter name
                                      style: TextStyle(
                                          color: parameterTextColor[index],
                                          fontSize: 22,
                                          fontWeight: FontWeight
                                              .bold), // Use white text color for contrast
                                    ),
                                    Text(
                                      ' ${parameterUnit[index]}', // Random number displayed alongside the parameter name
                                      style: TextStyle(
                                          color: parameterTextColor[index],
                                          fontSize: 7,
                                          fontWeight: FontWeight
                                              .bold), // Use white text color for contrast
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      parameterNames[index],
                                      style: TextStyle(
                                          color: parameterTextColor[index],
                                          fontSize:
                                              12), // Use white text color for contrast
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
