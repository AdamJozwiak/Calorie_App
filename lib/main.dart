import 'package:call_app/pages/consumed.dart';
import 'package:call_app/pages/loggingWrapper.dart';
import 'package:call_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:call_app/pages/home.dart';
import 'package:call_app/services/calorie_api.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(CalorieApp());
}

class CalorieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        routes: {
          '/': (context) => Home(),
          '/home': (context) => Home(),
          '/loading': (context) => Api(),
          '/consumed': (context) => Consumed(),
        },
      ),
    );
  }
}
