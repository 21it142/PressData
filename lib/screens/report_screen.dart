import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

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

    // Join selected items to display in the header
    final selectedGasesHeader = _selectedItems.join(', ');

    final dynamicHeading = selectedOption == 'Daily'
        ? 'Daily Report for ${DateFormat.yMMMd().format(_selectedDailyDate!)}'
        : selectedOption == 'Weekly'
            ? 'Weekly Report from ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.start)} to ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.end)}'
            : 'Monthly Report for $_selectedMonthlyDate';

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Header(
                  level: 1,
                  child: pw.Text('PressData® Report - $selectedGasesHeader',
                      style: titleStyle),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Hospital name: General Hospital, Vadodara',
                            style: regularStyle),
                        pw.Text('Location: OT-2 (Neuro)', style: regularStyle),
                      ],
                    ),
                    pw.Text('PressData unit Sr no: PDA12345678',
                        style: regularStyle),
                  ],
                ),
                pw.Divider(),
                pw.Text(
                    'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                    style: regularStyle),
                pw.SizedBox(height: 8),
                pw.Text(
                    'Report generation Date: ${DateFormat('dd-MM-yyyy, HH:mm').format(DateTime.now())}',
                    style: regularStyle),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Container(
                  padding: pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Text(dynamicHeading,
                      style: pw.TextStyle(fontSize: 20)),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Selected Gases:', style: pw.TextStyle(fontSize: 16)),
                for (var gas in _selectedItems) pw.Text(gas),
                pw.SizedBox(height: 20),
                if (selectedOption == 'Daily' && _selectedDailyDate != null)
                  pw.Text(
                      'Selected Date: ${DateFormat.yMMMd().format(_selectedDailyDate!)}'),
                if (selectedOption == 'Weekly' &&
                    _selectedWeeklyDateRange != null)
                  pw.Text(
                      'Selected Date Range: ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.start)} - ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.end)}'),
                if (selectedOption == 'Monthly' && _selectedMonthlyDate != null)
                  pw.Text('Selected Month: $_selectedMonthlyDate'),
                pw.SizedBox(height: 20),
                pw.Text('Graph - Time (HH 00 to 24) Vs Selected Gas Values'),
                pw.Container(
                  height: 200,
                  child: pw.Center(
                      child: pw.Text(
                          'Graph Placeholder')), // Add dynamic graph drawing logic here
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
                pw.SizedBox(height: 8),
                pw.Text('Alarm conditions:', style: regularStyle),
                pw.Text('No alarm detected today.', style: regularStyle),
                pw.SizedBox(height: 8),
                pw.Text('Remarks:', style: regularStyle),
                pw.Text('Two Laparoscopic Procedures carried out today',
                    style: regularStyle),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                        'Report generated from PressData® by wavevisions.in',
                        style: regularStyle),
                    pw.Text('Sign:', style: regularStyle),
                  ],
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

  void _toggleItemSelection(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
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
        if (_selectedWeeklyDateRange == selected) {
          _selectedWeeklyDateRange = null;
        } else {
          _selectedWeeklyDateRange = selected;
          selectedOption = 'Weekly';
          _selectedDailyDate = null;
          _selectedMonthlyDate = null;
        }
      });
    }
  }

  void _selectMonth(BuildContext context) async {
    final List<String> months = List.generate(3, (index) {
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
    }
  }

  @override
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
            if (_selectedItems.isNotEmpty && selectedOption != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black),
                  ),
                  minimumSize: Size(200, 40), // Set the button size
                ),
                onPressed: generatePDF,
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
