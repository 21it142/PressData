import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pressdata/models/model.dart';
import 'package:pressdata/screens/Past_Report.dart';
////import 'package:pressdata/screens/ReportScreen.dart';
import 'package:pressdata/widgets/demo.dart';
import 'package:pressdata/widgets/linechart.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
//import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  Dashboard({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  String date = '';
  String? _wifiName;
  bool _isLoading = true;
  String _targetWifiName = "Press_data";
  final LineCharWid _lineChartWid = LineCharWid();

  late AnimationController _animationController;
  late Animation<double> _animation;
  bool checker = false;
  String deviceNo = "";
  @override
  void initState() {
    super.initState();
    // _handlePermissions();
    date = DateFormat('dd-MM-yyyy   HH:mm').format(DateTime.now());
    fetchdata();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      date = DateFormat('dd-MM-yyyy  HH:mm').format(DateTime.now());
      fetchdata();
    });

    _initWifiName();

    // Start periodic checking of WiFi network
    _startWifiCheckTimer();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void fetchdata() async {
    try {
      var url = Uri.parse('http://192.168.4.1/getdata');
      final response = await http.get(url);
      final data = json.decode(response.body);
      for (var jsonData in data) {
        PressData pressdata = PressData.fromJson(jsonData);
        deviceNo = pressdata.serialNo;

        print("DevicenO$deviceNo");
        if (deviceNo.startsWith("PDA")) {
          setState(() {
            checker = true;
          });
        }
        break;
      }
    } catch (e) {
      setState(() {
        checker = false;
      });
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _stopWifiCheckTimer();

    _animationController.dispose();
    super.dispose();
  }

  // void _handlePermissions() async {
  //   if (await Permission.photos.isGranted &&
  //       await Permission.videos.isGranted &&
  //       await Permission.audio.isGranted) {
  //     print("Photo, video, and audio permissions already granted.");
  //   } else {
  //     await _requestPermissions();
  //   }
  // }

  void _initWifiName() async {
    // Retrieve WiFi name
    try {
      String? wifiName = await NetworkInfo().getWifiName();
      print("wifi name: \"$wifiName\"");
      setState(() {
        _wifiName = wifiName;
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      print("Failed to get wifi name: '${e.message}'.");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _requestPermissions() async {
  //   var statuses = await [
  //     ///  Permission.manageExternalStorage,
  //     Permission.locationAlways,
  //     Permission.locationWhenInUse,
  //     Permission.accessMediaLocation,
  //     Permission.activityRecognition,
  //   ].request();

  //   if (statuses[Permission.locationWhenInUse]!.isGranted) {
  //     print("");
  //     print("All necessary permissions are granted.");
  //   } else {
  //     print("Some permissions are denied. Please enable them from settings.");
  //     _showPermissionDialog();
  //   }
  // }

  // void _showPermissionDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: Text("Permissions Denied"),
  //       content: Text(
  //           "Photo, video, and audio permissions are required. Please enable them in the app settings."),
  //       actions: <Widget>[
  //         TextButton(
  //           child: Text("Open Settings"),
  //           onPressed: () {
  //             openAppSettings();
  //           },
  //         ),
  //         TextButton(
  //           child: Text("Cancel"),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Timer for periodic checking of WiFi network
  late Timer _wifiCheckTimer;

  void _startWifiCheckTimer() {
    // Check every 5 seconds
    _wifiCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _updateWifiStatus();
    });
  }

  void _stopWifiCheckTimer() {
    _wifiCheckTimer.cancel();
  }

  void _updateWifiStatus() async {
    String? wifiName = await NetworkInfo().getWifiName();
    setState(() {
      _wifiName = wifiName;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              deviceNo,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Center(
              child: RichText(
                text: const TextSpan(
                  text: 'Press',
                  style: TextStyle(
                    color: Color.fromRGBO(0, 25, 152, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  children: [
                    TextSpan(
                      text: 'Data\u00AE ', // Adding the trademark symbol here
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Medical Gas Alarm + Analyser ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              date,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        toolbarHeight: 30,
        backgroundColor: Color.fromRGBO(228, 100, 128, 100),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : checker
              ? Stack(
                  children: [
                    _lineChartWid,
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value,
                            child: Icon(
                              Icons.wifi_off,
                              size: 100,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Device is not connected",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black87,
                                ),
                                borderRadius:
                                    BorderRadius.circular(5), // Square corners
                              ),
                              minimumSize: Size(190,
                                  50), // Set minimum size to maintain height
                              backgroundColor:
                                  Color.fromRGBO(228, 100, 128, 100),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const DemoWid()),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_circle_filled,
                                    size: 30,
                                    color: Color.fromARGB(255, 0, 0, 0)),
                                // Replace with the desired icon
                                SizedBox(
                                    width:
                                        8), // Add some space between the icon and the text
                                const Text(
                                  'Demo Mode',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.grey,
                                        offset: Offset(2, 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.black87,
                                ),
                                borderRadius:
                                    BorderRadius.circular(5), // Square corners
                              ),
                              minimumSize: Size(190,
                                  50), // Set minimum size to maintain height
                              backgroundColor:
                                  Color.fromRGBO(228, 100, 128, 100),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ReportScreenPast()),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.insert_chart,
                                    size: 30,
                                    color: Color.fromARGB(255, 0, 0,
                                        0)), // Choose an appropriate icon
                                SizedBox(
                                    width:
                                        5), // Add some space between the icon and the text
                                const Text(
                                  'Reports',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.grey,
                                        offset: Offset(2, 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
