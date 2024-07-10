// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:pressdata/screens/register.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
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
          children: <Widget>[
            // Company symbol with the uploaded image
            Image.asset(
              'assests/Wavevison-Logo.png',
              height: 100, // Adjust the height as needed
            ),
            SizedBox(height: 20),
            // Company name
            RichText(
              text: const TextSpan(
                text: 'Press ',
                style: TextStyle(
                    color: Color.fromRGBO(0, 25, 152, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 50),
                children: [
                  TextSpan(
                    text: 'Data ',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Tagline
            Text(
              'Medical Gas Alarm + Analyzer',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            // Text(
            //   'by Wave Visions',
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
