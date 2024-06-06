import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationScreen(),
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            RichText(
              text: const  TextSpan(
                  text: 'Press',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                  children: [
                    TextSpan(
                      text: 'Data',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]),
            ),
         const    SizedBox(
              width: 200,
              height: 10,
            ),
         const    Text(
              'User Detail',
              style: TextStyle(color: Colors.black),
            ),
          const   SizedBox(
              width: 200,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          labelText: 'Name of the user',
                        ),
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
                      TextFormField(
                        controller: _hospitalCompanyController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          labelText: 'Hospital/Company',
                        ),
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
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          labelText: 'City',
                        ),
                      ),
                      TextFormField(
                        controller: _contactNumberController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          labelText: 'Contact Number',
                        ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          labelText: 'Email ID',
                        ),
                      ),
                      SizedBox(height: 20),
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
      ),
    );
  }
}
