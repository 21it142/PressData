import 'dart:io';
// import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:pressdata/screens/Daily_chartDemo.dart';

import 'package:pressdata/screens/Monthly_chartDemo.dart';
import 'package:pressdata/screens/Weekly_chartDemo.dart';

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
                  final value = 1;
                  Navigator.pop(context, value);
                },
              ),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: () {
                  if (_selectedDailyDate != null) {
                    Navigator.of(context).pop();
                    // generatePDF_Daily();
                  } else if (_selectedWeeklyDateRange != null) {
                    Navigator.of(context).pop();
                    // generatePDF_Weekly();
                  } else if (_selectedMonthlyDate != null) {
                    Navigator.of(context).pop();
                    // generatePDF_Monthly();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedData();
    _loadSelectAllState();
  }

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
  bool _selectAll = false;

  void _toggleItemSelection(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        // If the item is already selected and is unchecked
        _selectedItems.clear(); // Uncheck all items
      } else {
        // If the item is not selected
        _selectedItems.clear(); // Ensure only one item is selected
        _selectedItems.add(item); // Add the new selection
      }
      _selectAll = _selectedItems.length ==
          items.length; // Check if all items are selected
    });
    _saveSelectedData();
  }

  void _toggleSelectAll() async {
    setState(() {
      if (_selectAll) {
        // If already selecting all items, unselect everything
        _selectedItems.clear();
      } else {
        // If not all items are selected, select all items
        _selectedItems = List.from(items);
      }
      _selectAll = !_selectAll; // Toggle the select all state
    });
    _saveSelectAllState();
    _saveSelectedData();
  }

  Future<void> _loadSelectAllState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectAll = prefs.getBool('selectAll') ?? false;
      _selectedItems = _selectAll ? List.from(items) : [];
    });
  }

  Future<void> _saveSelectAllState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('selectAll', _selectAll);
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

      print(
          "qewrtyuikujmynhbgvfcdfvgbhnjmk,mujnyhbgvfcdfbghnyjukjmnhb$_selectedDailyDate");
      // Navigate to DailyCart page
      pngBytes = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DailyChartDemo(
                  selectedValues: _selectedItems,
                  selectedDate: _selectedDailyDate,
                )),
      );
    }
  }

  // bool _isFixedWeekSelection = true;
  // Replace with your actual selected items
  void _selectDateRange(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 90)),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      // Fixed week selection: Monday to Sunday
      int daysFromMonday = (selectedDate.weekday - 1) % 7;
      DateTime startOfWeek =
          selectedDate.subtract(Duration(days: daysFromMonday));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

      setState(() {
        _selectedWeeklyDateRange =
            DateTimeRange(start: startOfWeek, end: endOfWeek);
        selectedOption = 'Weekly';
        _selectedDailyDate = null;
        _selectedMonthlyDate = null;
      });

      _saveSelectedData();

      pngBytes = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeeklyChart(
            selectedValues: _selectedItems,
            start: startOfWeek,
            end: endOfWeek,
          ),
        ),
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
      pngBytes = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MonthlyChart(
                  selectedValues: _selectedItems,
                  month: selected,
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
            "Demo Report",
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
              height: 5,
            ),
            Text('Select All'),
            Switch(
              value: _selectAll,
              onChanged: (value) {
                _toggleSelectAll();
              },
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
                  ],
                ),
                Column(
                  children: [
                    if (_selectedDailyDate != null)
                      Text(
                        'Selected Date: ${DateFormat.yMMMd().format(_selectedDailyDate!)}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedOption == 'Weekly'
                            ? Colors.green
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () => _selectDateRange(context),
                      child: Text('Weekly'),
                    ),
                    if (_selectedWeeklyDateRange != null)
                      Text(
                        'Selected Week: ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.start)} - ${DateFormat.yMMMd().format(_selectedWeeklyDateRange!.end)}',
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
          ],
        ),
      ),
    );
  }
}
