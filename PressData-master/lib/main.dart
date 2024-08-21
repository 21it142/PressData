import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/screens/splash_scree.dart';
import 'package:keep_screen_on/keep_screen_on.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KeepScreenOn.turnOn();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  final RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    // Remove or comment out this section to stop simulating a crash
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FlutterError.reportError(FlutterErrorDetails(
    //     exception: Exception("Intentional crash for testing purposes."),
    //     stack: StackTrace.current,
    //     library: 'MyApp',
    //     context: ErrorDescription('During MyApp build'),
    //   ));
    // });

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [_routeObserver],
        home: SplashScreen());
  }
}
