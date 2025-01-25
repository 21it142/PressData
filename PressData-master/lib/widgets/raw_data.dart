import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pressdata/data/Pressure1.dart';

class DataDisplayScreen extends StatefulWidget {
  @override
  _DataDisplayScreenState createState() => _DataDisplayScreenState();
}

class _DataDisplayScreenState extends State<DataDisplayScreen> {

  int currentIndex = 0;
  int elapsedSeconds = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        // Update index and elapsed time
        currentIndex = (currentIndex + 1) % jsonData.length;
        elapsedSeconds++; // Continuously increments without resetting
      });
    });
  }

  String formatElapsedTime(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600) % 24;
    final minutes = (totalSeconds ~/ 60) % 60;
    final seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = jsonData[currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('O2 Data Display'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.grey[300],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Elapsed Time: ${formatElapsedTime(elapsedSeconds)}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'O2(1): ${data["O2(1)"]}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
