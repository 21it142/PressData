// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:pressdata/screens/register.dart';
// import 'package:pressdata/screens/report_screen.dart';
// //import 'package:get/get.dart';
// import 'package:pressdata/screens/setting.dart';
// import 'package:pressdata/widgets/line.dart';
// //import 'package:pressdata/widgets/demo.dart';
// //import 'package:pressdata/widgets/line.dart';
// import 'package:pressdata/widgets/linechart.dart';
// //import '../widgets/connectivity.dart';
// import 'dart:async';

// class Dashboard extends StatefulWidget {
//   const Dashboard({
//     super.key,
//   });

//   @override
//   State<StatefulWidget> createState() {
//     return _DashboardState();
//   }
// }

// class _DashboardState extends State<Dashboard> {
//   //late Timer _connectivityTimer;
//   bool _isConnected = false;

//   StreamSubscription? _internetConnectionStreamSubscription;
//   @override
//   void initState() {
//     super.initState();
//     _internetConnectionStreamSubscription =
//         InternetConnection().onStatusChange.listen((event) {
//       print(event);
//       switch (event) {
//         case InternetStatus.connected:
//           setState(() {
//             _isConnected = true;
//           });
//           break;
//         case InternetStatus.disconnected:
//           setState(() {
//             _isConnected = false;
//           });
//           break;
//         default:
//           setState(() {
//             _isConnected = false;
//           });
//           break;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _internetConnectionStreamSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
//     return Scaffold(
//         appBar: AppBar(
//           title: Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Center(
//                 child: RichText(
//                   text: const TextSpan(
//                       text: 'Press ',
//                       style: TextStyle(color: Colors.blue, fontSize: 25),
//                       children: [
//                         TextSpan(
//                           text: 'Data ',
//                           style: TextStyle(color: Colors.red, fontSize: 25),
//                         ),
//                         TextSpan(
//                           text: 'Medical Gas Alram + Analyser ',
//                           style: TextStyle(
//                               color: Color.fromARGB(255, 0, 0, 0),
//                               fontSize: 20),
//                         ),
//                       ]),
//                 ),
//               ),
//             ],
//           ),
//           toolbarHeight: 40,
//           backgroundColor: const Color.fromRGBO(228, 100, 128, 100),
//         ),
//         body: // _isConnected
//             Stack(
//           children: [
//             LineCharWid(),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: 30,
//                 color: Colors.grey[200], // Background color of the bar
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // IconButton(
//                     //   icon: const Icon(
//                     //     Icons.report,
//                     //     size: 18, // Icon size
//                     //   ),
//                     //   onPressed: () {
//                     //     // Handle report button press
//                     //   },
//                     // ),
//                     // TextButton(
//                     //   style: ButtonStyle(),
//                     //   onPressed: () {
//                     //     // Handle report button press
//                     //   },
//                     //   child: const Text(
//                     //     'Report',
//                     //     style: TextStyle(fontSize: 12),
//                     //   ),
//                     // ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(horizontal: 12.0),
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                                 style: BorderStyle.solid,
//                                 color: Colors.black87),
//                             borderRadius:
//                                 BorderRadius.circular(5), // Square corners
//                           ),
//                           minimumSize: Size(
//                               90, 25), // Set minimum size to maintain height
//                           backgroundColor: Color.fromARGB(255, 192, 191, 191)),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ReportScreen()),
//                         );
//                       },
//                       child: const Text(
//                         'Report',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Color.fromARGB(255, 0, 0, 0),
//                           shadows: [
//                             Shadow(
//                               blurRadius: 4,
//                               color: Colors.grey,
//                               offset: Offset(2, 1.5),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const Text(
//                       'System running ok',
//                       style: TextStyle(fontSize: 12), // Text size
//                     ),
//                     IconButton(
//                       icon: const Icon(
//                         Icons.settings,
//                         size: 18, // Icon size
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => Setting1(),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         )
//         // : const Center(
//         //     child: Column(
//         //     mainAxisAlignment: MainAxisAlignment.center,
//         //     children: [
//         //       Icon(
//         //         Icons.wifi_off,
//         //         size: 30,
//         //       ),
//         //       Text("Internet is not connected"),
//         //       CircularProgressIndicator(),
//         //     ],
//         //   )),
//         );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
//import 'package:get/get.dart';
import 'package:pressdata/screens/setting.dart';
import 'package:pressdata/widgets/linechart.dart';
//import '../widgets/connectivity.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class Dashboard extends StatefulWidget {
  Dashboard({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  String? _wifiName;
  bool _isLoading = true;
  String _targetWifiName = "Press_data";

  @override
  void initState() {
    super.initState();
    _initWifiName();
    // Start periodic checking of WiFi network
    _startWifiCheckTimer();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _stopWifiCheckTimer();
    super.dispose();
  }

  void _initWifiName() async {
    // Request necessary permissions
    await _requestLocationPermissions();

    // Retrieve WiFi name
    try {
      String? wifiName = await NetworkInfo().getWifiName();
      print("wifi name: \"${wifiName}\"");
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

  Future<void> _requestLocationPermissions() async {
    // Request location permissions
    await Permission.locationAlways.request();
    await Permission.locationWhenInUse.request();
    await Permission.accessMediaLocation.request();
    await Permission.activityRecognition.request();
  }

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
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RichText(
                text: const TextSpan(
                    text: 'Press ',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                    children: [
                      TextSpan(
                        text: 'Data ',
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                      TextSpan(
                        text: 'Medical Gas Alram + Analyser ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontSize: 10),
                      ),
                    ]),
              ),
            ),
          ],
        ),
        toolbarHeight: 15,
        backgroundColor: Color.fromRGBO(231, 223, 223, 100),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _wifiName != null && _wifiName == "\"${_targetWifiName}\""
              ? Stack(
                  children: [
                    LineCharWid(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 30,
                        color: Colors.grey[200], // Background color of the bar
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        style: BorderStyle.solid,
                                        color: Colors.black87),
                                    borderRadius: BorderRadius.circular(
                                        5), // Square corners
                                  ),
                                  minimumSize: Size(90,
                                      25), // Set minimum size to maintain height
                                  backgroundColor:
                                      Color.fromARGB(255, 192, 191, 191)),
                              onPressed: () async {
                                // Handle report button press
                              },
                              child: const Text(
                                'Report',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.grey,
                                      offset: Offset(2, 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Text(
                              'System running ok',
                              style: TextStyle(fontSize: 12), // Text size
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.settings,
                                size: 18, // Icon size
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Setting1(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 30,
                      ),
                      Text("Internet is not connected"),
                    ],
                  ),
                ),
    );
  }
}
