import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pressdata/screens/report_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class DailyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Report Line Chart'),
      ),
      body: LineChartScreen(),
    );
  }
}

class LineChartScreen extends StatefulWidget {
  const LineChartScreen({super.key});

  @override
  _LineChartScreenState createState() => _LineChartScreenState();
}

class _LineChartScreenState extends State<LineChartScreen> {
  final GlobalKey chartKey = GlobalKey();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final data = generateRandomData();
    final minData = generateConstantData(47);
    final maxData = generateConstantData(60);

    return Column(
      children: [
        Expanded(
          child: RepaintBoundary(
            key: chartKey,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                intervalType: DateTimeIntervalType.hours,
                dateFormat: DateFormat.Hm(),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 100,
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(isVisible: true),
              series: <CartesianSeries>[
                LineSeries<ChartData, DateTime>(
                  dataSource: data,
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.black,
                ),
                LineSeries<ChartData, DateTime>(
                  dataSource: minData,
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.yellow,
                ),
                LineSeries<ChartData, DateTime>(
                  dataSource: maxData,
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              _captureAndShowImage(context);
            },
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Proceed'),
          ),
        ),
      ],
    );
  }

  Future<void> _captureAndShowImage(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final RenderRepaintBoundary boundary =
          chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage();
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      Navigator.of(context).pop(); // Pop DailyChart page

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReportScreen(
            imageBytes: pngBytes,
          ),
        ),
      );
    } catch (e) {
      print('Error capturing image: $e');
      // Optionally show an error message to the user
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class ChartData {
  final DateTime time;
  final double value;

  ChartData(this.time, this.value);
}

List<ChartData> generateRandomData() {
  final random = Random();
  final now = DateTime.now();
  return List.generate(1440, (index) {
    return ChartData(
      now.add(Duration(minutes: index)),
      50 + random.nextDouble() * 3, // Random value between 50 and 53
    );
  });
}

List<ChartData> generateConstantData(double value) {
  final now = DateTime.now();
  return List.generate(1440, (index) {
    return ChartData(
      now.add(Duration(minutes: index)),
      value,
    );
  });
}
