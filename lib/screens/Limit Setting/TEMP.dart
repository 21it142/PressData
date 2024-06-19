import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pressdata/screens/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'httpLimit.dart';

class TEMP extends StatefulWidget {
  const TEMP({super.key});

  @override
  State<TEMP> createState() => _TEMPState();
}

class _TEMPState extends State<TEMP> {
  int maxLimit = 0;
  int minLimit = 0;
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
      maxLimit = prefs.getInt('TEMP_maxLimit') ?? 0;
      minLimit = prefs.getInt('TEMP_minLimit') ?? 0;
    });
  }

  void updateMaxLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      maxLimit = (value.clamp(1.0, double.infinity) - 1.0).toInt() + 1;
      prefs.setInt('TEMP_maxLimit', maxLimit);

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
      prefs.setInt('TEMP_minLimit', minLimit);

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            },
            icon: Icon(Icons.arrow_back_outlined)),
        title: Center(
          child: Column(
            children: [
              Text(
                "TEMP Limit Settings",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "°C",
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
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      updateMaxLimit(maxLimit.toDouble() - 1.0);
                      // product.minLimit = (product.minLimit > 0) ? product.minLimit - 1 : 0;
                      // onChanged();
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: 150,
                    child: Card(
                      color: const Color.fromARGB(255, 195, 0, 0),
                      child: Column(
                        children: [
                          Text(
                            '${post['MAX'] ?? ''}',
                            style: TextStyle(fontSize: 31, color: Colors.white),
                          ),
                          Text(
                            "Maximum Limit",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          )
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                    ),
                  ), //${product.minLimit}
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      updateMaxLimit(maxLimit.toDouble() + 1.0);
                      // product.minLimit++;
                      // onChanged();
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
                      // product.maxLimit = (product.maxLimit > 0) ? product.maxLimit - 1 : 0;
                      // onChanged();
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: 150,
                    child: Card(
                      color: const Color.fromARGB(255, 195, 0, 0),
                      child: Column(
                        children: [
                          Text(
                            '${post['MIN'] ?? ''}',
                            style: TextStyle(fontSize: 31, color: Colors.white),
                          ),
                          Text(
                            "Minimum Limit",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          )
                        ],
                      ),
                      margin: EdgeInsets.all(10),
                    ),
                  ), //${product.maxLimit}
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      updateMinLimit(minLimit.toDouble() + 1.0);
                      // product.maxLimit++;
                      // onChanged();
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
