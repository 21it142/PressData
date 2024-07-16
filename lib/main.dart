import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/screens/register.dart';
import 'package:pressdata/screens/splash_scree.dart';
import 'package:pressdata/widgets/home_page.dart';

//import 'package:pressdata/screens/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setPreferredOrientations(
       [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: RegistrationScreen());
  }
}

