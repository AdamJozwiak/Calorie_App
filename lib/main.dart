import 'package:call_app/pages/consumed.dart';
import 'package:flutter/material.dart';
import 'package:call_app/pages/home.dart';
import 'package:call_app/services/calorie_api.dart';

void main() {
  runApp(CalorieApp());
}

class CalorieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      routes: {
        '/': (context) => Home(),
        '/loading': (context) => Api(),
        '/consumed': (context) => Consumed(),
      },
    );
  }
}


