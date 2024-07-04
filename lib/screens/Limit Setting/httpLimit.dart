import 'dart:convert';
import 'package:http/http.dart' as http;

class LimitSetting {
  final String url = 'http://192.168.4.1/MinMax1';
  final String url1 = 'http://192.168.4.1/MinMax2';
  final String postUrl = 'http://192.168.4.1/MinMax3';

  static Future<http.Response> httpObject(String url) async {
    return await http.get(Uri.parse(url));
  }

  Future<List<dynamic>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        print('Fetched data: $jsonData'); // Log fetched data
        return jsonData;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return [];
      }
    } catch (err) {
      print('Error fetching data: $err');
      return [];
    }
  }

  Future<List<dynamic>> getData() async {
    try {
      final response = await http.get(Uri.parse(url1));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        print('Fetched data: $jsonData'); // Log fetched data
        return jsonData;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return [];
      }
    } catch (err) {
      print('Error fetching data: $err');
      return [];
    }
  }

  Future<bool> updateData(String type, double min, double max) async {
    final updatedData = {
      'type': type,
      'MIN': min,
      'MAX': max,
    };

    print('Updating data with: $updatedData'); // Log data to be sent

    try {
      final response = await http.post(
        Uri.parse(postUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        print('Data updated successfully');
        return true;
      } else {
        print('Failed to update data: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (err) {
      print('Error updating data: $err');
      return false;
    }
  }
}
