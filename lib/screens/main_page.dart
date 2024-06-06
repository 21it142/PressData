import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/widgets/linechart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

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
      body: const LineCharWid(),
    );
  }
}
