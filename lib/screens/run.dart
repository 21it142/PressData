import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class WeekSelectionWidget extends StatefulWidget {
  @override
  _WeekSelectionWidgetState createState() => _WeekSelectionWidgetState();
}

class _WeekSelectionWidgetState extends State<WeekSelectionWidget> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Weekly Date Range'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.now(),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameWeek(day, _selectedDay!);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _selectedStartDate = selectedDay
                      .subtract(Duration(days: selectedDay.weekday % 7));
                  _selectedEndDate = _selectedStartDate!.add(Duration(days: 6));
                });
              },
            ),
            SizedBox(height: 20),
            if (_selectedStartDate != null && _selectedEndDate != null)
              Column(
                children: [
                  Text(
                    'Selected Date Range:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${DateFormat.yMMMd().format(_selectedStartDate!)} - ${DateFormat.yMMMd().format(_selectedEndDate!)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  bool isSameWeek(DateTime a, DateTime b) {
    DateTime aStart = a.subtract(Duration(days: a.weekday % 7));
    DateTime aEnd = aStart.add(Duration(days: 6));

    DateTime bStart = b.subtract(Duration(days: b.weekday % 7));
    DateTime bEnd = bStart.add(Duration(days: 6));

    return aStart.isAtSameMomentAs(bStart) && aEnd.isAtSameMomentAs(bEnd);
  }
}

void main() {
  runApp(MaterialApp(
    home: WeekSelectionWidget(),
  ));
}
