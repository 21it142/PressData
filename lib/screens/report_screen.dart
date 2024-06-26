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

  List<String> _selectedItems = [];
  String? selectedOption;

  void generatePDF() async {
    final pdf = pw.Document();

    final titleStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );

    final regularStyle = pw.TextStyle(
      fontSize: 12,
    );

    final selectedGasesHeader = _selectedItems.join(', ');

    final dynamicHeading = selectedOption == 'Daily'
        ? 'Daily Report for ${DateFormat.yMMMd().format(_selectedDailyDate!)}'
        : selectedOption == 'Weekly'
            ? 'Weekly Report from ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.start)} to ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.end)}'
            : 'Monthly Report for $_selectedMonthlyDate';

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
                pw.Header(
                  child: pw.Text('PressData® Report - $selectedGasesHeader',
                      style: titleStyle),
                ),
                pw.SizedBox(height: 8),
                pw.Center(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black),
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                    child: pw.Text(dynamicHeading,
                        style: pw.TextStyle(fontSize: 20)),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Text('Hospital name: General Hospital, Vadodara',
                            style: regularStyle),
                        pw.SizedBox(width: 16),
                        pw.Text('PressData unit Sr no: PDA12345678',
                            style: regularStyle),
                      ],
                    ),
                    pw.Text('Location: OT-2 (Neuro)', style: regularStyle),
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
                      'Graph - Time (HH 00 to 24) Vs Selected Gas Values'),
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
                pw.Text('Two Laparoscopic Procedures carried out today',
                    style: regularStyle),
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
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDailyDate = prefs.getString('dailyDate') != null
          ? DateTime.parse(prefs.getString('dailyDate')!)
          : null;
      _selectedWeeklyDateRange = prefs.getString('weeklyStart') != null &&
              prefs.getString('weeklyEnd') != null
          ? DateTimeRange(
              start: DateTime.parse(prefs.getString('weeklyStart')!),
              end: DateTime.parse(prefs.getString('weeklyEnd')!))
          : null;
      _selectedMonthlyDate = prefs.getString('monthlyDate');
      _selectedItems = prefs.getStringList('selectedItems') ?? [];
      selectedOption = prefs.getString('selectedOption');
    });
  }

  void _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dailyDate', _selectedDailyDate?.toIso8601String() ?? '');
    prefs.setString(
        'weeklyStart', _selectedWeeklyDateRange?.start.toIso8601String() ?? '');
    prefs.setString(
        'weeklyEnd', _selectedWeeklyDateRange?.end.toIso8601String() ?? '');
    prefs.setString('monthlyDate', _selectedMonthlyDate ?? '');
    prefs.setStringList('selectedItems', _selectedItems);
    prefs.setString('selectedOption', selectedOption ?? '');
  }

  void _toggleItemSelection(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
    _savePreferences();
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
      _savePreferences();
      _navigateToDailyChart();
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
      _savePreferences();
      _navigateToDailyChart();
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
      _savePreferences();
      _navigateToDailyChart();
    }
  }

  void _navigateToDailyChart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DailyChart(),
      ),
    );
  }

  Widget build(BuildContext context) {
    final List<String> items = [
      'O2(1)',
      'VAC',
      'NO2',
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
            if (_selectedItems.isNotEmpty && _selectedDailyDate != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black),
                  ),
                  minimumSize: Size(200, 40), // Set the button size
                ),
                onPressed: () => (generatePDF()),
                child: Text(
                  "Generate Report",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            if (_selectedItems.isNotEmpty)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black),
                  ),
                  minimumSize: Size(200, 40), // Set the button size
                ),
                onPressed: () => (generatePDF()),
                child: Text(
                  "Generate Report",
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
