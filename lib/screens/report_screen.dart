import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

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

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text('Report for $selectedOption',
                    style: pw.TextStyle(fontSize: 20)),
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

  void _showMultiSelect() async {
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

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
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
        _selectedWeeklyDateRange = selected;
        selectedOption = 'Weekly';
        _selectedDailyDate = null;
        _selectedMonthlyDate = null;
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 145, 248, 248),
      appBar: AppBar(
        leading:
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_outlined)),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _showMultiSelect,
              child: const Text(
                'Select Report',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            const Divider(
              height: 10,
            ),
            Wrap(
              children: _selectedItems
                  .map((e) => Chip(
                        label: Text(e),
                      ))
                  .toList(),
            ),
            SizedBox(
              height: 35,
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Daily'),
            ),
            if (_selectedDailyDate != null)
              Text(
                  'Selected Date: ${DateFormat.yMMMd().format(_selectedDailyDate!)}'),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: Text('Select Weekly'),
            ),
            if (_selectedWeeklyDateRange != null)
              Text(
                  'Selected Date Range: ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.start)} - ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.end)}'),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _selectMonth(context),
              child: Text('Select Monthly'),
            ),
            if (_selectedMonthlyDate != null)
              Text('Selected Month: $_selectedMonthlyDate'),
            SizedBox(
              height: 45,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: generatePDF,
              child: Text(
                "Generate Report",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
