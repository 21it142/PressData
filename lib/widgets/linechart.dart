import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/screens/limit_settings.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineCharWid extends StatefulWidget {
  const LineCharWid({Key? key}) : super(key: key);

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
  List chartData = [
    [10.01, 25, 12, 14, 16, 18, 20, 22, 24],
    [10.02, 35, 23, 25, 17, 19, 31, 23, 35],
    [10.03, 40, 67, 69, 49, 39, 45, 56, 67],
    [10.04, 35, 45, 46, 56, 34, 65, 23, 12],
    [10.05, 50, 34, 36, 38, 45, 23, 12, 23],
    [10.06, 44, 23, 45, 32, 34, 78, 67, 34],
    [10.07, 60, 23, 34, 45, 56, 67, 78, 34],
  ];
  List<ParameterData> parameters = [
    ParameterData("O2(1)", Colors.white, Random().nextInt(100)),
    ParameterData("VAC", Colors.yellow, Random().nextInt(100)),
    ParameterData(
        "NO2", const Color.fromARGB(255, 0, 34, 145), Random().nextInt(100)),
    ParameterData(
        "TEMP", const Color.fromARGB(255, 195, 0, 0), Random().nextInt(100)),
    ParameterData("HUMI", Colors.blue, Random().nextInt(100)),
    ParameterData(
        "AIR", const Color.fromARGB(255, 198, 230, 255), Random().nextInt(100)),
    ParameterData(
        "CO2", const Color.fromRGBO(62, 66, 70, 1), Random().nextInt(100)),
    ParameterData("O2(2)", const Color.fromARGB(255, 255, 255, 255),
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
  final LinearGradient gradient = LinearGradient(
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
    _updateController = StreamController<void>.broadcast();

    _streamSubscription = _updateController.stream.listen((_) {
      _updateData();
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateController.add(null);
    });
  }

  void _updateRandomNumbers() {
    setState(() {
      parameters = parameters.map((param) {
        return ParameterData(param.name, param.color, Random().nextInt(100));
      }).toList();
    });
  }

  void _updateData() {
    setState(() {
      parameters = parameters.map((param) {
        return ParameterData(param.name, param.color, Random().nextInt(100));
      }).toList();

      chartData = chartData.map((data) {
        data[1] = Random().nextInt(10);
        data[2] = Random().nextInt(20);
        data[3] = Random().nextInt(30);
        data[4] = Random().nextInt(40);
        data[5] = Random().nextInt(50);
        data[6] = Random().nextInt(100);
        data[7] = Random().nextInt(100);
        data[8] = Random().nextInt(100);
        return data;
      }).toList();
    });
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
                  title: AxisTitle(
                      text: 'Reading for Press Data',
                      textStyle: TextStyle(fontSize: 10)),
                ),
                primaryYAxis: const NumericAxis(
                  title: AxisTitle(text: 'Values'),
                ),
                series: [
                  LineSeries(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data[0],
                    yValueMapper: (data, _) => data[1],
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.white,
                    name: "O2(1)",
                  ),
                  LineSeries(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data[1],
                    yValueMapper: (data, _) => data[2],
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.yellow,
                    name: "VAC",
                  ),
                  LineSeries(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data[1],
                    yValueMapper: (data, _) => data[3],
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: const Color.fromARGB(255, 0, 34, 145),
                    name: "NO2",
                  ),
                  LineSeries(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data[1],
                    yValueMapper: (data, _) => data[4],
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: const Color.fromARGB(255, 195, 0, 0),
                    name: "TEMP",
                  ),
                  LineSeries(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data[1],
                    yValueMapper: (data, _) => data[5],
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.blue,
                    name: "HUMI",
                  ),
                  LineSeries(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data[1],
                    yValueMapper: (data, _) => data[6],
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: const Color.fromARGB(255, 198, 230, 255),
                    name: "AIR",
                  ),
                  LineSeries(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data[1],
                    yValueMapper: (data, _) => data[7],
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: const Color.fromRGBO(62, 66, 70, 1),
                    name: "CO2",
                  ),
                  LineSeries(
                    dataSource: chartData,
                    xValueMapper: (data, _) => data[1],
                    yValueMapper: (data, _) => data[8],
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    name: "O2(2)",
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
