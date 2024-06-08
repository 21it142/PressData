import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/screens/report_screen.dart';
//import 'package:get/get.dart';
import 'package:pressdata/screens/setting.dart';
import 'package:pressdata/widgets/linechart.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key, required this.maxLlimit, required this.minLlimit});
  int maxLlimit;
  int minLlimit;

  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      appBar: AppBar(
        title: Row(
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
      body: Stack(
        children: [
          LineCharWid(
            maxLimit: widget.maxLlimit,
            minLimit: widget.minLlimit,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 30,
              color: Colors.grey[200], // Background color of the bar
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(
                  //   icon: const Icon(
                  //     Icons.report,
                  //     size: 18, // Icon size
                  //   ),
                  //   onPressed: () {
                  //     // Handle report button press
                  //   },
                  // ),
                  // TextButton(
                  //   style: ButtonStyle(),
                  //   onPressed: () {
                  //     // Handle report button press
                  //   },
                  //   child: const Text(
                  //     'Report',
                  //     style: TextStyle(fontSize: 12),
                  //   ),
                  // ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Square corners
                      ),
                      minimumSize:
                          Size(60, 20), // Set minimum size to maintain height
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReportScreen()));
                    },
                    child: const Text(
                      'Report',
                      style: TextStyle(fontSize: 12, color: Colors.black),
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
                          builder: (context) => Setting1(
                            max: widget.maxLlimit,
                            min: widget.minLlimit,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
