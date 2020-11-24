import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Api extends StatefulWidget {
  @override
  _ApiState createState() => _ApiState();
}

class _ApiState extends State<Api> {
  String APP_ID = '82b65b31';
  String APP_KEY = 'a3f88b680a73f38bc741e86157d7c378';
  String foodName = '';

  void getFoodInfo() async
  {
    Response response =
    await get('https://api.edamam.com/api/food-database/v2/parser?ingr=${foodName}&app_id=${APP_ID}&app_key=${APP_KEY}');
    Map data = jsonDecode(response.body);

    Map extractedData = {
      'image': data['parsed'][0]['food']['image'],
      'name': data['text'],
      'kcal': data['parsed'][0]['food']['nutrients']['ENERC_KCAL'],
      'fat': data['parsed'][0]['food']['nutrients']['FAT'],
      'amount': 1,
    };

    Navigator.pop(context, extractedData);
  }

  @override
  Widget build(BuildContext context) {
    this.foodName = ModalRoute.of(context).settings.arguments;
    getFoodInfo();
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: Center(
        child: SpinKitDualRing(
          color: Colors.green[600],
          size: 120.0,
        ),
      ),
    );
  }
}
