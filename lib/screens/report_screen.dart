import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  void generatePDF() async {
    // Generate PDF report based on selected data
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text('Report for $selectedOption',
                    style: pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 20),
                pw.Text('Selected Gases:', style: pw.TextStyle(fontSize: 16)),
                for (var gas in _selectedItems) pw.Text(gas),
              ],
            ),
          );
        },
      ),
    );
// Save PDF to local storage
    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/example.pdf';
    final file = File(filePath);

    final pdfBytes = await pdf.save();
    await file.writeAsBytes(pdfBytes);
    OpenFile.open(filePath);
    // Show a message to indicate the file is saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to $filePath')),
    );
    // Save PDF or display it
    // For simplicity, saving it to local storage
    // You can use plugins like path_provider to get the directory

    // For example, you can save it to a file like this:
    // File('example.pdf').writeAsBytesSync(output);
  }

  List<String> _selectedItems = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = [
      'O2(1)',
      'VAC',
      'NO2',
      'AIR',
      'CO2',
      'O2(2)',
      'TEMP',
      'HUMI'
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 145, 248, 248),
      appBar: AppBar(
        leading:
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_outlined)),
        title: Center(
          child: Text(
            "Report",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 145, 248, 248),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0), // Adjust the height as needed
          child: Container(
            color: Colors.black, // Change this to the desired border color
            height: 4.0, // Height of the bottom border
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // use this button to open the multi-select dialog
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                //backgroundColor: Color.fromRGBO(r, g, b, opacity),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _showMultiSelect,
              child: const Text(
                'Select Report',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            const Divider(
              height: 10,
            ),
            // display selected items
            Wrap(
              children: _selectedItems
                  .map((e) => Chip(
                        label: Text(e),
                      ))
                  .toList(),
            ),

            SizedBox(
              height: 35,
            ),

            DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 300,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                fillColor: Colors.white, // Add outlined border here
                hintText: 'Duration of Report', // Add hint text here
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0), // Adjust padding as needed
              ),
              // Add hint here
              value: selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                });
              },
              items: <String>['Daily', 'Weekly', 'Monthly']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 45,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //backgroundColor: Color.fromRGBO(r, g, b, opacity),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: generatePDF,
                child: Text(
                  "Generate Report",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
