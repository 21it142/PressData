import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pressdata/main.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String date = '';

  @override
  void initState() {
    super.initState();
    date = DateFormat('dd-MM-yyyy  HH:mm').format(DateTime.now());
    Timer.periodic(const Duration(seconds: 5), (timer) {
      date = DateFormat('dd-MM-yyyy  HH:mm').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: true,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "",
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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Username (Email) Field
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Enter your email',
                    ),
                  ),
                  SizedBox(height: 20),

                  // Password Field
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Enter your password',
                    ),
                  ),
                  SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: 100, // Make the button stretch to full width
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor:
                            Color.fromRGBO(228, 100, 128, 100), // Button color
                      ),
                      onPressed: () async {
                        // Instantiate your MqttService class
                        // Instantiate your MqttService class
                        // MqttService mqttService = MqttService();

                        // // Handle MQTT connection when the button is pressed
                        // await mqttService.connect();
                        state = true;
                        // Navigate to the data display page only once
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DataDisplayPage(
                        //         messageStream:C),
                        //   ),
                        // );

                        Navigator.of(context).pop();
                        print('Login button pressed and MQTT connected');
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.grey,
                              offset: Offset(2, 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
