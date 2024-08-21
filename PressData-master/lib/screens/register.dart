import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pressdata/screens/main_page.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({super.key});

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
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    print("hellooooooooooooo");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    print(isFirstRun);

    if (!isFirstRun) {
      _navigateToMainPage();
    }
  }

  Future<void> _setFirstRunComplete() async {
    print("hellooooooooooooo");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstRun', false);
  }

  Future<void> _saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('hospitalCompany', _hospitalCompanyController.text);
    await prefs.setString('city', _cityController.text);
    await prefs.setString('contactNumber', _contactNumberController.text);
    await prefs.setString('email', _emailController.text);
  }

  void _navigateToMainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Dashboard(),
      ),
    );
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
                style: TextStyle(
                    color: Color.fromRGBO(0, 25, 152, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                children: [
                  TextSpan(
                    text: 'Data',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 10,
            ),
            const Text(
              'User Detail',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.20,
              height: 10,
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(228, 100, 128, 100),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Name of the user',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildTextField(
                  controller: _hospitalCompanyController,
                  label: 'Hospital/Company',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your hospital or company';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildTextField(
                  controller: _cityController,
                  label: 'City',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildTextField(
                  controller: _contactNumberController,
                  label: 'Contact Number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email ID',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await _setFirstRunComplete();
                        await _saveFormData();
                        _navigateToMainPage();
                        // Perform form submission

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Form Sbmitted")),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      height: 40,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          border: OutlineInputBorder(),
          suffixIcon: validator != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : null,
        ),
        validator: validator,
        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }
}
