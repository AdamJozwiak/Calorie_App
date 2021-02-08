import 'dart:convert';
import 'package:call_app/models/food.dart';
import 'package:call_app/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Api extends StatefulWidget {
  @override
  _ApiState createState() => _ApiState();
}

class _ApiState extends State<Api> {
  String _APP_ID = '82b65b31';
  String _APP_KEY = 'a3f88b680a73f38bc741e86157d7c378';
  String foodName = '';

  void getFoodInfo() async {
    Response response = await get(
        'https://api.edamam.com/api/food-database/v2/parser?ingr=${foodName}&app_id=${_APP_ID}&app_key=${_APP_KEY}');
    Map data = jsonDecode(response.body);

    Food extractedData = Food(
      name: data['text'],
      imageUrl: data['parsed'][0]['food']['image'],
      kcal: data['parsed'][0]['food']['nutrients']['ENERC_KCAL'],
      fat: data['parsed'][0]['food']['nutrients']['FAT'],
      amount: 1,
    );

    Navigator.pop(context, extractedData);
  }

  @override
  Widget build(BuildContext context) {
    this.foodName = ModalRoute.of(context).settings.arguments;
    getFoodInfo();
    return Loading();
  }
}
