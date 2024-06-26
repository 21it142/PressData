import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pressdata/screens/Daily_chart.dart';
import 'package:pressdata/screens/Monthly_chart.dart';
import 'package:pressdata/screens/Weekly_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportScreen extends StatefulWidget {
  final Uint8List? imageBytes;
  const ReportScreen({
    super.key,
    this.imageBytes,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime? _selectedDailyDate;
  DateTimeRange? _selectedWeeklyDateRange;
  String? _selectedMonthlyDate;
  TextEditingController _remarkController = TextEditingController();
  List<String> _selectedItems = [];
  String? selectedOption;
  void _showRemarkDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                if (_selectedDailyDate != null) {
                  Navigator.of(context).pop();
                  generatePDF_Daily();
                } else if (_selectedWeeklyDateRange != null) {
                  Navigator.of(context).pop();
                  generatePDF_Weekly();
                } else if (_selectedMonthlyDate != null) {
                  Navigator.of(context).pop();
                  generatePDF_Monthly();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void generatePDF_Daily() async {
    final pdf = pw.Document();
    String remark = _remarkController.text;
    final titleStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );

    final regularStyle = pw.TextStyle(
      fontSize: 12,
    );

    final selectedGasesHeader = _selectedItems.join(', ');

    // String dynamicHeading;
    // if (selectedOption == 'Daily' && _selectedDailyDate != null) {
    //   dynamicHeading =
    //       'Daily Report for ${DateFormat.yMMMd().format(_selectedDailyDate!)}';
    // } else if (selectedOption == 'Weekly' && _selectedWeeklyDateRange != null) {
    //   dynamicHeading =
    //       'Weekly Report from ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.start)} to ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.end)}';
    // } else if (selectedOption == 'Monthly' && _selectedMonthlyDate != null) {
    //   dynamicHeading = 'Monthly Report for $_selectedMonthlyDate';
    // } else {
    //   dynamicHeading = 'Report';
    // }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            margin: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            padding: pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Header(
                      child: pw.Text('PressData® Report - $selectedGasesHeader',
                          style: titleStyle),
                    ),
                  ],
                ),
                //pw.Divider(),
                pw.SizedBox(height: 8),
                // pw.Text(dynamicHeading, style: pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 8),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text('Hospital name: General Hospital, Vadodara',
                            style: regularStyle),
                        pw.SizedBox(width: 16),
                        pw.Text('Location: OT-2 (Neuro)', style: regularStyle),
                      ],
                    ),
                    pw.Text('PressData unit Sr no: PDA12345678',
                        style: regularStyle),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  children: [
                    pw.Text(
                        'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                        style: regularStyle),
                    pw.SizedBox(width: 130),
                    pw.Text(
                        'Report generation Date: ${DateFormat('dd-MM-yyyy, HH:mm').format(DateTime.now())}',
                        style: regularStyle),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text(
                      'Graph - Time (HH 00 to 24) Vs $selectedGasesHeader Gas Values'),
                ),
                pw.Container(
                  height: 200,
                  child: widget.imageBytes != null
                      ? pw.Image(pw.MemoryImage(widget.imageBytes!))
                      : pw.Center(child: pw.Text('Graph Placeholder')),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Max Pressure: 79 PSI', style: regularStyle),
                        pw.Text('Min Pressure: 42 PSI', style: regularStyle),
                        pw.Text('Average Pressure: 56 PSI',
                            style: regularStyle),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Max Pressure Time: 14:09',
                            style: regularStyle),
                        pw.Text('Min Pressure Time: 22:32',
                            style: regularStyle),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 22),
                pw.Text('Alarm conditions:', style: regularStyle),
                pw.Row(children: [
                  pw.SizedBox(width: 150),
                  pw.Text('No alarm detected today.', style: regularStyle),
                ]),
                pw.SizedBox(height: 49),
                pw.Divider(),
                pw.Text('Remarks:', style: regularStyle),
                pw.Text('$remark', style: regularStyle),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Sign:', style: regularStyle),
                  ],
                ),
                pw.SizedBox(height: 45),
                pw.Divider(),
                pw.Footer(
                  title: pw.Text(
                      'Report generated from PressData® by wavevisions.in',
                      style: regularStyle),
                ),
              ],
            ),
          );
        },
      ),
    );

    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/example.pdf';
    final file = File(filePath);

    final pdfBytes = await pdf.save();
    await file.writeAsBytes(pdfBytes);
    OpenFile.open(filePath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to $filePath')),
    );
    _clearSelectedData();
  }

  void generatePDF_Weekly() async {
    final pdf = pw.Document();
    String remark = _remarkController.text;
    final titleStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );

    final regularStyle = pw.TextStyle(
      fontSize: 12,
    );

    final selectedGasesHeader = _selectedItems.join(', ');

    // String dynamicHeading;
    // if (selectedOption == 'Daily' && _selectedDailyDate != null) {
    //   dynamicHeading =
    //       'Daily Report for ${DateFormat.yMMMd().format(_selectedDailyDate!)}';
    // } else if (selectedOption == 'Weekly' && _selectedWeeklyDateRange != null) {
    //   dynamicHeading =
    //       'Weekly Report from ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.start)} to ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.end)}';
    // } else if (selectedOption == 'Monthly' && _selectedMonthlyDate != null) {
    //   dynamicHeading = 'Monthly Report for $_selectedMonthlyDate';
    // } else {
    //   dynamicHeading = 'Report';
    // }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            margin: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            padding: pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Header(
                      child: pw.Text('PressData® Report - $selectedGasesHeader',
                          style: titleStyle),
                    ),
                  ],
                ),
                //pw.Divider(),
                pw.SizedBox(height: 8),
                // pw.Text(dynamicHeading, style: pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 8),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text('Hospital name: General Hospital, Vadodara',
                            style: regularStyle),
                        pw.SizedBox(width: 16),
                        pw.Text('Location: OT-2 (Neuro)', style: regularStyle),
                      ],
                    ),
                    pw.Text('PressData unit Sr no: PDA12345678',
                        style: regularStyle),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  children: [
                    pw.Text(
                        'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                        style: regularStyle),
                    pw.SizedBox(width: 130),
                    pw.Text(
                        'Report generation Date: ${DateFormat('dd-MM-yyyy, HH:mm').format(DateTime.now())}',
                        style: regularStyle),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text(
                      'Graph - Day (Mon to Sun) Vs $selectedGasesHeader Gas Values'),
                ),
                pw.Container(
                  height: 200,
                  child: widget.imageBytes != null
                      ? pw.Image(pw.MemoryImage(widget.imageBytes!))
                      : pw.Center(child: pw.Text('Graph Placeholder')),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Max Pressure: 79 PSI', style: regularStyle),
                        pw.Text('Min Pressure: 42 PSI', style: regularStyle),
                        pw.Text('Average Pressure: 56 PSI',
                            style: regularStyle),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Max Pressure Time: 14:09',
                            style: regularStyle),
                        pw.Text('Min Pressure Time: 22:32',
                            style: regularStyle),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 22),
                pw.Text('Alarm conditions:', style: regularStyle),
                pw.Row(children: [
                  pw.SizedBox(width: 150),
                  pw.Text('No alarm detected today.', style: regularStyle),
                ]),
                pw.SizedBox(height: 49),
                pw.Divider(),
                pw.Text('Remarks:', style: regularStyle),
                pw.Text('$remark', style: regularStyle),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Sign:', style: regularStyle),
                  ],
                ),
                pw.SizedBox(height: 45),
                pw.Divider(),
                pw.Footer(
                  title: pw.Text(
                      'Report generated from PressData® by wavevisions.in',
                      style: regularStyle),
                ),
              ],
            ),
          );
        },
      ),
    );

    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/example.pdf';
    final file = File(filePath);

    final pdfBytes = await pdf.save();
    await file.writeAsBytes(pdfBytes);
    OpenFile.open(filePath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to $filePath')),
    );
    _clearSelectedData();
  }

  void generatePDF_Monthly() async {
    final pdf = pw.Document();
    String remark = _remarkController.text;
    final titleStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );

    final regularStyle = pw.TextStyle(
      fontSize: 12,
    );

    final selectedGasesHeader = _selectedItems.join(', ');

    // String dynamicHeading;
    // if (selectedOption == 'Daily' && _selectedDailyDate != null) {
    //   dynamicHeading =
    //       'Daily Report for ${DateFormat.yMMMd().format(_selectedDailyDate!)}';
    // } else if (selectedOption == 'Weekly' && _selectedWeeklyDateRange != null) {
    //   dynamicHeading =
    //       'Weekly Report from ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.start)} to ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.end)}';
    // } else if (selectedOption == 'Monthly' && _selectedMonthlyDate != null) {
    //   dynamicHeading = 'Monthly Report for $_selectedMonthlyDate';
    // } else {
    //   dynamicHeading = 'Report';
    // }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            margin: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            padding: pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Header(
                      child: pw.Text('PressData® Report - $selectedGasesHeader',
                          style: titleStyle),
                    ),
                  ],
                ),
                //pw.Divider(),
                pw.SizedBox(height: 8),
                // pw.Text(dynamicHeading, style: pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 8),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text('Hospital name: General Hospital, Vadodara',
                            style: regularStyle),
                        pw.SizedBox(width: 16),
                        pw.Text('Location: OT-2 (Neuro)', style: regularStyle),
                      ],
                    ),
                    pw.Text('PressData unit Sr no: PDA12345678',
                        style: regularStyle),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  children: [
                    pw.Text(
                        'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                        style: regularStyle),
                    pw.SizedBox(width: 130),
                    pw.Text(
                        'Report generation Date: ${DateFormat('dd-MM-yyyy, HH:mm').format(DateTime.now())}',
                        style: regularStyle),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Text(
                      'Graph - Date ( 1 to 30 ) Vs $selectedGasesHeader Gas Values'),
                ),
                pw.Container(
                  height: 200,
                  child: widget.imageBytes != null
                      ? pw.Image(pw.MemoryImage(widget.imageBytes!))
                      : pw.Center(child: pw.Text('Graph Placeholder')),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Max Pressure: 79 PSI', style: regularStyle),
                        pw.Text('Min Pressure: 42 PSI', style: regularStyle),
                        pw.Text('Average Pressure: 56 PSI',
                            style: regularStyle),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Max Pressure Time: 14:09',
                            style: regularStyle),
                        pw.Text('Min Pressure Time: 22:32',
                            style: regularStyle),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 22),
                pw.Text('Alarm conditions:', style: regularStyle),
                pw.Row(children: [
                  pw.SizedBox(width: 150),
                  pw.Text('No alarm detected today.', style: regularStyle),
                ]),
                pw.SizedBox(height: 49),
                pw.Divider(),
                pw.Text('Remarks:', style: regularStyle),
                pw.Text('$remark', style: regularStyle),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Sign:', style: regularStyle),
                  ],
                ),
                pw.SizedBox(height: 45),
                pw.Divider(),
                pw.Footer(
                  title: pw.Text(
                      'Report generated from PressData® by wavevisions.in',
                      style: regularStyle),
                ),
              ],
            ),
          );
        },
      ),
    );

    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/example.pdf';
    final file = File(filePath);

    final pdfBytes = await pdf.save();
    await file.writeAsBytes(pdfBytes);
    OpenFile.open(filePath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to $filePath')),
    );
    _clearSelectedData();
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedData();
  }

  void _toggleItemSelection(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
    _saveSelectedData();
  }

  void _selectDate(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 90)),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      setState(() {
        _selectedDailyDate = selected;
        selectedOption = 'Daily';
        _selectedWeeklyDateRange = null;
        _selectedMonthlyDate = null;
      });
      _saveSelectedData();

      // Navigate to DailyCart page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DailyChart(
                  selectedValues: _selectedItems,
                )),
      );
    }
  }

  void _selectDateRange(BuildContext context) async {
    DateTimeRange? selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 90)),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      setState(() {
        _selectedWeeklyDateRange = selected;
        selectedOption = 'Weekly';
        _selectedDailyDate = null;
        _selectedMonthlyDate = null;
      });
      _saveSelectedData();

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WeeklyChart(
                  selectedValues: _selectedItems,
                )),
      );
    }
  }

  void _selectMonth(BuildContext context) async {
    final List<String> months = List.generate(4, (index) {
      final date = DateTime.now().subtract(Duration(days: 30 * index));
      return DateFormat('MMMM yyyy').format(date);
    });

    final String? selected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Month'),
          children: months.map((String month) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, month);
              },
              child: Text(month),
            );
          }).toList(),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedMonthlyDate = selected;
        selectedOption = 'Monthly';
        _selectedDailyDate = null;
        _selectedWeeklyDateRange = null;
      });
      _saveSelectedData();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MonthlyChart(
                  selectedValues: _selectedItems,
                )),
      );
    }
  }

  Future<void> _saveSelectedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_selectedDailyDate != null) {
      prefs.setString(
          'selectedDailyDate', _selectedDailyDate!.toIso8601String());
    } else {
      prefs.remove('selectedDailyDate');
    }

    if (_selectedWeeklyDateRange != null) {
      prefs.setString('selectedWeeklyDateRangeStart',
          _selectedWeeklyDateRange!.start.toIso8601String());
      prefs.setString('selectedWeeklyDateRangeEnd',
          _selectedWeeklyDateRange!.end.toIso8601String());
    } else {
      prefs.remove('selectedWeeklyDateRangeStart');
      prefs.remove('selectedWeeklyDateRangeEnd');
    }

    if (_selectedMonthlyDate != null) {
      prefs.setString('selectedMonthlyDate', _selectedMonthlyDate!);
    } else {
      prefs.remove('selectedMonthlyDate');
    }

    prefs.setStringList('selectedItems', _selectedItems);
    prefs.setString('selectedOption', selectedOption ?? '');
  }

  Future<void> _loadSelectedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? dailyDateString = prefs.getString('selectedDailyDate');
    if (dailyDateString != null) {
      setState(() {
        _selectedDailyDate = DateTime.parse(dailyDateString);
      });
    }

    String? weeklyStartString = prefs.getString('selectedWeeklyDateRangeStart');
    String? weeklyEndString = prefs.getString('selectedWeeklyDateRangeEnd');
    if (weeklyStartString != null && weeklyEndString != null) {
      setState(() {
        _selectedWeeklyDateRange = DateTimeRange(
          start: DateTime.parse(weeklyStartString),
          end: DateTime.parse(weeklyEndString),
        );
      });
    }

    String? monthlyDateString = prefs.getString('selectedMonthlyDate');
    if (monthlyDateString != null) {
      setState(() {
        _selectedMonthlyDate = monthlyDateString;
      });
    }

    List<String>? selectedItems = prefs.getStringList('selectedItems');
    if (selectedItems != null) {
      setState(() {
        _selectedItems = selectedItems;
      });
    }

    String? option = prefs.getString('selectedOption');
    if (option != null) {
      setState(() {
        selectedOption = option;
      });
    }
  }

  Future<void> _clearSelectedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      _selectedDailyDate = null;
      _selectedWeeklyDateRange = null;
      _selectedMonthlyDate = null;
      _selectedItems = [];
      selectedOption = null;
    });
  }

  Widget build(BuildContext context) {
    final List<String> items = [
      'O2(1)',
      'VAC',
      'N2O',
      'AIR',
      'CO2',
      'O2(2)',
      'TEMP',
      'HUMI'
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 145, 248, 248),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined)),
        title: Center(
          child: Text(
            "Report",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 145, 248, 248),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 4.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              spacing: 4.0, // Horizontal space between buttons
              runSpacing: 4.0, // Vertical space between button rows
              children: items.map((item) {
                final isSelected = _selectedItems.contains(item);
                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 60) /
                      4, // Ensure 8 buttons fit
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      backgroundColor: isSelected ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => _toggleItemSelection(item),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (_) => _toggleItemSelection(item),
                        ),
                        Text(
                          item,
                          style: TextStyle(
                            fontSize: 10, // Reduced font size
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const Divider(
              height: 10,
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedOption == 'Daily'
                            ? Colors.green
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () => _selectDate(context),
                      child: Text('Daily'),
                    ),
                    if (_selectedDailyDate != null)
                      Text(
                        'Selected Date: ${DateFormat.yMMMd().format(_selectedDailyDate!)}',
                        style: TextStyle(color: Colors.black),
                      ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedOption == 'Weekly'
                            ? Colors.green
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () => _selectDateRange(context),
                      child: Text(
                        'Weekly',
                      ),
                    ),
                    if (_selectedWeeklyDateRange != null)
                      Text(
                        'Selected Date Range: ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.start)} - ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.end)}',
                        style: TextStyle(color: Colors.black),
                      ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedOption == 'Monthly'
                            ? Colors.green
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () => _selectMonth(context),
                      child: Text('Monthly'),
                    ),
                    if (_selectedMonthlyDate != null)
                      Text(
                        'Selected Month: $_selectedMonthlyDate',
                        style: TextStyle(color: Colors.black),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (_selectedItems.isNotEmpty && (_selectedDailyDate != null))
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black),
                  ),
                  minimumSize: Size(200, 40), // Set the button size
                ),
                onPressed: _showRemarkDialog,
                child: Text(
                  "Generate Daily Report",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            if (_selectedItems.isNotEmpty && _selectedWeeklyDateRange != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black),
                  ),
                  minimumSize: Size(200, 40), // Set the button size
                ),
                onPressed: _showRemarkDialog,
                child: Text(
                  "Generate Weekly Report",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            if (_selectedItems.isNotEmpty && _selectedMonthlyDate != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black),
                  ),
                  minimumSize: Size(200, 40), // Set the button size
                ),
                onPressed: _showRemarkDialog,
                child: Text(
                  "Generate Monthly Report",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
