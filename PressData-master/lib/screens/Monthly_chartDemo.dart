import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pressdata/screens/report_screenDemo.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class MonthlyChart extends StatefulWidget {
  final List<String> selectedValues;
  String month;

  MonthlyChart({super.key, required this.selectedValues, required this.month});
  @override
  State<MonthlyChart> createState() => _MonthlyChartState();
}

class _MonthlyChartState extends State<MonthlyChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Report Line Chart'),
      ),
      body: MonthlyChartScreen(
        selectedValues: widget.selectedValues,
        month: widget.month,
      ),
    );
  }
}

class MonthlyChartScreen extends StatefulWidget {
  final List<String> selectedValues;
  String month;
  MonthlyChartScreen(
      {super.key, required this.selectedValues, required this.month});

  @override
  _MonthlyChartScreenState createState() => _MonthlyChartScreenState();
}

class _MonthlyChartScreenState extends State<MonthlyChartScreen> {
  final GlobalKey chartKey = GlobalKey();
  bool _isLoading = false;
  TextEditingController _remarkController = TextEditingController();
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();
  DateTime date = DateTime.now();
  late final Uint8List pngBytes;
  void _showRemarkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Add Remark'),
            content: TextField(
              controller: _remarkController,
              decoration: InputDecoration(hintText: "Enter your remark here"),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  _captureAndShowImage(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _convertMonthToDateTime() {
    try {
      DateFormat dateFormat = DateFormat('MMMM yyyy');

      date = dateFormat.parse(widget.month);

      final start = _startOfMonth(date);
      final end = _endOfMonth(date);
      start_date = start;
      end_date = end;
      print("dvfbrfgedasfdghgj,hkjgfd->>$end_date");

      print('Selected Month DateTime: $date');
    } catch (e) {
      print('Error parsing date:$e');
    }
  }

  DateTime _startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  DateTime _endOfMonth(DateTime date) {
    final nextMonth = date.month == 12
        ? DateTime(date.year + 1, 1, 1)
        : DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(seconds: 1));
  }

  void generatePDF_Monthly() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final logoBytes = await rootBundle.load('assets/Wavevison-Logo.png');
    final logoImage = logoBytes.buffer.asUint8List();

    String hospitalCompany = prefs.getString('hospitalCompany') ?? '';

    final pdf = pw.Document();
    int totalDaysInMonth =
        DateTime(start_date.year, start_date.month + 1, 0).day;
    String remark = _remarkController.text;
    final titleStyle = pw.TextStyle(
      fontSize: 16,
      fontWeight: pw.FontWeight.bold,
    );

    final regularStyle = pw.TextStyle(
      fontSize: 10,
    );

    final footerStyle = pw.TextStyle(
      fontSize: 8,
    );

    final selectedGasesHeader = widget.selectedValues.join(', ');

    // Create a footer with page number and logo
    pw.Widget footer(int currentPage, int totalPages) {
      return pw.Column(
        children: [
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Page $currentPage of $totalPages', style: footerStyle),
              pw.Container(
                width: 50,
                height: 50,
                child: pw.Image(pw.MemoryImage(logoImage)),
              ),
              pw.Text(
                'Report generated from PressData® by wavevisions.in',
                style: footerStyle,
              ),
            ],
          ),
        ],
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(5),
        footer: (pw.Context context) =>
            footer(context.pageNumber, context.pagesCount),
        build: (pw.Context context) {
          List<pw.Widget> content = [];

          content.add(
            pw.Stack(children: [
              pw.Positioned.fill(
                child: pw.Column(children: [
                  pw.SizedBox(height: 300),
                  pw.Center(
                    child: pw.Transform.rotate(
                      angle: -0.5, // Adjust the angle as needed
                      child: pw.Opacity(
                        opacity: 0.1, // Adjust opacity
                        child: pw.Text(
                          'DEMO',
                          style: pw.TextStyle(
                            fontSize: 100,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              pw.Container(
                padding: pw.EdgeInsets.all(8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text('PressData® Report - $selectedGasesHeader',
                            style: titleStyle),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Divider(),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Hospital/Company: $hospitalCompany',
                            style: regularStyle),
                        pw.Text('Location: OT-2 WAVE ', style: regularStyle),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text('PressData unit Sr no:PDA082023424',
                            style: regularStyle),
                        pw.SizedBox(width: 330),
                        pw.Text('Total Days:$totalDaysInMonth'),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                            'Date: ${DateFormat.yMMMd().format(start_date)} to ${DateFormat.yMMMd().format(end_date)}',
                            style: regularStyle),
                        pw.Text(
                            'Report generation Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                            style: regularStyle),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Divider(),
                    pw.SizedBox(height: 8),
                    pw.Center(
                      child: pw.Text(
                          'Graph - Time (01 to $totalDaysInMonth) Vs $selectedGasesHeader Gas Values'),
                    ),
                    pw.Container(
                      height: 200,
                      child: pw.Image(pw.MemoryImage(pngBytes)),
                    ),
                    pw.SizedBox(height: 8),
                    pw.SizedBox(height: 8),
                    pw.Table.fromTextArray(
                      headers: [
                        'Parameters',
                        'Max',
                        'Min',
                        'Average',
                        'Max Time',
                        'Min Time'
                      ],
                      data:
                          List.generate(widget.selectedValues.length, (index) {
                        return [
                          widget.selectedValues[index],
                          maxPressure[index].toString(),
                          minPressure[index].toString(),
                          avgPressure[index].toString(),
                          maxPressureTime[index].toIso8601String(),
                          minPressureTime[index].toIso8601String(),
                        ];
                      }),
                      cellStyle: regularStyle,
                      headerStyle: titleStyle,
                      border: pw.TableBorder.all(color: PdfColors.black),
                      headerDecoration:
                          pw.BoxDecoration(color: PdfColors.grey300),
                      cellAlignment: pw.Alignment.centerLeft,
                    ),
                    pw.SizedBox(height: 22),
                    pw.Text('Alarm conditions:', style: regularStyle),
                  ],
                ),
              ),
            ]),
          );

          if (logs.isEmpty) {
            content.add(
              pw.Row(children: [
                pw.SizedBox(width: 150),
                pw.Text('No alarm detected today.', style: regularStyle),
              ]),
            );
          } else {
            // Calculate row height and available space
            final rowHeight = 14; // Adjust based on your row height
            final pageHeight =
                PdfPageFormat.a4.height - 100; // Margin and footer space
            final maxRowsPerPage = (pageHeight / rowHeight).floor();

            int start = 0;
            while (start < logs.length) {
              int end = (start + maxRowsPerPage > logs.length)
                  ? logs.length
                  : start + maxRowsPerPage;

              content.add(
                pw.Table.fromTextArray(
                  headers: [
                    'Parameters',
                    'Max Alarm',
                    'Min Alarm',
                    'Log',
                    'Time',
                  ],
                  data: List.generate(end - start, (index) {
                    int i = start + index;
                    return [
                      parameters_log[i],
                      maxvalue[i].toString(),
                      minvalue[i].toString(),
                      logs[i].toString(),
                      time[i].toIso8601String(),
                    ];
                  }),
                  cellStyle: regularStyle,
                  headerStyle: titleStyle,
                  border: pw.TableBorder.all(color: PdfColors.black),
                  headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
              );

              start = end;

              // Add a new page if more data is left
              if (start < logs.length) {
                pdf.addPage(
                  pw.Page(
                    pageFormat: PdfPageFormat.a4,
                    build: (pw.Context context) => pw.Center(
                      child: pw.Text(
                          'Page ${context.pageNumber} of ${context.pagesCount}'),
                    ),
                  ),
                );
              }
            }
          }

          content.add(
            pw.SizedBox(height: 22),
          );
          content.add(
            pw.Text('Remarks:', style: regularStyle),
          );
          content.add(
            pw.SizedBox(height: 8),
          );
          content.add(
            pw.Text('$remark', style: regularStyle),
          );
          content.add(
            pw.SizedBox(height: 8),
          );
          content.add(
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.SizedBox(width: 300),
                pw.Text('Sign:', style: regularStyle),
                pw.SizedBox(width: 150), // Adjust the width as necessary
              ],
            ),
          );

          return content;
        },
      ),
    );

    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/MonthlyDemo.pdf';
    final file = File(filePath);

    final pdfBytes = await pdf.save();
    await file.writeAsBytes(pdfBytes);
    OpenFile.open(filePath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to $filePath')),
    );
    // _clearSelectedData();
  }

  List<int> maxPressure = [30, 34, 45, 56, 78, 30, 23, 44];
  List<DateTime> maxPressureTime = [
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
  ];
  List<int> minPressure = [10, 12, 34, 45, 67, 34, 23, 10];
  List<DateTime> minPressureTime = [
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
  ];
  List<int> avgPressure = [23, 45, 56, 67, 78, 89, 23, 14];
  List<int> minvalue = [20, 30, 20, 30, 20, 30, 20, 30];
  List<DateTime> time = [
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
  ];
  List<int> maxvalue = [20, 30, 50, 60, 70, 80, 90];
  List<String> logs = ['LOW', 'HIGH', 'LOW', 'NOT AVAILABLE'];
  List<String> parameters_log = ['O2(1)', 'N2O', 'AIR', 'HUMI'];

  void initState() {
    super.initState();
    _convertMonthToDateTime();
  }

  @override
  Widget build(BuildContext context) {
    final data = generateMonthlyRandomData();
    final datao21 = generateMonthlyConstantData(10);
    final datatemp = generateMonthlyConstantData(60);
    final datahumi = generateMonthlyConstantData(70);
    final datao22 = generateMonthlyConstantData(50);
    final dataco2 = generateMonthlyConstantData(40);
    final datavac = generateMonthlyConstantData(30);
    final datan2o = generateMonthlyConstantData(20);
    final dataair = generateMonthlyConstantData(80);
    final minData = generateMonthlyConstantData(47);
    final maxData = generateMonthlyConstantData(60);
    List<CartesianSeries> seriesList = [];
    print("qwefrtgvefbgrgve${widget.selectedValues}");
    print("wefgrgvqwernhtge${widget.selectedValues}");
    // Add selected value series
    print(widget.selectedValues.length);
    if (widget.selectedValues.length > 1) {
      if (widget.selectedValues.contains('O2(1)')) {
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: datao21,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: ui.Color.fromARGB(255, 188, 225, 255),
          name: 'O2(1)',
        ));
      }
      if (widget.selectedValues.contains('VAC')) {
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: datavac,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.yellow,
          name: 'VAC',
        ));
      }
      if (widget.selectedValues.contains('CO2')) {
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: dataco2,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: ui.Color.fromARGB(255, 110, 113, 116),
          name: 'CO2',
        ));
      }
      if (widget.selectedValues.contains('O2(2)')) {
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: datao22,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: ui.Color.fromARGB(255, 132, 200, 255),
          name: 'O2(2)',
        ));
      }
      if (widget.selectedValues.contains('TEMP')) {
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: datatemp,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: ui.Color.fromARGB(255, 255, 0, 0),
          name: 'TEMP',
        ));
      }
      if (widget.selectedValues.contains('HUMI')) {
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: datahumi,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: ui.Color.fromARGB(117, 93, 172, 240),
          name: 'HUMI',
        ));
      }
      if (widget.selectedValues.contains('N2O')) {
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: datan2o,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: ui.Color.fromARGB(255, 0, 34, 255),
          name: 'N2O',
        ));
      }
      if (widget.selectedValues.contains('AIR')) {
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: dataair,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: const ui.Color.fromARGB(255, 101, 101, 102),
          name: 'AIR',
        ));
      }
    }
    // Add min and max lines if only one value is selected
    if (widget.selectedValues.length == 1) {
      seriesList.add(LineSeries<ChartData, DateTime>(
        dataSource: minData,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
        color: Colors.yellow,
        name: 'Min',
      ));
      seriesList.add(LineSeries<ChartData, DateTime>(
        dataSource: data,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
        color: Colors.black,
        name: 'Actual Value',
      ));
      seriesList.add(LineSeries<ChartData, DateTime>(
        dataSource: maxData,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
        color: Colors.red,
        name: 'Max',
      ));
    }
    return Column(
      children: [
        Expanded(
          child: RepaintBoundary(
            key: chartKey,
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                intervalType: DateTimeIntervalType.days,
                dateFormat: DateFormat.d(), // Day format (1, 2, 3, etc.)
                interval: 1, // Show every day of the month
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 100,
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              legend: Legend(toggleSeriesVisibility: false, isVisible: true),
              series: seriesList,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              _showRemarkDialog();
            },
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Report'),
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
      pngBytes = byteData!.buffer.asUint8List();

      // Pop MonthlyChart page
      generatePDF_Monthly();
      // Navigator.pop(context, pngBytes);
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

List<ChartData> generateMonthlyRandomData() {
  final random = Random();
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  return List.generate(daysInMonth, (index) {
    return ChartData(
      startOfMonth.add(Duration(days: index)),
      50 + random.nextDouble() * 3, // Random value between 50 and 53
    );
  });
}

List<ChartData> generateMonthlyConstantData(double value) {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  return List.generate(daysInMonth, (index) {
    return ChartData(
      startOfMonth.add(Duration(days: index)),
      value,
    );
  });
}
