import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageData {
  Future<void> saveJsonData(Map<String, dynamic> jsonData) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing data
    String? savedData = prefs.getString('jsonData');
    List<Map<String, dynamic>> entries = savedData != null
        ? List<Map<String, dynamic>>.from(json
            .decode(savedData)
            .map((item) => Map<String, dynamic>.from(item)))
        : [];

    // Add new entry
    entries.add(jsonData);
    debugPrint('Entries: $entries');

    // Save updated list
    await prefs.setString('jsonData', jsonEncode(entries));
  }

  Future<List<HomePageModel>> getJsonData() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('jsonData');

    if (savedData != null) {
      List<Map<String, dynamic>> entries = List<Map<String, dynamic>>.from(json
          .decode(savedData)
          .map((item) => Map<String, dynamic>.from(item)));

      return entries.map((entry) => HomePageModel.fromMap(entry)).toList();
    } else {
      return [];
    }
  }
}

class HomePageModel {
  final String? name;
  final int? age;

  HomePageModel(this.name, this.age);

  HomePageModel copyWith({String? name, int? age}) {
    return HomePageModel(name ?? this.name, age ?? this.age);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
    };
  }

  factory HomePageModel.fromMap(Map<String, dynamic> map) {
    return HomePageModel(
      map['name'],
      map['age'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HomePageModel.fromJson(String source) =>
      HomePageModel.fromMap(json.decode(source));

  @override
  String toString() => 'HomePageModel(name: $name, age: $age)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomePageModel && other.name == name && other.age == age;
  }

  @override
  int get hashCode => name.hashCode ^ age.hashCode;
}
