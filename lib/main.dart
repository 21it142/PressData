import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/screens/main_page.dart';
import 'package:pressdata/screens/report_screen.dart';
import 'package:pressdata/screens/setting.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReportScreen(),
    );
  }
}
