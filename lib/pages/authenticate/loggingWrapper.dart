import 'package:call_app/models/food.dart';
import 'package:call_app/models/user.dart';
import 'package:call_app/pages/home.dart';
import 'package:call_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //return Home or Authenitcation widget
    if (user == null) {
      return Authenticate();
    } else {
      return MultiProvider(providers: [
        StreamProvider<List<Food>>.value(
            value: DatabaseService(uid: user.uid).foods),
        StreamProvider<List<double>>.value(
            value: DatabaseService(uid: user.uid).intakes)
      ], child: Home());
    }
  }
}
