// import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pressdata/data/db.dart';
//import 'package:pressdata/data/entity/press_data_entity.dart';

import 'package:pressdata/screens/Daily_chart.dart';
import 'package:pressdata/screens/Monthly_chart.dart';

import 'package:pressdata/screens/Weekly_chart.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ReportScreenPast extends StatefulWidget {
  const ReportScreenPast({
    super.key,
  });

  @override
  State<ReportScreenPast> createState() => _ReportScreenPastState();
}

class _ReportScreenPastState extends State<ReportScreenPast> {
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();
  DateTime? _selectedDailyDate;
  DateTimeRange? _selectedWeeklyDateRange;
  String? _selectedMonthlyDate;
  PressDataDb? db;
  List<String> _selectedItems = [];
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    db = PressDataDb();
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

  DateTime date = DateTime.now();
  void _convertMonthToDateTime(String month) {
    try {
      DateFormat dateFormat = DateFormat('MMMM yyyy');

      date = dateFormat.parse(month);

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

  void _selectDate(BuildContext context) async {
    try {
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

        // Call the new function to show the dialog
        showDeviceAndLocationDialogDaily(context, selected);
      }
    } catch (e) {
      print('Error: $e');
      // Optionally, show an error dialog or message to the user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void showDeviceAndLocationDialogDaily(
      BuildContext context, DateTime selectedDate) async {
    try {
      if (db == null) {
        // Handle the case where db is null
        throw Exception('Database is not initialized.');
      }

      // Fetch distinct serial numbers and location IDs
      final distinctData =
          await db!.getDistinctSerialAndLocationDaily(selectedDate);

      // Show dialog with the list of serial numbers and location IDs
      if (distinctData.isEmpty)
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Select Device and Location'),
              content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/NoData.png',
                        height: 200,
                      ),
                      Text("No Data Found"),
                    ],
                  )),
            );
          },
        );
      if (distinctData.isNotEmpty)
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Select Device and Location'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: distinctData.length,
                  itemBuilder: (context, index) {
                    final data = distinctData[index];
                    return ListTile(
                      title: Text(
                          'Device: ${data.serialNo}, Location: ${data.locationNo}'),
                      onTap: () {
                        Navigator.pop(context); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DailyChart(
                              selectedValues: _selectedItems,
                              selectedDailyDate: selectedDate,
                              serialNo: data.serialNo,
                              location: data.locationNo,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
    } catch (e) {
      print('Error: $e');
      // Optionally, show an error dialog or message to the user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void showDeviceAndLocationDialogWeekly(
      BuildContext context, DateTime startdate, endDate) async {
    try {
      if (db == null) {
        // Handle the case where db is null
        throw Exception('Database is not initialized.');
      }

      // Fetch distinct serial numbers and location IDs
      final distinctData =
          await db!.getDistinctSerialAndLocationweekly(startdate, endDate);

      // Show dialog with the list of serial numbers and location IDs
      if (distinctData.isEmpty)
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Select Device and Location'),
              content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/NoData.png',
                        height: 200,
                      ),
                      Text("No Data Found"),
                    ],
                  )),
            );
          },
        );
      if (distinctData.isNotEmpty)
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Select Device and Location'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: distinctData.length,
                  itemBuilder: (context, index) {
                    final data = distinctData[index];
                    return ListTile(
                      title: Text(
                          'Device: ${data.serialNo}, Location: ${data.locationNo}'),
                      onTap: () {
                        Navigator.pop(context); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WeeklyChartLive(
                                    serialNo: data.serialNo,
                                    location: data.locationNo,
                                    selectedValues: _selectedItems,
                                    stardate: startdate,
                                    endDate: endDate,
                                  )),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
    } catch (e) {
      print('Error: $e');
      // Optionally, show an error dialog or message to the user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void showDeviceAndLocationDialogMonthly(
      BuildContext context, DateTime startdate, endDate, String month) async {
    try {
      if (db == null) {
        // Handle the case where db is null
        throw Exception('Database is not initialized.');
      }

      // Fetch distinct serial numbers and location IDs
      final distinctData =
          await db!.getDistinctSerialAndLocationMonthly(startdate, endDate);

      if (distinctData.isEmpty)
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Select Device and Location'),
              content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/NoData.png',
                        height: 200,
                      ),
                      Text("No Data Found"),
                    ],
                  )),
            );
          },
        );
      if (distinctData.isNotEmpty)
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Select Device and Location'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: distinctData.length,
                  itemBuilder: (context, index) {
                    final data = distinctData[index];
                    return ListTile(
                      title: Text(
                          'Device: ${data.serialNo}, Location: ${data.locationNo}'),
                      onTap: () {
                        Navigator.pop(context); // Close the dialog
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MonthlyChartLive(
                                      locationNo: data.locationNo,
                                      serialNo: data.serialNo,
                                      selectedValues: _selectedItems,
                                      month: month,
                                    )));
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
    } catch (e) {
      print('Error: $e');
      // Optionally, show an error dialog or message to the user
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _selectDateRange(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 90)),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      DateTime startOfWeek;
      DateTime endOfWeek;
      // Fixed week selection: Monday to Sunday
      int daysFromMonday = (selectedDate.weekday - 1) % 7;
      startOfWeek = selectedDate.subtract(Duration(days: daysFromMonday));
      endOfWeek = startOfWeek.add(Duration(days: 6));

      setState(() {
        _selectedWeeklyDateRange =
            DateTimeRange(start: startOfWeek, end: endOfWeek);
        selectedOption = 'Weekly';
        _selectedDailyDate = null;
        _selectedMonthlyDate = null;
      });
      showDeviceAndLocationDialogWeekly(context, startOfWeek, endOfWeek);
      _saveSelectedData();

      // // Navigator.push(
      // //   context,
      // //   MaterialPageRoute(
      // //       builder: (context) => WeeklyChartLive(
      // //             serialNo: widget.serialNo!,
      // //             location: widget.LocationNo!,
      // //             selectedValues: _selectedItems,
      // //             stardate: startOfWeek,
      // //             endDate: endOfWeek,
      // //           )),
      // );
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
                _convertMonthToDateTime(month);
                showDeviceAndLocationDialogMonthly(
                    context, start_date, end_date, month);
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
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => MonthlyChartLive(

      //             selectedValues: _selectedItems,
      //           )),
      // );
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

  void _showSelectParameterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Parameter'),
        content: Text('Please select a parameter before proceeding.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
              final value = 1;
              Navigator.pop(context, value);
            },
            icon: Icon(Icons.arrow_back_outlined)),
        title: Center(
          child: Text(
            "Reports",
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
      toolbarHeight: 50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              color: Colors.black,
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
                      onPressed: () {
                        if (_selectedItems.isEmpty) {
                          _showSelectParameterDialog(context);
                        } else {
                          _selectDate(context);
                        }
                      },
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
                      onPressed: () {
                        if (_selectedItems.isEmpty) {
                          _showSelectParameterDialog(context);
                        } else {
                          _selectDateRange(context);
                        }
                      },
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
                      onPressed: () {
                        if (_selectedItems.isEmpty) {
                          _showSelectParameterDialog(context);
                        } else {
                          _selectMonth(context);
                        }
                      },
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
