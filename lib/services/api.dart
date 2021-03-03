import 'dart:convert';
import 'dart:io';
import 'package:call_app/models/food.dart';
import 'package:call_app/shared/appExceptions.dart';
import 'package:call_app/shared/functions.dart';
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
    Map data = Map();
    Food extractedData;
    try {
      Response response = await get(
          'https://api.edamam.com/api/food-database/v2/parser?ingr=${foodName}&app_id=${_APP_ID}&app_key=${_APP_KEY}');
      data = _returnResponse(response);
      List parsed = data['parsed'];
      if (parsed.isNotEmpty) {
        extractedData = Food(
          name: data['text'],
          imageUrl: data['parsed'][0]['food']['image'],
          kcal: data['parsed'][0]['food']['nutrients']['ENERC_KCAL'],
          fat: data['parsed'][0]['food']['nutrients']['FAT'],
          amount: 1,
        );
      } else {
        Navigator.pop(context);
        showAlert(context, 'Wrong food name',
            'I am sorry, but I did not understand. Could you reapeat?');
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    Navigator.pop(context, extractedData);
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    this.foodName = ModalRoute.of(context).settings.arguments;
    getFoodInfo();
    return Loading();
  }
}
