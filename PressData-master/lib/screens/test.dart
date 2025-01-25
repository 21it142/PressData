// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pressdata/data/datapoint.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// Future<List<DataPoint>> parseJsonData() async {
//   final String response = await rootBundle.loadString('assets/data.json');
//   final Map<String, dynamic> data = jsonDecode(response);
//   return (data['Sheet1'] as List)
//       .map((json) => DataPoint.fromJson(json))
//       .toList();
// }

// class ChartScreen extends StatefulWidget {
//   @override
//   _ChartScreenState createState() => _ChartScreenState();
// }

// class _ChartScreenState extends State<ChartScreen> {
//   List<DataPoint> chartData = [];

//   Future<void> loadData() async {
//     try {
//       final String response = await rootBundle.loadString('assets/data.json');
//       final List<dynamic> data = json.decode(response)['Sheet1'];
//       chartData = data.map((item) => DataPoint.fromJson(item)).toList();
//       setState(() {});
//     } catch (e) {
//       print('Error loading data: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chart Example")),
//       body: SfCartesianChart(
//         primaryXAxis: CategoryAxis(),
//         series: <LineSeries<DataPoint, String>>[
//           LineSeries<DataPoint, String>(
//             dataSource: chartData,
//             xValueMapper: (DataPoint data, _) => data.time,
//             yValueMapper: (DataPoint data, _) => data.temp,
//             name: 'Temperature',
//             color: Colors.red,
//           ),
//           LineSeries<DataPoint, String>(
//             dataSource: chartData,
//             xValueMapper: (DataPoint data, _) => data.time,
//             yValueMapper: (DataPoint data, _) => data.humidity,
//             name: 'Humidity',
            
//           ),
//           LineSeries<DataPoint, String>(
//             dataSource: chartData,
//             xValueMapper: (DataPoint data, _) => data.time,
//             yValueMapper: (DataPoint data, _) => data.n2o,
//             name: 'N2O',
//           ),
//           LineSeries<DataPoint, String>(
//             dataSource: chartData,
//             xValueMapper: (DataPoint data, _) => data.time,
//             yValueMapper: (DataPoint data, _) => data.air,
//             name: 'AIR',
//           ),
//           LineSeries<DataPoint, String>(
//             dataSource: chartData,
//             xValueMapper: (DataPoint data, _) => data.time,
//             yValueMapper: (DataPoint data, _) => data.co2,
//             name: 'CO2',
//           ),
//           LineSeries<DataPoint, String>(
//             dataSource: chartData,
//             xValueMapper: (DataPoint data, _) => data.time,
//             yValueMapper: (DataPoint data, _) => data.o2_2,
//             name: 'O2(2)',
//           ),
//           LineSeries<DataPoint, String>(
//             dataSource: chartData,
//             xValueMapper: (DataPoint data, _) => data.time,
//             yValueMapper: (DataPoint data, _) => data.vac,
//             name: 'VAC',
//           ),
//           LineSeries<DataPoint, String>(
//             dataSource: chartData,
//             xValueMapper: (DataPoint data, _) => data.time,
//             yValueMapper: (DataPoint data, _) => data.o2_1,
//             name: 'O2(1)',
//           ),
//         ],
//       ),
//     );
//   }
// }
