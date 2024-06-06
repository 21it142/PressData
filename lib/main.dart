import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/screens/register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const MyApp());
}
