import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pressdata/screens/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'httpLimit.dart';

class CO2 extends StatefulWidget {
  const CO2({super.key});

  @override
  State<CO2> createState() => _CO2State();
}

class _CO2State extends State<CO2> {
  int maxLimit = 0;
  int minLimit = 0;
  final LimitSetting _dataService = LimitSetting();
  List<dynamic> _postJson = [];
  bool _isLoading = false;
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

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _dataService.fetchData();
      setState(() {
        _postJson = data;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
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
      maxLimit = prefs.getInt('CO2_maxLimit') ?? 0;
      minLimit = prefs.getInt('CO2_minLimit') ?? 0;
    });
  }

  void updateMaxLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maxLimit = (value.clamp(1.0, double.infinity) - 1.0).toInt() + 1;
      prefs.setInt('CO2_maxLimit', maxLimit);

      // Check if _postJson is not empty and has at least 3 elements
      if (_postJson.isNotEmpty && _postJson.length > 2) {
        final post = _postJson[0];
        _updateData(post['type'], minLimit.toDouble(), maxLimit.toDouble());
      }
    });
  }

  void updateMinLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      minLimit = (value.clamp(0.0, maxLimit.toDouble() - 1.0)).toInt();
      prefs.setInt('CO2_minLimit', minLimit);

      // Check if _postJson is not empty and has at least 3 elements
      if (_postJson.isNotEmpty && _postJson.length > 2) {
        final post = _postJson[0];
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
        (_postJson.isNotEmpty && _postJson.length > 2) ? _postJson[0] : {};

    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 248, 255, 1),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
        title: Center(
          child: Column(
            children: [
              Text(
                "CO₂ Limit Settings",
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
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      updateMaxLimit(maxLimit.toDouble() - 1.0);
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: 150,
                    child: Card(
                      color: const Color.fromRGBO(62, 66, 70, 1),
                      child: Column(
                        children: [
                          Text(
                            '${post['MAX'] ?? ''}',
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
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      updateMaxLimit(maxLimit.toDouble() + 1.0);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      updateMinLimit(minLimit.toDouble() - 1.0);
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: 150,
                    child: Card(
                      color: const Color.fromRGBO(62, 66, 70, 1),
                      child: Column(
                        children: [
                          Text(
                            '${post['MIN'] ?? ''}',
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
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      updateMinLimit(minLimit.toDouble() + 1.0);
                    },
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
