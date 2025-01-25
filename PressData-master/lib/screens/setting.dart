import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EditRegistrationScreen extends StatefulWidget {
  @override
  _EditRegistrationScreenState createState() => _EditRegistrationScreenState();
}

class _EditRegistrationScreenState extends State<EditRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hospitalCompanyController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController(text: '+91');
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _hospitalCompanyController.text = prefs.getString('hospitalCompany') ?? '';
    _cityController.text = prefs.getString('city') ?? '';
    _contactNumberController.text = prefs.getString('contactNumber') ?? '+91';
    _emailController.text = prefs.getString('email') ?? '';
  }

  Future<void> _saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('hospitalCompany', _hospitalCompanyController.text);
    await prefs.setString('city', _cityController.text);
    await prefs.setString('contactNumber', _contactNumberController.text);
    await prefs.setString('email', _emailController.text);
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _saveFormData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details updated successfully!')),
      );
      _toggleEditMode(); // Disable editing after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(228, 100, 128, 100),
        leading: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 20,
              ),
            ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        toolbarHeight: 30,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            //  mainAxisSize: MainAxisSize.min, // Adjusts to fit the content
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: 'Name of the User',
                            isRequired: true,
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            controller: _hospitalCompanyController,
                            label: 'Hospital/Company',
                            isRequired: true,
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            controller: _cityController,
                            label: 'City',
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            controller: _contactNumberController,
                            label: 'Contact Number',
                            keyboardType: TextInputType.phone,
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 10),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email ID',
                            keyboardType: TextInputType.emailAddress,
                            enabled: _isEditing,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage('assets/Wavevison-Logo.png'),
                    ),
                    Image(
                      height: 150,
                      image: AssetImage('assets/PressData.png'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Press', // First part of the text
                            style: TextStyle(
                              color:
                                  Color.fromRGBO(0, 25, 152, 1), // Blue color
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                            children: [
                              TextSpan(
                                text: 'Data', // Second part of the text
                                style: TextStyle(
                                  color: Colors.red, // Red color
                                  fontSize: 30,
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Medical Gas Alarm + Analyzer',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    // Logo
                    //   SizedBox(height: 20),
                    // Privacy Policy Link
                    InkWell(
                      onTap: () async {
                        final Uri url = Uri.parse(
                            'https://wavevisions.in/PressData/Privacy-Policy');
                        if (!await launchUrl(url,
                            mode: LaunchMode.externalApplication)) {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ), // Pushes the button to the bottom of the screen
              Align(
                alignment: Alignment.bottomCenter,
                child: _isEditing
                    ? ElevatedButton.icon(
                        onPressed: _submitForm,
                        icon: Icon(Icons.save),
                        label: Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Color.fromRGBO(
                              228, 100, 128, 100), // Custom color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: _toggleEditMode,
                        icon: Icon(Icons.edit),
                        label: Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Container(
      height: 50,
      child: TextFormField(
        cursorColor: Color.fromRGBO(228, 100, 128, 100),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          labelText: label,
          labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.612)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide:
                BorderSide(color: Color.fromRGBO(0, 0, 0, 0.612), width: 0.0),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(0, 0, 0, 0.612))),
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  _showSnackbar('Please enter $label');
                  return '';
                }
                return null;
              }
            : null,
        enabled: enabled,
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
