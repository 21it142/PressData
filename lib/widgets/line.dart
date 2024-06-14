import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LiveLineChart extends StatefulWidget {
  @override
  _LiveLineChartState createState() => _LiveLineChartState();
}

class _LiveLineChartState extends State<LiveLineChart> {
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

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      while (true) {
        final response =
            await http.get(Uri.parse('http://192.168.0.113/event'));
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          _updateData(data);
        } else {
          print('Failed to load data');
        }
        // Delay before fetching data again (optional)
        await Future.delayed(Duration(seconds: 1));
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

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

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 350, // Adjust height here
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCartesianChart(
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
            primaryYAxis: NumericAxis(), // Update the y-axis
            legend: Legend(isVisible: true),
            series: _getLineSeries(),
          ),
        ),
      ),
    );
  }

  List<LineSeries<ChartData, DateTime>> _getLineSeries() {
    Map<String, List<ChartData>> groupedData = {};

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
              yValueMapper: (ChartData data, _) => data.y,
            );
          }
          return null;
        })
        .where((series) => series != null)
        .cast<LineSeries<ChartData, DateTime>>()
        .toList();
  }
}

class ChartData {
  ChartData(this.x, this.y, this.type);

  final double x;
  final double y;
  final String type;
}
