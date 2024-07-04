import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

// Import the LineChartWidget
class PressData {
  final String type;
  final double value;
  final DateTime timestamp;

  PressData({required this.type, required this.value, required this.timestamp});

  factory PressData.fromJson(Map<String, dynamic> json) {
    return PressData(
      type: json['type'],
      value: json['value'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

// Import your PressData model

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<PressData> chartData = [];
  StreamController<PressData> streamController = StreamController<PressData>();

  @override
  void initState() {
    super.initState();
    fetchData();
    streamController.stream.listen((pressData) {
      setState(() {
        chartData.add(pressData);
        if (chartData.length > 100) {
          chartData.removeAt(0);
        }
      });
    });
  }

  Future<void> fetchData() async {
    var url = Uri.parse('http://192.168.4.1/event');
    while (true) {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        for (var jsonData in data) {
          PressData pressData = PressData.fromJson(jsonData);
          streamController.add(pressData);
        }
      } else {
        print('Failed to load data');
      }

      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PressData Line Chart')),
      body: SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        series: <LineSeries<PressData, DateTime>>[
          LineSeries<PressData, DateTime>(
            dataSource: chartData,
            xValueMapper: (PressData data, _) => data.timestamp,
            yValueMapper: (PressData data, _) => data.value,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
}
