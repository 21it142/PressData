// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pressdata/screens/register.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() {
    WidgetsFlutterBinding.ensureInitialized();
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  String version = '';
  @override
  void initState() {
    super.initState();
    versionget();
  }

  _navigateToHome() async {}

  Future<String> _getAppVersion() async {
    print("Above the app");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("I I am Below the packageInfor : $packageInfo");
    return packageInfo.version;
  }

  versionget() async {
    String fetchedVersion = await _getAppVersion();
    print("version: $fetchedVersion");

    setState(() {
      version = fetchedVersion; // Update state to trigger UI rebuild
    });

    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Company symbol with the uploaded image
            Image.asset(
              'assets/Wavevison-Logo.png',
              height: 70, // Adjust the height as needed
            ),
            SizedBox(height: 10),
            // Company name
            Image.asset(
              'assets/PressData.png',
              height: 170, // Adjust the height as needed
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Press', // First part of the text
                    style: TextStyle(
                      color: Color.fromRGBO(0, 25, 152, 1), // Blue color
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                    children: [
                      TextSpan(
                        text: 'Data', // Second part of the text
                        style: TextStyle(
                          color: Colors.red, // Red color
                          fontSize: 50,
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Medical Gas Alarm + Analyzer',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
//SizedBox(height: 10),
            // Tagline

            SizedBox(height: 5),

            Text(
              "v$version",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
