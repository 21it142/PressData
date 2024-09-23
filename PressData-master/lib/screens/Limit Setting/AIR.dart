import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pressdata/screens/Limit%20Setting/httpLimit.dart';

class AIR extends StatefulWidget {
  final int min_air;
  final int max_air;

  const AIR({super.key, required this.max_air, required this.min_air});

  @override
  State<AIR> createState() => _AIRState();
}

class _AIRState extends State<AIR> {
  Timer? _maxLimitTimer;
  Timer? _minLimitTimer;
  final LimitSetting _dataService = LimitSetting();

  late Timer _timer;
  late int max = widget.max_air;
  late int min = widget.min_air;

  @override
  void initState() {
    //  _fetchData();
    //loadData();
    super.initState();
  }

  // Future<void> _fetchData() async {
  //   final data = await _dataService.getData();
  //   for (var item in data) {
  //     if (item['type'] == 'AIR_DATA') {
  //       min = item['MIN'];
  //       max = item['MAX'];
  //       // minLimit = min;
  //       // maxLimit = max;
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
      // _fetchData(); // Refresh the data after update
    }
  }

  // Future<void> _updateDataNotpost(double min, double max) async {
  //   if (_postJson.isNotEmpty && _postJson.length > 2) {
  //     final post = _postJson[2];
  //     _updateData(post['type'], minLimit.toDouble(), maxLimit.toDouble());
  //   }
  // }

  // void loadData() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   print("sdfvwfeghnbgfdasfghghmnbgfvdcfgbh");

  //   setState(() {
  //     maxLimit = prefs.getInt('AIR_maxLimit') ?? maxLimit1;
  //     minLimit = prefs.getInt('AIR_minLimit') ?? minLimit1;
  //     print(maxLimit);
  //     print(minLimit);
  //   });
  // }

  void updateMaxLimit(double value) async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    final newValue = (value.clamp(min.toDouble() + 1, 75.0)).toInt();
    setState(() {
      max = newValue;
      //prefs.setInt('AIR_maxLimit', max);
      print("efefvwfberfvwf$max");
    });
  }

  void _startMaxLimitTimer(bool increment) {
    _maxLimitTimer?.cancel();
    _maxLimitTimer = Timer.periodic(Duration(milliseconds: 200), (_) {
      setState(() {
        max += increment ? 1 : -1;
        updateMaxLimit(max.toDouble());
      });
    });
  }

  void _startMinLimitTimer(bool increment) {
    _minLimitTimer?.cancel();
    _minLimitTimer = Timer.periodic(Duration(milliseconds: 200), (_) {
      setState(() {
        min += increment ? 1 : -1;
        updateMinLimit(min.toDouble());
      });
    });
  }

  void _stopMaxLimitTimer() {
    _maxLimitTimer?.cancel();
  }

  void _stopMinLimitTimer() {
    _minLimitTimer?.cancel();
  }

  void updateMinLimit(double value) async {
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    final newValue = (value.clamp(30.0, max.toDouble() - 1)).toInt();

    setState(() {
      min = newValue;
      //  prefs.setInt('AIR_minLimit', min);
    });
  }

  @override
  void dispose() {
    _maxLimitTimer?.cancel();
    _minLimitTimer?.cancel();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(134, 248, 255, 1),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_outlined),
          iconSize: 25,
        ),
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  text: 'AIR ',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ), // Normal text style
                  children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(
                            0, 5), // Move text down to simulate subscript
                        child: Text(
                          '(PSI)',
                          style: TextStyle(
                            fontSize:
                                18, // Slightly smaller font to mimic subscript
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                        text: ' Alarm Settings',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
              )
            ],
          ),
        ),
        backgroundColor: Color.fromRGBO(134, 248, 255, 1),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 4.0,
          ),
        ),
        toolbarHeight: 50,
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
                      color: const Color.fromARGB(255, 198, 230, 255),
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
                  ),
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
                      color: const Color.fromARGB(255, 198, 230, 255),
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
                  ),
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
                    //  final post = _postJson[2];
                    _updateData('AIR_DATA', min.toDouble(), max.toDouble());

                    print("fvedvegfvwevegfvewd");
                    //  loadData();
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
