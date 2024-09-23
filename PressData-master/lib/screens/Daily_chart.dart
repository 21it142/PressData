import 'dart:async';
import 'dart:io';

// import 'package:url_launcher/url_launcher.dart';
//import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/cupertino.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pressdata/data/db.dart';

import 'package:pressdata/widgets/caculatepressure_minmax.dart';
import 'package:pressdata/widgets/getlogs.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

// Import your database file

class DailyChart extends StatefulWidget {
  final String serialNo;
  final String location;
  DateTime? selectedDailyDate;
  final List<String> selectedValues;

  DailyChart(
      {super.key,
      required this.location,
      required this.serialNo,
      required this.selectedValues,
      required this.selectedDailyDate});

  @override
  State<DailyChart> createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Report Line Chart'),
      ),
      body: LineChartScreen(
        selectedValues: widget.selectedValues,
        seletedDate: widget.selectedDailyDate,
        serial: widget.serialNo,
        locationname: widget.location,
      ),
    );
  }
}

class LineChartScreen extends StatefulWidget {
  final String serial;
  final String locationname;
  DateTime? seletedDate;
  final List<String> selectedValues;

  LineChartScreen(
      {super.key,
      required this.selectedValues,
      required this.seletedDate,
      required this.locationname,
      required this.serial});

  @override
  _LineChartScreenState createState() => _LineChartScreenState();
}

class _LineChartScreenState extends State<LineChartScreen> {
  bool _showButton = false;
  String Unitnumber = "";
  Uint8List pngBytes = Uint8List(0);
  TextEditingController _remarkController = TextEditingController();

  Future<void> _clearSelectedData() async {
    if (!mounted) return;
    setState(() {
      widget.seletedDate = null;
    });
  }

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
                  if (widget.seletedDate != null) {
                    _zoomPanBehavior.reset();
                    _captureAndShowImage(context);
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

  Future<bool> _requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.storage.request();
    }

