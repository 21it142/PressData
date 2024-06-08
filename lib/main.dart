import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/screens/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(MyApp(
    m: 0,
    mi: 0,
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key, required this.m, required this.mi});
  int m;
  int mi;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(
        maxLlimit: m,
        minLlimit: mi,
      ),
    );
  }
}
