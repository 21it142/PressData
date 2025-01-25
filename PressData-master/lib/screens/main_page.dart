import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:pressdata/main.dart';
import 'package:pressdata/models/model.dart';
import 'package:pressdata/mqtt/mqtt.dart';
import 'package:pressdata/screens/Login.dart';
import 'package:pressdata/screens/Past_Report.dart';
////import 'package:pressdata/screens/ReportScreen.dart';
import 'package:pressdata/widgets/demo.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:pressdata/widgets/linechart_mqtt.dart';
import 'package:pressdata/widgets/linechart.dart';
import 'package:pressdata/widgets/raw_data.dart';
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
  bool local_checker = false;
  bool internetchecker = false;
  String? _wifiName;
  bool _isLoading = true;
  String _targetWifiName = "Press_data";
  LineCharWid_mqtt _lineChartWid = LineCharWid_mqtt();
  LineCharWid _lineChartWid_local = LineCharWid();
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

        print("Devicen$deviceNo");
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

  Future<bool> _onWillPop() async {
    // Show the dialog box to confirm exit
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(Icons.exit_to_app), // Exit icon
                SizedBox(width: 8),
                Text('Confirm Exit'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/exit.jpg', // Replace with your image URL
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 16),
                Text('Do you want to leave the app?'),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), // Stay on the app
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Exit the app
                      SystemChannels.platform
                          .invokeMethod<void>('SystemNavigator.pop');
                    },
                    child: Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        ) ??
        false; // If the dialog is dismissed, stay on the app
  }

  @override
  Widget build(BuildContext context) {
    // print("statedddddddddddddddddd:${_lineChartWid.messageStream}");
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: true,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Press',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 25, 152, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          children: [
                            TextSpan(
                              text: 'Data', // Adding the trademark symbol here
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '®', // Registered trademark symbol
                        style: TextStyle(
                          color: Colors.red, // Red color
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            ' Medical Gas Alarm + Analyser ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
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
          body: internetchecker
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
                              // Show dialog when the button is presse
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Select Mode',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(
                                                228, 100, 128, 100),
                                            elevation: 5,
                                            shadowColor:
                                                Colors.black.withOpacity(0.5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              side: BorderSide(
                                                  color: Colors.black87),
                                            ),
                                            minimumSize: Size(150, 50),
                                          ),
                                          onPressed: () async {
                                            MqttService mqttService =
                                                MqttService();

                                            // Connect to MQTT
                                            bool isConnected = await mqttService
                                                .connect(context);

                                            if (isConnected) {
                                              checker = true;
                                              internetchecker = true;

                                              // Call subscribeToTopic1 with the serial number and context
                                              // Replace with actual serial number
                                              //  mqttService.subscribeToTopic1(
                                              //    serialNo, context);
                                              // mqttService.subscribeTotoppic2(
                                              //     serialNo, context);
                                              // Listen to the MQTT message stream

                                              // Update the chart widget
                                              setState(() {
                                                _lineChartWid =
                                                    LineCharWid_mqtt(
                                                  Login_state:
                                                      "Internet Device",
                                                  mqqtservice: mqttService,
                                                  // messageStream_para1:
                                                  //     mqttService
                                                  //         .messageStream_para1,
                                                );
                                              });
                                            } else {
                                              // Show an error message if not connected
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Failed to connect to MQTT")),
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Internet',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(
                                                228, 100, 128, 100),
                                            elevation: 5, // Add shadow
                                            shadowColor:
                                                Colors.black.withOpacity(0.5),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              side: BorderSide(
                                                  color: Colors
                                                      .black87), // Add border
                                            ),
                                            minimumSize: Size(150, 50),
                                          ),
                                          onPressed: () {
                                            fetchdata();
                                            if (checker == true) {
                                              local_checker = true;
                                              _lineChartWid_local =
                                                  LineCharWid();
                                            } else {
                                              print(
                                                  " Local Device not connected please connect to Wifi!!");
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Local Device',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.wifi_protected_setup,
                                  size: 30,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ), // Choose an appropriate icon
                                SizedBox(
                                    width:
                                        5), // Add some space between the icon and the text
                                const Text(
                                  'Connect',
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
                )
          // : Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         AnimatedBuilder(
          //           animation: _animation,
          //           builder: (context, child) {
          //             return Transform.scale(
          //               scale: _animation.value,
          //               child: Icon(
          //                 Icons.wifi_off,
          //                 size: 100,
          //               ),
          //             );
          //           },
          //         ),
          //         SizedBox(height: 10),
          //         Text(
          //           "Device is not connected",
          //           style: TextStyle(fontSize: 30),
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 padding: EdgeInsets.symmetric(horizontal: 12.0),
          //                 shape: RoundedRectangleBorder(
          //                   side: BorderSide(
          //                     style: BorderStyle.solid,
          //                     color: Colors.black87,
          //                   ),
          //                   borderRadius: BorderRadius.circular(
          //                       5), // Square corners
          //                 ),
          //                 minimumSize: Size(190,
          //                     50), // Set minimum size to maintain height
          //                 backgroundColor:
          //                     Color.fromRGBO(228, 100, 128, 100),
          //               ),
          //               onPressed: () async {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => const DemoWid()),
          //                 );
          //               },
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   Icon(Icons.play_circle_filled,
          //                       size: 30,
          //                       color: Color.fromARGB(255, 0, 0, 0)),
          //                   // Replace with the desired icon
          //                   SizedBox(
          //                       width:
          //                           8), // Add some space between the icon and the text
          //                   const Text(
          //                     'Demo Mode',
          //                     style: TextStyle(
          //                       fontSize: 25,
          //                       color: Color.fromARGB(255, 255, 255, 255),
          //                       shadows: [
          //                         Shadow(
          //                           blurRadius: 4,
          //                           color: Colors.grey,
          //                           offset: Offset(2, 1.5),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 padding: EdgeInsets.symmetric(horizontal: 12.0),
          //                 shape: RoundedRectangleBorder(
          //                   side: BorderSide(
          //                     style: BorderStyle.solid,
          //                     color: Colors.black87,
          //                   ),
          //                   borderRadius: BorderRadius.circular(
          //                       5), // Square corners
          //                 ),
          //                 minimumSize: Size(190,
          //                     50), // Set minimum size to maintain height
          //                 backgroundColor:
          //                     Color.fromRGBO(228, 100, 128, 100),
          //               ),
          //               onPressed: () async {
          //                 // Show dialog when the button is pressed
          //                 showDialog(
          //                   context: context,
          //                   builder: (BuildContext context) {
          //                     return Dialog(
          //                       shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(20),
          //                       ),
          //                       child: Container(
          //                         padding: EdgeInsets.all(20),
          //                         decoration: BoxDecoration(
          //                           color: Colors.grey[300],
          //                           borderRadius:
          //                               BorderRadius.circular(20),
          //                         ),
          //                         child: Column(
          //                           mainAxisSize: MainAxisSize.min,
          //                           children: [
          //                             Text(
          //                               'Select Mode',
          //                               style: TextStyle(
          //                                 fontSize: 24,
          //                                 fontWeight: FontWeight.bold,
          //                               ),
          //                             ),
          //                             SizedBox(height: 20),
          //                             ElevatedButton(
          //                               style: ElevatedButton.styleFrom(
          //                                 backgroundColor: Color.fromRGBO(
          //                                     228, 100, 128, 100),
          //                                 elevation: 5, // Add shadow
          //                                 shadowColor: Colors.black
          //                                     .withOpacity(0.5),
          //                                 shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                       BorderRadius.circular(
          //                                           30.0),
          //                                   side: BorderSide(
          //                                       color: Colors
          //                                           .black87), // Add border
          //                                 ),
          //                                 minimumSize: Size(150, 50),
          //                               ),
          //                               onPressed: () async {
          //                                 MqttService mqttService =
          //                                     MqttService();
          //                                 bool isConnected =
          //                                     await mqttService.connect();

          //                                 if (isConnected) {
          //                                   // Navigate to the data display page only once
          //                                   checker = true;
          //                                   internetchecker = true;
          //                                   mqttService.messageStream
          //                                       .listen((message) {
          //                                     // Parse the received JSON message
          //                                     final Map<String, dynamic>
          //                                         jsonData =
          //                                         jsonDecode(message);

          //                                     // Create PressData object from the JSON
          //                                     PressData pressData =
          //                                         PressData.fromJson(
          //                                             jsonData);

          //                                     // Navigate to the display page and pass the pressData
          //                                     _lineChartWid = LineCharWid(
          //                                       Login_state:
          //                                           "Internet_device",
          //                                       messageStream: mqttService
          //                                           .messageStream,
          //                                     );
          //                                   });
          //                                 } else {
          //                                   // Show snackbar that connection failed
          //                                   if (mounted) {
          //                                     ScaffoldMessenger.of(
          //                                             context)
          //                                         .showSnackBar(
          //                                       SnackBar(
          //                                           content: Text(
          //                                               'Not connected to the internet')),
          //                                     );
          //                                   }
          //                                 }
          //                                 // Handle Internet button press
          //                                 // Navigator.push(
          //                                 //     context,
          //                                 //     MaterialPageRoute(
          //                                 //         builder: (context) =>
          //                                 //             Login()));
          //                                 Navigator.of(context).pop();
          //                               },
          //                               child: Text(
          //                                 'Internet',
          //                                 style: TextStyle(
          //                                     fontSize: 20,
          //                                     color: Colors.white),
          //                               ),
          //                             ),
          //                             SizedBox(height: 20),
          //                             ElevatedButton(
          //                               style: ElevatedButton.styleFrom(
          //                                 backgroundColor: Color.fromRGBO(
          //                                     228, 100, 128, 100),
          //                                 elevation: 5, // Add shadow
          //                                 shadowColor: Colors.black
          //                                     .withOpacity(0.5),
          //                                 shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                       BorderRadius.circular(
          //                                           30.0),
          //                                   side: BorderSide(
          //                                       color: Colors
          //                                           .black87), // Add border
          //                                 ),
          //                                 minimumSize: Size(150, 50),
          //                               ),
          //                               onPressed: () {
          //                                 fetchdata();
          //                                 if (checker == true) {
          //                                   local_checker = true;
          //                                 } else {
          //                                   print(
          //                                       " Local Device not connected please connect to Wifi!!");
          //                                 }
          //                               },
          //                               child: Text(
          //                                 'Local Device',
          //                                 style: TextStyle(
          //                                     fontSize: 20,
          //                                     color: Colors.white),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     );
          //                   },
          //                 );
          //               },
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   Icon(
          //                     Icons.wifi_protected_setup,
          //                     size: 30,
          //                     color: Color.fromARGB(255, 0, 0, 0),
          //                   ), // Choose an appropriate icon
          //                   SizedBox(
          //                       width:
          //                           5), // Add some space between the icon and the text
          //                   const Text(
          //                     'Connect',
          //                     style: TextStyle(
          //                       fontSize: 25,
          //                       color: Color.fromARGB(255, 255, 255, 255),
          //                       shadows: [
          //                         Shadow(
          //                           blurRadius: 4,
          //                           color: Colors.grey,
          //                           offset: Offset(2, 1.5),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             ElevatedButton(
          //               style: ElevatedButton.styleFrom(
          //                 padding: EdgeInsets.symmetric(horizontal: 12.0),
          //                 shape: RoundedRectangleBorder(
          //                   side: BorderSide(
          //                     style: BorderStyle.solid,
          //                     color: Colors.black87,
          //                   ),
          //                   borderRadius: BorderRadius.circular(
          //                       5), // Square corners
          //                 ),
          //                 minimumSize: Size(190,
          //                     50), // Set minimum size to maintain height
          //                 backgroundColor:
          //                     Color.fromRGBO(228, 100, 128, 100),
          //               ),
          //               onPressed: () async {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) =>
          //                           const ReportScreenPast()),
          //                 );
          //               },
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.min,
          //                 children: [
          //                   Icon(Icons.insert_chart,
          //                       size: 30,
          //                       color: Color.fromARGB(255, 0, 0,
          //                           0)), // Choose an appropriate icon
          //                   SizedBox(
          //                       width:
          //                           5), // Add some space between the icon and the text
          //                   const Text(
          //                     'Reports',
          //                     style: TextStyle(
          //                       fontSize: 25,
          //                       color: Color.fromARGB(255, 255, 255, 255),
          //                       shadows: [
          //                         Shadow(
          //                           blurRadius: 4,
          //                           color: Colors.grey,
          //                           offset: Offset(2, 1.5),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          ),
    );
  }
}