    return status.isGranted;
  }

  final dateFormatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  void generatePDF_Daily() async {
    if (!mounted) return;
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

    String dynamicHeading;
    if (selectedOption == 'Daily' && widget.seletedDate != null) {
      dynamicHeading =
          'Daily Report for ${DateFormat.yMMMd().format(widget.seletedDate!)}';
    }

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

    // Header content
    pw.Widget headerContent() {
      return pw.Container(
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
                        text: 'Data', // Main text with the registered symbol
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
                pw.Text('Location: ${widget.locationname} ',
                    style: regularStyle),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text('PressData unit Sr no: ${widget.serial}',
                    style: regularStyle),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                    'Date: ${DateFormat('dd-MM-yyyy').format(widget.seletedDate!)}',
                    style: regularStyle),
                pw.Text(
                    'Report generation Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                    style: regularStyle),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Divider(),
            pw.SizedBox(height: 8),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(5),
        footer: (pw.Context context) =>
            footer(context.pageNumber, context.pagesCount),
        header: (pw.Context context) => headerContent(), // Set the header
        build: (pw.Context context) {
          List<pw.Widget> content = [];

          content.add(
            pw.Center(
              child: pw.Text(
                'Graph - Time (HH 00 to 24) Vs $selectedGasesHeader Gas Values',
              ),
            ),
          );

          content.add(
            pw.Container(
              height: 200,
              child: pw.Image(pw.MemoryImage(pngBytes)),
            ),
          );

          content.add(pw.SizedBox(height: 8));

          content.add(
            pw.Table.fromTextArray(
              headers: [
                'Parameters',
                'Max',
                'Min',
                'Average',
                'Max Time',
                'Min Time'
              ],
              data: List.generate(widget.selectedValues.length, (index) {
                return [
                  widget.selectedValues[index],
                  maxPressure[index].toString(),
                  minPressure[index].toString(),
                  avgPressure[index].toString(),
                  dateFormatter
                      .format(maxPressureTime[index]), // Formatted max time
                  dateFormatter.format(minPressureTime[index]),
                ];
              }),
              cellStyle: regularStyle,
              headerStyle: titleStyle,
              border: pw.TableBorder.all(color: PdfColors.black),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.centerLeft,
            ),
          );

          content.add(pw.SizedBox(height: 22));

          content.add(
            pw.Text('Alarm conditions:', style: regularStyle),
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
                    'Value',
                    'Max Value',
                    'Min Value',
                    'Log',
                    'Time',
                  ],
                  data: List.generate(end - start, (index) {
                    int i = start + index;
                    return [
                      parameters_log[i],
                      values_fetched[i].toString(),
                      maxvalue[i].toString(),
                      minvalue[i].toString(),
                      logs[i].toString(),
                      dateFormatter.format(Time[index]),
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

          content.add(pw.SizedBox(height: 22));
          content.add(pw.Text('Remarks:', style: regularStyle));
          content.add(pw.SizedBox(height: 8));
          content.add(pw.Text('$remark', style: regularStyle));
          content.add(pw.SizedBox(height: 8));
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
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    int sdkVersion = androidInfo.version.sdkInt;
    String versionRelease = androidInfo.version.release;

    print('Android SDK: $sdkVersion');
    print('Android Version: $versionRelease');
    print("Sdk version:$sdkVersion");
    if (sdkVersion <= 29) {
      if (await _requestStoragePermission()) {
        // Android 10 or below - permission granted, generate and save report
        final directory = Directory('/storage/emulated/0/Download');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        String timestamp =
            DateTime.now().toString().replaceAll(RegExp(r'[:.]'), '_');
        final filePath = '${directory.path}/ReportDaily_${timestamp}.pdf';
        final file = File(filePath);

        final pdfBytes =
            await pdf.save(); // Assuming you have the pdf data ready
        await file.writeAsBytes(pdfBytes);

        OpenFile.open(filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved to Downloads: $filePath')),
        );
      }
    } else if (sdkVersion > 29 || sdkVersion == 0) {
      print("Heloooooooooooooooooooooooooooooooo inside > 29 ");
      // Android 11 and above
      final documentsDirstore =
          Directory('/storage/emulated/0/Download/PressData/Daily');
      final documentsDir =
          await getExternalStorageDirectory(); // Get external storage directory
      if (!documentsDirstore.existsSync()) {
        documentsDirstore.createSync(
            recursive: true); // Create directory if it doesn't exist
      }

      String timestamp = DateFormat('yyyyMMdd_HHmmss')
          .format(DateTime.now()); // Format timestamp
      final pdfpath = '/ReportDaily_$timestamp.pdf';
      final filePath = '${documentsDir?.path}$pdfpath';
      final filepathStore = '${documentsDirstore.path}$pdfpath';

      final file =
          File(filePath); // Create file for the external storage directory
      final filestore =
          File(filepathStore); // Create file for the 'PressData' directory

      final pdfBytes = await pdf.save(); // Save PDF bytes
      await file.writeAsBytes(pdfBytes); // Write to external storage directory
      await filestore.writeAsBytes(pdfBytes); // Write to 'PressData' directory

      OpenFile.open(filePath); // Open the file

      _clearSelectedData(); // Clear any selected data after saving

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to $filePath')),
      );
    } else {
      // Permission denied - generate report but not save it
      final pdfBytes = await pdf.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Permission denied. Report generated but not saved.')),
      );
    }
    // final documentsDirstore =
    //     Directory('/storage/emulated/0/Download/PressData/Daily');
    // final documentsDir = await getExternalStorageDirectory();
    // if (!documentsDirstore.existsSync()) {
    //   documentsDirstore.createSync(recursive: true);
    // }
    // String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    // final pdfpath = '/ReportDaily${widget.serial}_$timestamp.pdf';
    // final filePath = '${documentsDir?.path}${pdfpath}';
    // final filepathStore = '${documentsDirstore.path}${pdfpath}';
    // final file = File(filePath);
    // final filestore = File(filepathStore);
    // final pdfBytes = await pdf.save();
    // await file.writeAsBytes(pdfBytes);
    // await filestore.writeAsBytes(pdfBytes);

    // OpenFile.open(filePath);

    // _clearSelectedData();
  }

  String? selectedOption;
  final GlobalKey chartKey = GlobalKey();
  bool _isLoading = false;
  List<CartesianSeries> seriesList = [];
  PressDataDb? db; // Define the database instance
  List<ChartData> chartData = [];
  List<MinData> mindata = [];
  List<MaxData> maxdata = [];
  DateTime today = DateTime.now();
  List<int> maxPressure = [];
  List<DateTime> maxPressureTime = [];
  List<int> minPressure = [];
  List<DateTime> minPressureTime = [];
  List<int> avgPressure = [];
  List<int> minvalue = [];
  List<DateTime> Time = [];
  List<int> maxvalue = [];
  List<int> values_fetched = [];
  List<String> parameters_log = [];
  List<String> logs = [];
  List<Prssurevalues> min_max_avg = [];
  int androidVersion = 0;
  int sdkVersion = 0;
  String versionRelease = "";

  @override
  void initState() {
    super.initState();
    _startTimer();
    _zoomPanBehavior = ZoomPanBehavior(
        enablePanning: true,
        enableDoubleTapZooming: true,
        enablePinching: true);

    db = PressDataDb(); // Initialize your database here
    fetchData(widget.seletedDate!);
  }

  bool isDataAvailable = true;
  Future<void> fetchData(DateTime date) async {
    List<PressDataTableData> data =
        await db!.getDataForDay(date, widget.serial);
    print("heloooo->>>>>before log");
    List<ErrorTableData> error_data =
        await db!.getErrorDataForDay(date, widget.serial);
    print(error_data);
    print("heloooo->>>>>After");
    if (data.isEmpty) {
      setState(() {
        isDataAvailable = false;
      });
      print("No data available for the selected date.");
      return;
    }

    setState(() {
      isDataAvailable = true;
    });

    print("Fetched Data Daily Graph: $data");
    print("Data Length: ${data.length}");

    if (widget.selectedValues.length == 1) {
      // Single parameter report
      final selectedParameter = widget.selectedValues.first;
      _updateSingleParameterData(data, selectedParameter, error_data);
    } else if (widget.selectedValues.length == 8) {
      // All parameters report
      _updateAllParametersData(data, error_data);
    } else {
      // Handle other cases if necessary
    }
  }

  void _updateSingleParameterData(List<PressDataTableData> data,
      String parameter, List<ErrorTableData> error_data) {
    setState(() {
      chartData = [];

      switch (parameter) {
        case 'O2(1)':
          chartData = data
              .map((d) => ChartData(d.recordedAt!, d.o2.toDouble(), "O2(1)"))
              .toList();
          mindata = data
              .map((d) => MinData(
                    d.recordedAt!,
                    d.O2_1_min.toDouble(),
                  ))
              .toList();
          maxdata = data
              .map((d) => MaxData(d.recordedAt!, d.O2_1_max.toDouble()))
              .toList();
          break;
        case 'TEMP':
          chartData = data
              .map((d) =>
                  ChartData(d.recordedAt!, d.temperature.toDouble(), "TEMP"))
              .toList();
          mindata = data
              .map((d) => MinData(d.recordedAt!, d.Temp_min.toDouble()))
              .toList();
          maxdata = data
              .map((d) => MaxData(d.recordedAt!, d.Temp_max.toDouble()))
              .toList();
          break;
        case 'HUMI':
          chartData = data
              .map((d) =>
                  ChartData(d.recordedAt!, d.humidity.toDouble(), "HUMI"))
              .toList();
          mindata = data
              .map((d) => MinData(d.recordedAt!, d.Humi_min.toDouble()))
              .toList();
          maxdata = data
              .map((d) => MaxData(d.recordedAt!, d.Humi_max.toDouble()))
              .toList();
          break;
        case 'O2(2)':
          chartData = data
              .map((d) => ChartData(d.recordedAt!, d.o22.toDouble(), "O2(2)"))
              .toList();
          mindata = data
              .map((d) => MinData(d.recordedAt!, d.o2_2_min.toDouble()))
              .toList();
          maxdata = data
              .map((d) => MaxData(d.recordedAt!, d.o2_2_max.toDouble()))
              .toList();
          break;
        case 'N2O':
          chartData = data
              .map((d) => ChartData(d.recordedAt!, d.n2o.toDouble(), "N2O"))
              .toList();
          mindata = data
              .map((d) => MinData(d.recordedAt!, d.n2o_min.toDouble()))
              .toList();
          maxdata = data
              .map((d) => MaxData(d.recordedAt!, d.n2o_max.toDouble()))
              .toList();
          break;
        case 'AIR':
          chartData = data
              .map((d) =>
                  ChartData(d.recordedAt!, d.airPressure.toDouble(), "AIR"))
              .toList();
          mindata = data
              .map((d) => MinData(d.recordedAt!, d.air_min.toDouble()))
              .toList();
          maxdata = data
              .map((d) => MaxData(d.recordedAt!, d.air_max.toDouble()))
              .toList();
          break;
        case 'CO2':
          chartData = data
              .map((d) => ChartData(d.recordedAt!, d.co2.toDouble(), "CO2"))
              .toList();
          mindata = data
              .map((d) => MinData(d.recordedAt!, d.co2_min.toDouble()))
              .toList();
          maxdata = data
              .map((d) => MaxData(d.recordedAt!, d.co2_min.toDouble()))
              .toList();
          break;
        case 'VAC':
          chartData = data
              .map((d) => ChartData(d.recordedAt!, d.vac.toDouble(), "VAC"))
              .toList();
          mindata = data
              .map((d) => MinData(d.recordedAt!, d.vac_min.toDouble()))
              .toList();
          maxdata = data
              .map((d) => MaxData(d.recordedAt!, d.vac_max.toDouble()))
              .toList();
          break;
        default:
          chartData = [];
          mindata = [];
          maxdata = [];
      }

      seriesList = generateSeries(chartData, mindata, maxdata);

      PressureStats stats = calculatePressureStats(data, widget.selectedValues);
      maxPressure = stats.maxPressure;
      maxPressureTime = stats.maxPressureTime;
      minPressure = stats.minPressure;
      minPressureTime = stats.minPressureTime;
      avgPressure = stats.avgPressure;
      print("heloooo->>>>>before log");
      print("Get logs for temp: ${widget.selectedValues}");

      Logs stat = getlogs(error_data, widget.selectedValues);
      //print("logs temp : wrfwdbrgfvwe ${logs.first}");
      parameters_log = stat.parameter;
      maxvalue = stat.maxvalue;
      minvalue = stat.minvalue;
      values_fetched = stat.values;
      logs = stat.log;
      Time = stat.time;
      print("heloooooooooooo->>>>AFter log");
      // var pressurvalue = Prssurevalues(avgPressure, maxPressure,
      //     maxPressureTime, minPressure, maxPressureTime, parametername);
      // min_max_avg.add(pressurvalue);
      // print("Max Pressure: $maxPressure at $maxPressureTime");
      // print("Min Pressure: $minPressure at $minPressureTime");
      // print("Avg Pressure: $avgPressure");

      // inilay errors if needed
      //  displayErrors(data);
    });
  }

  void _updateAllParametersData(
      List<PressDataTableData> data, List<ErrorTableData> error_data) {
    setState(() {
      chartData = [];
      mindata = [];
      maxdata = [];

      List<ChartData> allChartData = [];

      // Iterate through each parameter and add the data
      var parameters = [
        'O2(1)',
        'TEMP',
        'HUMI',
        'O2(2)',
        'N2O',
        'AIR',
        'CO2',
        'VAC'
      ];
      for (var param in parameters) {
        List<ChartData> paramData;

        switch (param) {
          case 'O2(1)':
            paramData = data
                .map((d) => ChartData(d.recordedAt!, d.o2.toDouble(), "O2(1)"))
                .toList();
            break;
          case 'TEMP':
            paramData = data
                .map((d) =>
                    ChartData(d.recordedAt!, d.temperature.toDouble(), "TEMP"))
                .toList();
            break;
          case 'HUMI':
            paramData = data
                .map((d) =>
                    ChartData(d.recordedAt!, d.humidity.toDouble(), "HUMI"))
                .toList();
            break;
          case 'O2(2)':
            paramData = data
                .map((d) => ChartData(d.recordedAt!, d.o22.toDouble(), "O2(2)"))
                .toList();
            break;
          case 'N2O':
            paramData = data
                .map((d) => ChartData(d.recordedAt!, d.n2o.toDouble(), "N2O"))
                .toList();
            break;
          case 'AIR':
            paramData = data
                .map((d) =>
                    ChartData(d.recordedAt!, d.airPressure.toDouble(), "AIR"))
                .toList();
            break;
          case 'CO2':
            paramData = data
                .map((d) => ChartData(d.recordedAt!, d.co2.toDouble(), "CO2"))
                .toList();
            break;
          case 'VAC':
            paramData = data
                .map((d) => ChartData(d.recordedAt!, d.vac.toDouble(), "VAC"))
                .toList();
            break;
          default:
            paramData = [];
        }

        allChartData.addAll(paramData);
      }
      print("parameters$parameters");
      seriesList = generateSeries(allChartData, mindata, maxdata);
      PressureStats stats = calculatePressureStats(data, widget.selectedValues);
      maxPressure = stats.maxPressure;
      maxPressureTime = stats.maxPressureTime;
      minPressure = stats.minPressure;
      minPressureTime = stats.minPressureTime;
      avgPressure = stats.avgPressure;

      Logs stat = getlogs(error_data, widget.selectedValues);
      parameters_log = stat.parameter;
      maxvalue = stat.maxvalue;
      minvalue = stat.minvalue;
      values_fetched = stat.values;
      logs = stat.log;
      Time = stat.time;
      // calculatePressureStats(data, widget.selectedValues);
      // for (var stat in stats) {
      //   print(
      //       'Max Pressure: ${stat.maxPressure}, Time: ${stat.maxPressureTime}');
      //   print(
      //       'Min Pressure: ${stat.minPressure}, Time: ${stat.minPressureTime}');
      //   print('Average Pressure: ${stat.avgPressure}');

      //   // Assuming you have variables or methods to store/display these values,
      //   // you can assign them accordingly. For example:
      //   maxPressure = stat.maxPressure;
      //   maxPressureTime = stat.maxPressureTime;
      //   minPressure = stat.minPressure;
      //   minPressureTime = stat.minPressureTime;
      //   avgPressure = stat.avgPressure;

      //   // You can also consider storing them in a list if you need to keep track of all values
      //   // Example:
      //   maxPressures.add(stat.maxPressure);
      //   maxPressureTimes.add(stat.maxPressureTime);
      //   minPressures.add(stat.minPressure);
      //   minPressureTimes.add(stat.minPressureTime);
      //   avgPressures.add(stat.avgPressure);
      // }

      // Display errors if needed
      // displayErrors(data);
    });
  }

  // void displayErrors(List<PressDataTableData> data) {
  //   List<String> errors = [];

  //   for (var record in data) {
  //     if (record.temp_error != null) errors.add(record.temp_error);
  //     if (record.n2o_error != null) errors.add(record.n2o_error);
  //     if (record.humi_error != null) errors.add(record.humi_error);
  //     if (record.o2_1_error != null) errors.add(record.o2_1_error);
  //     if (record.co2_error != null) errors.add(record.co2_error);
  //     if (record.air_error != null) errors.add(record.air_error);
  //     if (record.o2_2_error != null) errors.add(record.o2_2_error);
  //     if (record.vac_error != null) errors.add(record.vac_error);
  //   }

  //   print("Errors: $errors");
  //   // You can update your UI here to display the errors
  // }

  List<CartesianSeries> generateSeries(
      List<ChartData> data, List<MinData> mindata, List<MaxData> maxdata) {
    List<CartesianSeries> seriesList = [];
    print(data);
    if (widget.selectedValues.length > 1) {
      if (widget.selectedValues.contains('O2(1)')) {
        var o2_1_data = data.where((d) => d.parameter == 'O2(1)').toList();
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: o2_1_data,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: const Color.fromARGB(
              255, 0, 0, 0), // Use distinct colors for each parameter
          name: 'O2(1)',
        ));
      }

      if (widget.selectedValues.contains('VAC')) {
        var vac_data = data.where((d) => d.parameter == 'VAC').toList();
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: vac_data,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: Colors.yellow, // Use distinct colors for each parameter
          name: 'VAC',
          yAxisName: 'hello123456789',
        ));
      }
      if (widget.selectedValues.contains('CO2')) {
        var co2_data = data.where((d) => d.parameter == 'CO2').toList();
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: co2_data,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: ui.Color.fromARGB(255, 110, 113, 116),
          name: 'CO2',
        ));
      }
      if (widget.selectedValues.contains('O2(2)')) {
        var o2_2_data = data.where((d) => d.parameter == 'O2(2)').toList();
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: o2_2_data,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: Color.fromARGB(255, 0, 0, 0),
          name: 'O2(2)',
        ));
      }
      if (widget.selectedValues.contains('TEMP')) {
        var temp_data = data.where((d) => d.parameter == 'TEMP').toList();
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: temp_data,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: ui.Color.fromARGB(255, 255, 0, 0),
          name: 'TEMP',
        ));
      }
      if (widget.selectedValues.contains('HUMI')) {
        var humi_data = data.where((d) => d.parameter == 'HUMI').toList();
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: humi_data,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: ui.Color.fromARGB(117, 93, 172, 240),
          name: 'HUMI',
        ));
      }
      if (widget.selectedValues.contains('N2O')) {
        var N2o_data = data.where((d) => d.parameter == 'N2O').toList();
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: N2o_data,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: ui.Color.fromARGB(255, 0, 34, 255),
          name: 'N2O',
        ));
      }
      if (widget.selectedValues.contains('AIR')) {
        var Air_data = data.where((d) => d.parameter == 'AIR').toList();
        seriesList.add(LineSeries<ChartData, DateTime>(
          dataSource: Air_data,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.value,
          color: const ui.Color.fromARGB(255, 101, 101, 102),
          name: 'AIR',
        ));
      }
    } else if (widget.selectedValues.length == 1) {
      seriesList.add(LineSeries<MinData, DateTime>(
        dataSource: mindata, // Replace with min data
        xValueMapper: (MinData data, _) => data.time,
        yValueMapper: (MinData data, _) => data.value,
        color: Colors.yellow,
        name: 'Min',
      ));
      seriesList.add(LineSeries<MaxData, DateTime>(
        dataSource: maxdata, // Replace with max data
        xValueMapper: (MaxData data, _) => data.time,
        yValueMapper: (MaxData data, _) => data.value,
        color: Colors.red,
        name: 'Max',
      ));
      seriesList.add(LineSeries<ChartData, DateTime>(
        dataSource: data,
        xValueMapper: (ChartData data, _) => data.time,
        yValueMapper: (ChartData data, _) => data.value,
        color: Colors.black,
        name: 'Actual Value',
      ));
    }

    return seriesList;
  }

  void _startTimer() async {
    Timer(Duration(seconds: 5), () {
      setState(() {
        _showButton = true;
      });
    });
  }

  late ZoomPanBehavior _zoomPanBehavior;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : isDataAvailable
              ? Column(
                  children: [
                    Expanded(
                      child: RepaintBoundary(
                          key: chartKey,
                          child: SfCartesianChart(
                            zoomPanBehavior: _zoomPanBehavior,
                            axes: <ChartAxis>[
                              NumericAxis(
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                name: 'hello123456789',
                                opposedPosition: false,
                                interval: 150,
                                minimum: 0,
                                maximum: 750,
                              ),
                            ],
                            primaryXAxis: DateTimeAxis(
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              minimum: DateTime(
                                widget.seletedDate!.year,
                                widget.seletedDate!.month,
                                widget.seletedDate!.day,
                                0,
                                0,
                              ),
                              maximum: DateTime(
                                widget.seletedDate!.year,
                                widget.seletedDate!.month,
                                widget.seletedDate!.day,
                                23,
                                59,
                              ),
                              interval: 3,
                              dateFormat: DateFormat.Hms(),
                            ),
                            primaryYAxis: NumericAxis(
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              minimum: 0,
                              maximum: 100,
                              interval: 20,
                            ),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            legend: Legend(
                              toggleSeriesVisibility: false,
                              isVisible: true,
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            series: seriesList,
                          )),
                    ),
                    if (_showButton == true)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _showRemarkDialog();
                            //  _captureAndShowImage(context);
                          },
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Report'),
                        ),
                      ),
                    if (_showButton == false)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            /// _showRemarkDialog();
                            //  _captureAndShowImage(context);
                          },
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Report',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 147, 147, 147)),
                                ),
                        ),
                      ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/NoData.png',
                        height: 300,
                      ), // Path to your image
                      SizedBox(height: 20),
                      Text(
                        'Data not found for the selected date.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
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
      generatePDF_Daily(); // Pop DailyChart page
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
  final String parameter;

  ChartData(this.time, this.value, this.parameter);
}

class Prssurevalues {
  final DateTime maxtime;
  final DateTime mintime;
  final int maxpressure;
  final int minpressure;
  final int averagepressure;
  final String parametername;
  Prssurevalues(this.averagepressure, this.maxpressure, this.maxtime,
      this.minpressure, this.mintime, this.parametername);
}

class MinData {
  final DateTime time;
  final double value;

  MinData(this.time, this.value);
}

class MaxData {
  final DateTime time;
  final double value;

  MaxData(this.time, this.value);
}

List<ChartData> generateConstantData(double value) {
  final now = DateTime.now();
  return List.generate(1440, (index) {
    return ChartData(now.add(Duration(minutes: index)), value, "");
  });
}

class NativeBridge {
  static const MethodChannel _channel =
      MethodChannel('com.example.pressdata/native');

  static Future<void> requestPermissions() async {
    await _channel.invokeMethod('requestPermissions');
  }

  static Future<void> generateAndSavePDF(
      String fileName, Uint8List pdfBytes) async {
    await _channel.invokeMethod('generateAndSavePDF', {
      'fileName': fileName,
      'pdfBytes': pdfBytes,
    });
  }
}
