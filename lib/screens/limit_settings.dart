import 'package:flutter/material.dart';

class LimitSettings extends StatefulWidget {
  LimitSettings({super.key, required this.title});
  String title;
  @override
  State<LimitSettings> createState() => _LimitSettingsState();
}

class _LimitSettingsState extends State<LimitSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title + "Limit Settings"),
      ),
    );
  }
}
