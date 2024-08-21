import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:pressdata/screens/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'httpLimit.dart';

class O2 extends StatefulWidget {
  final int mino2;
  final int maxo2;
  const O2({super.key, required this.maxo2, required this.mino2});

  @override
  State<O2> createState() => _O2State();
}

class _O2State extends State<O2> {
  int maxLimit = 75;
  int minLimit = 30;
  late int max = widget.maxo2;
  late int min = widget.mino2;
  Timer? _maxLimitTimer;
  Timer? _minLimitTimer;
  final LimitSetting _dataService = LimitSetting();
  List<dynamic> _postJson = [];

  late Timer _timer;
  @override
  void initState() {
    super.initState();
    //  loadData();
    // _fetchData();
  }

  // Future<void> _fetchData() async {
  //   final data = await _dataService.fetchData();
  //   for (var item in data) {
  //     if (item['type'] == 'O2_1_DATA') {
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
  //     maxLimit = prefs.getInt('O2_maxLimit') ?? maxLimit;
  //     minLimit = prefs.getInt('O2_minLimit') ?? minLimit;
  //   });
  // }

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

  void updateMaxLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final newvalue = (value.clamp(min.toDouble() + 1, 75)).toInt();
    setState(() {
      max = newvalue;
      //  prefs.setInt('O2_maxLimit', maxLimit);
    });
  }

  void updateMinLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final newvalue = (value.clamp(30.0, max.toDouble() - 1.0)).toInt();
    setState(() {
      min = newvalue;
      // prefs.setInt('O2_minLimit', minLimit);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
                "O2(1) Alaram Settings",
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
              // Text("O2", style: TextStyle(fontSize: 20)),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => updateMaxLimit(max.toDouble() - 1.0),
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
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            '${max}',
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
                    onTap: () => updateMaxLimit(max.toDouble() + 1.0),
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
                    onTap: () => updateMinLimit(min.toDouble() - 1.0),
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
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            '${min}',
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
                    onTap: () => updateMinLimit(min.toDouble() + 1.0),
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
                    // final post = _postJson[1];
                    _updateData('O2_1_DATA', min.toDouble(), max.toDouble());

                    final value = 1;
                    Navigator.pop(context, value);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.save,
                      //   color: Colors.black,
                      // ),
                      Text(
                        "OK",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                    ],
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
