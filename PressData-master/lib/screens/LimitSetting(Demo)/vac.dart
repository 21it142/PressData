import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:pressdata/screens/main_page.dart';
//import 'package:pressdata/widgets/demo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VACD extends StatefulWidget {
  const VACD({super.key});

  @override
  State<VACD> createState() => _VACState();
}

class _VACState extends State<VACD> {
  int maxLimit = 0;
  int minLimit = 0;
  Timer? _maxLimitTimer;
  Timer? _minLimitTimer;

  Timer? _timer;
  Duration _interval = Duration(milliseconds: 500); // Initial interval
  int _incrementStep = 1; // Increment step
  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
  }

  void _startMaxLimitTimer(bool isIncrement) {
    _timer?.cancel(); // Ensure no existing timer is running
    _interval = Duration(milliseconds: 500); // Start with the slowest interval
    _incrementStep = 1; // Start with a small increment step
    int elapsedMilliseconds = 0; // Track how long the button has been pressed

    _timer = Timer.periodic(_interval, (timer) {
      elapsedMilliseconds += _interval.inMilliseconds; // Increment elapsed time

      updateMaxLimit(isIncrement
          ? (maxLimit + _incrementStep).toDouble()
          : (maxLimit - _incrementStep).toDouble());

      // Gradually increase speed with a controlled acceleration curve
      if (elapsedMilliseconds >= 1000) {
        // After 1 second, start accelerating
        if (_interval.inMilliseconds > 100) {
          _interval =
              Duration(milliseconds: (_interval.inMilliseconds * 0.9).round());
        } else if (_interval.inMilliseconds > 50) {
          _interval =
              Duration(milliseconds: (_interval.inMilliseconds * 0.95).round());
        }

        // Increase increment step proportionally as the interval shortens
        if (_interval.inMilliseconds <= 200) {
          _incrementStep = 2; // Increase faster after the speed picks up
        } else if (_interval.inMilliseconds <= 100) {
          _incrementStep = 3; // Maximum speed increment
        }

        // Restart the timer with the updated interval and step
        _timer?.cancel();
        _startMaxLimitTimer(isIncrement);
      }
    });
  }

  void _startMinLimitTimer(bool increment) {
    _minLimitTimer?.cancel();
    _minLimitTimer = Timer.periodic(Duration(milliseconds: 200), (_) {
      updateMinLimit(minLimit.toDouble() + (increment ? 1.0 : -1.0));
    });
  }

  void _stopMaxLimitTimer() {
    _timer?.cancel();
    _maxLimitTimer?.cancel();
  }

  void _stopMinLimitTimer() {
    _minLimitTimer?.cancel();
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      maxLimit = prefs.getInt('VAC_maxLimit') ?? 20;
      minLimit = prefs.getInt('VAC_minLimit') ?? 0;
    });
  }

  void updateMaxLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maxLimit = (value.clamp(minLimit.toDouble() + 1, 500.0)).toInt();
      prefs.setInt('VAC_maxLimit', maxLimit);
    });
  }

  void updateMinLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      minLimit = (value.clamp(50, maxLimit.toDouble() - 1.0)).toInt();
      prefs.setInt('VAC_minLimit', minLimit);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 248, 255, 1),
      appBar: AppBar(
        leading: IconButton(
            iconSize: 50,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined)),
        title: Center(
          child: Column(
            children: [
              Text(
                "VAC Limit Settings",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "mmHg",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
        backgroundColor: Color.fromRGBO(134, 248, 255, 1),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0), // Adjust the height as needed
          child: Container(
            color: Colors.black, // Change this to the desired border color
            height: 4.0, // Height of the bottom border
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("O2", style: TextStyle(fontSize: 20)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => updateMaxLimit(maxLimit.toDouble() - 1.0),
                    onLongPressStart: (_) => _startMaxLimitTimer(false),
                    onLongPressEnd: (_) => _stopMaxLimitTimer(),
                    child: Icon(
                      Icons.remove,
                      size: 50,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: 150,
                    child: Card(
                      color: Colors.yellow,
                      child: Column(
                        children: [
                          Text(
                            '${maxLimit}',
                            style: TextStyle(fontSize: 31, color: Colors.black),
                          ),
                          Text(
                            "Maximum Limit",
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          )
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                    ),
                  ), //${product.minLimit}
                  GestureDetector(
                    onTap: () => updateMaxLimit(maxLimit.toDouble() + 1.0),
                    onLongPressStart: (_) => _startMaxLimitTimer(true),
                    onLongPressEnd: (_) => _stopMaxLimitTimer(),
                    child: Icon(
                      Icons.add,
                      size: 50,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => updateMinLimit(minLimit.toDouble() - 1.0),
                    onLongPressStart: (_) => _startMinLimitTimer(false),
                    onLongPressEnd: (_) => _stopMinLimitTimer(),
                    child: Icon(
                      Icons.remove,
                      size: 50,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: 150,
                    child: Card(
                      color: Colors.yellow,
                      child: Column(
                        children: [
                          Text(
                            '${minLimit}',
                            style: TextStyle(fontSize: 31, color: Colors.black),
                          ),
                          Text(
                            "Minimum Limit",
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          )
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                    ),
                  ), //${product.maxLimit}
                  GestureDetector(
                    onTap: () => updateMinLimit(minLimit.toDouble() + 1.0),
                    onLongPressStart: (_) => _startMinLimitTimer(true),
                    onLongPressEnd: (_) => _stopMinLimitTimer(),
                    child: Icon(
                      Icons.add,
                      size: 50,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 70,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
