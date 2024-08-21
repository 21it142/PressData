import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final VoidCallback onReturn;

  CustomNavigatorObserver({required this.onReturn});

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    onReturn();
  }
}
