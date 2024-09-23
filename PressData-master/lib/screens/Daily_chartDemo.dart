import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class DailyChartDemo extends StatefulWidget {
  List<String>? selectedValues;
  DateTime? selectedDate;

  DailyChartDemo({super.key, this.selectedValues, this.selectedDate});
  @override
  State<DailyChartDemo> createState() => _DailyChartDemoState();
}

class _DailyChartDemoState extends State<DailyChartDemo> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    print("dfvrhbtrgbthbth${widget.selectedDate}");
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Report Line Chart'),
      ),
      body: DailyChartGenearator(
        selectedValues: widget.selectedValues!,
        selectedDate: widget.selectedDate,
      ),
    );
  }
}

class DailyChartGenearator extends StatefulWidget {
  DateTime? selectedDate;
  List<String> selectedValues;
  DailyChartGenearator(
      {super.key, required this.selectedValues, this.selectedDate});

  @override
  _DailyChartScreenState createState() => _DailyChartScreenState();
}

class _DailyChartScreenState extends State<DailyChartGenearator> {
  DateTime? selectedDate;
  final GlobalKey chartKey = GlobalKey();
  bool _isLoading = false;
  late final Uint8List pngBytes;
  TextEditingController _remarkController = TextEditingController();
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
                  final value = 1;
                  Navigator.pop(context, value);
                },
              ),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  if (widget.selectedDate != null) {
                    // _zoomPanBehavior.reset();
                    _captureAndShowImage(context);
                    // Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _clearSelectedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      widget.selectedDate = null;
    });
  }

  final dateFormatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  void generatePDF_Daily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final logoBytes = await rootBundle.load('assets/Wavevison-Logo.png');
    final logoImage = logoBytes.buffer.asUint8List();
    String hospitalCompany = prefs.getString('hospitalCompany') ?? '';

    final pdf = pw.Document();

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
                        pw.RichText(
                          text: pw.TextSpan(
                            text: 'Press', // Text before "Data"
                            style: titleStyle, // Your predefined title style
                            children: [
                              pw.TextSpan(
                                text:
                                    'Data', // Main text with the registered symbol
                                style: titleStyle,
                                children: [
                                  pw.WidgetSpan(
                                    child: pw.Transform(
                                      transform: Matrix4.translationValues(2, 4,
                                          0), // Correctly position the symbol above "Data"
                                      child: pw.Text(
                                        '®',
                                        style: titleStyle.copyWith(
                                            fontSize:
                                                10), // Adjust font size for the trademark symbol
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.TextSpan(
                                text:
                                    ' Report - $selectedGasesHeader', // Continuation of the text after "Data"
                                style: titleStyle,
                              ),
                            ],
                          ),
                        ),
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
                        pw.Text('Location: OT-2 Wave ', style: regularStyle),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text('PressData unit Sr no: PDA08240102',
                            style: regularStyle),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                            'Date: ${DateFormat('dd-MM-yyyy').format(widget.selectedDate!)}',
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
                          'Graph - Time (HH 00 to 24) Vs $selectedGasesHeader Gas Values'),
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
                          dateFormatter.format(
                              maxPressureTime[index]), // Formatted max time
                          dateFormatter.format(minPressureTime[index]),
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

          if (true) {
            content.add(
              pw.Row(children: [
                pw.SizedBox(width: 150),
                pw.Text('No alarm detected today.', style: regularStyle),
              ]),
            );
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
    final filePath = '${directory!.path}/DailyDemo.pdf';
    final file = File(filePath);

    final pdfBytes = await pdf.save();
    await file.writeAsBytes(pdfBytes);
    OpenFile.open(filePath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to $filePath')),
    );
    //   _clearSelectedData();
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
  @override
  Widget build(BuildContext context) {
    final data = generateDailyRandomData();
    final datao21 = generateDailyConstantData(10);
    final datatemp = generateDailyConstantData(60);
    final datahumi = generateDailyConstantData(70);
    final datao22 = generateDailyConstantData(50);
    final dataco2 = generateDailyConstantData(40);
    final datavac = generateDailyConstantData(30);
    final datan2o = generateDailyConstantData(20);
    final dataair = generateDailyConstantData(80);
    final minData = generateDailyConstantData(47);
    final maxData = generateDailyConstantData(60);
    List<CartesianSeries> seriesList = [];
    print("qwefrtgvefbgrgve${widget.selectedValues}");
    print("wefgrgvqwernhtge${widget.selectedDate}");
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
                  minimum: DateTime(
                      widget.selectedDate!.year,
                      widget.selectedDate!.month,
                      widget.selectedDate!.day,
                      0,
                      0),
                  maximum: DateTime(
                      widget.selectedDate!.year,
                      widget.selectedDate!.month,
                      widget.selectedDate!.day,
                      23,
                      59),
                  interval: 3,
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 100,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                legend: Legend(toggleSeriesVisibility: false, isVisible: true),
                series: seriesList),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              // _captureAndShowImage(context);
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

      Navigator.of(context).pop();
      generatePDF_Daily();
      // Pop WeeklyChart page
      //  _showRemarkDialog();
      // Navigator.pop(context, pngBytes);
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => ReportScreen(
      //       imageBytes: pngBytes,
      //     ),
      //   ),
      // );
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

List<ChartData> generateDailyRandomData() {
  final random = Random();
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  return List.generate(60 * 24, (index) {
    return ChartData(
      startOfWeek.add(Duration(hours: index)),
      50 + random.nextDouble() * 3, // Random value between 50 and 53
    );
  });
}

List<ChartData> generateDailyConstantData(double value) {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  return List.generate(60 * 24, (index) {
    return ChartData(
      startOfWeek.add(Duration(hours: index)),
      value,
    );
  });
}
