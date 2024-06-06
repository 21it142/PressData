import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressdata/screens/limit_settings.dart';
import 'package:pressdata/screens/setting.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Setting1()

        //RegistrationScreen(), //LimitSettings(
        //     title: "O2",
        //     card_color: Colors.white,
        //     subtitle: "(PSI)",
        //   ),
        );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hospitalCompanyController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool get _isSubmitButtonEnabled {
    return _nameController.text.isNotEmpty &&
        _hospitalCompanyController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            RichText(
              text: const TextSpan(
                  text: 'Press',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                  children: [
                    TextSpan(
                      text: 'Data',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 10,
            ),
            const Text(
              'User Detail',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Demo Mode',
                style: TextStyle(fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(231, 223, 223, 100),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        // child: Form(
        //   key: _formKey,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: <Widget>[
        //       TextFormField(
        //         decoration: const InputDecoration(
        //           contentPadding: EdgeInsets.all(0),
        //           icon: const Icon(Icons.person),
        //           hintText: 'Enter your name',
        //           labelText: 'Name',
        //         ),
        //       ),
        //       TextFormField(
        //         decoration: const InputDecoration(
        //           contentPadding: EdgeInsets.all(0),
        //           icon: const Icon(Icons.phone),
        //           hintText: 'Enter a phone number',
        //           labelText: 'Phone',
        //         ),
        //       ),
        //       TextFormField(
        //         decoration: const InputDecoration(
        //           contentPadding: EdgeInsets.all(0),
        //           icon: const Icon(Icons.calendar_today),
        //           hintText: 'Enter your date of birth',
        //           labelText: 'Dob',
        //         ),
        //       ),
        //       TextFormField(
        //         decoration: const InputDecoration(
        //           contentPadding: EdgeInsets.all(0),
        //           icon: const Icon(Icons.calendar_today),
        //           hintText: 'Enter your date of birth',
        //           labelText: 'Dob',
        //         ),
        //       ),
        //       TextFormField(
        //         decoration: const InputDecoration(
        //           contentPadding: EdgeInsets.all(0),
        //           icon: const Icon(Icons.calendar_today),
        //           hintText: 'Enter your date of birth',
        //           labelText: 'Dob',
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        child: Form(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            labelText: '  Name of the user',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      height: 40,
                      child: TextFormField(
                        controller: _hospitalCompanyController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            labelText: 'Hospital/Company',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your hospital or company';
                          }
                          return null;
                        },
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      height: 40,
                      child: TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            labelText: 'City',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      height: 40,
                      child: TextFormField(
                        controller: _contactNumberController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            labelText: 'Contact Number',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            labelText: 'Email ID',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    if (_isSubmitButtonEnabled)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Perform form submission
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Form submitted')),
                              );
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
