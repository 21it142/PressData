import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pressdata/screens/main_page.dart';
import 'package:pressdata/widgets/demo.dart';
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

  @override
  void initState() {
    loadData();
    // TODO: implement initState
    super.initState();
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
      maxLimit = (value.clamp(1.0, double.infinity) - 1.0).toInt() + 1;
      prefs.setInt('VAC_maxLimit', maxLimit);
    });
  }

  void updateMinLimit(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      minLimit = (value.clamp(0.0, maxLimit.toDouble() - 1.0)).toInt();
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
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DemoWid()));
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
                    child: Icon(Icons.remove),
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
                    onTapDown: (_) => _startMaxLimitTimer(true),
                    onTapUp: (_) => _stopMaxLimitTimer(),
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTapDown: (_) => _startMinLimitTimer(false),
                    onTapUp: (_) => _stopMinLimitTimer(),
                    child: Icon(Icons.remove),
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
                    onTapDown: (_) => _startMinLimitTimer(true),
                    onTapUp: (_) => _stopMinLimitTimer(),
                    child: Icon(Icons.add),
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
