import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:pressdata/screens/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'httpLimit.dart';

class VAC extends StatefulWidget {
  const VAC({super.key});

  @override
  State<VAC> createState() => _VACState();
}

class _VACState extends State<VAC> {
  int maxLimit = 0;
  int minLimit = 0;
  Timer? _maxLimitTimer;
  Timer? _minLimitTimer;
  final LimitSetting _dataService = LimitSetting();
  List<dynamic> _postJson = [];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    loadData();
    _fetchData();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _fetchData();
    });
  }

  void _startMaxLimitTimer(bool increment) {
    _maxLimitTimer?.cancel();
    _maxLimitTimer = Timer.periodic(Duration(milliseconds: 200), (_) {
      updateMaxLimit(maxLimit.toDouble() + (increment ? 1.0 : -1.0));
    });
  }

  void _startMinLimitTimer(bool increment) {
    _minLimitTimer?.cancel();
    _minLimitTimer = Timer.periodic(Duration(milliseconds: 200), (_) {
      updateMinLimit(minLimit.toDouble() + (increment ? 1.0 : -1.0));
    });
  }

  void _stopMaxLimitTimer() {
    _maxLimitTimer?.cancel();
  }

  void _stopMinLimitTimer() {
    _minLimitTimer?.cancel();
  }

  Future<void> _fetchData() async {
    try {
      final data = await _dataService.getData();
      setState(() {
        _postJson = data;
      });
    } catch (error) {
      // Handle error as needed
      print('Error fetching data: $error');
    }
  }

  Future<void> _updateData(String type, double min, double max) async {
    final success = await _dataService.updateData(type, min, max);
    if (success) {
      _fetchData(); // Refresh the data after update
    }
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      maxLimit = prefs.getInt('VAC_maxLimit') ?? 0;
      minLimit = prefs.getInt('VAC_minLimit') ?? 0;
    });
  }

  void updateMaxLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maxLimit = (value.clamp(50.0, 500.0) - 1.0).toInt() + 1;
      prefs.setInt('VAC_maxLimit', maxLimit);

      if (_postJson.isNotEmpty && _postJson.length > 2) {
        final post = _postJson[3];
        _updateData(post['type'], minLimit.toDouble(), maxLimit.toDouble());
      }
    });
  }

  void updateMinLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      minLimit = (value.clamp(50.0, maxLimit.toDouble() - 1.0)).toInt();
      prefs.setInt('VAC_minLimit', minLimit);

      if (_postJson.isNotEmpty && _postJson.length > 2) {
        final post = _postJson[3];
        _updateData(post['type'], minLimit.toDouble(), maxLimit.toDouble());
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post =
        (_postJson.isNotEmpty && _postJson.length > 2) ? _postJson[3] : {};
    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 248, 255, 1),
      appBar: AppBar(
        leading: IconButton(
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
                      color: Colors.yellow,
                      child: Column(
                        children: [
                          Text(
                            '${post['MAX'] ?? ''}',
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
                      color: Colors.yellow,
                      child: Column(
                        children: [
                          Text(
                            '${post['MIN'] ?? ''}',
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
                    onTapDown: (_) => _startMinLimitTimer(true),
                    onTapUp: (_) => _stopMinLimitTimer(),
                    child: Icon(
                      Icons.add,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
