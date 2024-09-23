import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'httpLimit.dart';

class CO2 extends StatefulWidget {
  final int minco2;
  final int maxco2;

  const CO2({super.key, required this.minco2, required this.maxco2});

  @override
  State<CO2> createState() => _CO2State();
}

class _CO2State extends State<CO2> {
  int maxLimit = 75;
  int minLimit = 30;
  Timer? _maxLimitTimer;
  Timer? _minLimitTimer;

  late int max = widget.maxco2;
  late int min = widget.minco2;
  final LimitSetting _dataService = LimitSetting();
  List<dynamic> _postJson = [];
 // bool _isLoading = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // loadData();
    // _fetchData();
  }

  // Future<void> _fetchData() async {
  //   final data = await _dataService.getData();
  //   for (var item in data) {
  //     if (item['type'] == 'CO2_DATA') {
  //       min = item['MIN'];
  //       max = item['MAX'];
  //       minLimit = min;
  //       maxLimit = max;
  //       break; // Stop the loop once AIR_DATA is found
  //     }
  //   }
  //   print("data->>>>>>>>>$data");
  //   setState(() {
  //     _postJson = data;
  //   });
  // }

  Future<void> _updateData(String type, double min, double max) async {
    final success = await _dataService.updateData(type, min, max);
    if (success) {
      //  _fetchData(); // Refresh the data after update
    }
  }

  // void loadData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();

  //   setState(() {
  //     maxLimit = prefs.getInt('CO2_maxLimit') ?? maxLimit;
  //     minLimit = prefs.getInt('CO2_minLimit') ?? minLimit;
  //   });
  // }

  void updateMaxLimit(double value) async {
   // final SharedPreferences prefs = await SharedPreferences.getInstance();
    final newValue = (value.clamp(min.toDouble() + 1, 75.0)).toInt();
    setState(() {
      max = newValue;
      // prefs.setInt('CO2_maxLimit', maxLimit);

      // Check if _postJson is not empty and has at least 1 element
    });
  }

  void updateMinLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final newValue = (value.clamp(30.0, max.toDouble() - 1)).toInt();
    setState(() {
      min = newValue;
      //prefs.setInt('CO2_minLimit', minLimit);

      // Check if _postJson is not empty and has at least 1 element
    });
  }

  void _startMaxLimitTimer(bool increment) {
    _maxLimitTimer?.cancel();
    _maxLimitTimer = Timer.periodic(Duration(milliseconds: 200), (_) {
      updateMaxLimit(max.toDouble() + (increment ? 1.0 : -1.0));
    });
  }

  void _startMinLimitTimer(bool increment) {
    _minLimitTimer?.cancel();
    _minLimitTimer = Timer.periodic(Duration(milliseconds: 200), (_) {
      updateMinLimit(min.toDouble() + (increment ? 1.0 : -1.0));
    });
  }

  void _stopMaxLimitTimer() {
    _maxLimitTimer?.cancel();
  }

  void _stopMinLimitTimer() {
    _minLimitTimer?.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = (_postJson.isNotEmpty) ? _postJson[0] : {};

    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 248, 255, 1),
      appBar: AppBar(
        leading: IconButton(
          iconSize: 50,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
        title: Center(
          child: Column(
            children: [
              Text(
                "CO₂ Alaram Settings",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "PSI",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => updateMaxLimit(max.toDouble() - 1.0),
                    onTapDown: (_) => _startMaxLimitTimer(false),
                    onTapUp: (_) => _stopMaxLimitTimer(),
                    child: Icon(
                      Icons.remove,
                      size: 50,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: 150,
                    child: Card(
                      color: const Color.fromRGBO(62, 66, 70, 1),
                      child: Column(
                        children: [
                          Text(
                            '${max}',
                            style: TextStyle(
                              fontSize: 31,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Maximum Limit",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => updateMaxLimit(max.toDouble() + 1.0),
                    onTapDown: (_) => _startMaxLimitTimer(true),
                    onTapUp: (_) => _stopMaxLimitTimer(),
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
                    onTap: () => updateMinLimit(min.toDouble() - 1.0),
                    onTapDown: (_) => _startMinLimitTimer(false),
                    onTapUp: (_) => _stopMinLimitTimer(),
                    child: Icon(
                      Icons.remove,
                      size: 50,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: 150,
                    child: Card(
                      color: const Color.fromRGBO(62, 66, 70, 1),
                      child: Column(
                        children: [
                          Text(
                            '$min',
                            style: TextStyle(
                              fontSize: 31,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Minimum Limit",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => updateMinLimit(min.toDouble() + 1.0),
                    onTapDown: (_) => _startMinLimitTimer(true),
                    onTapUp: (_) => _stopMinLimitTimer(),
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
                    _updateData('CO2_DATA', min.toDouble(), max.toDouble());
                    final value = 1;
                    Navigator.pop(context, value);
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
