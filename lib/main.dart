import 'package:call_app/models/user.dart';
import 'package:call_app/pages/consumed.dart';
import 'package:call_app/pages/loggingWrapper.dart';
import 'package:call_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:call_app/pages/home.dart';
import 'package:call_app/services/api.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(CalorieApp());
}

class CalorieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        routes: {
          '/': (context) => Wrapper(),
          '/home': (context) => Home(),
          '/loading': (context) => Api(),
          '/consumed': (context) => Consumed(),
        },
      ),
    );
  }
}
