import 'package:call_app/models/food.dart';
import 'package:call_app/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

String getCurrentDate() {
  var date = new DateTime.now().toString();
  var parsedDate = DateTime.parse(date);
  var formattedDate = '${parsedDate.day}${parsedDate.month}${parsedDate.year}';

  return formattedDate;
}

double countCalories(List<Food> foodConsumed) {
  double calories = 0.0;
  foodConsumed.forEach((element) {
    calories += element.kcal * element.amount;
  });
  return calories;
}

Future<void> showAlert(
    BuildContext context, String title, String contents) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Alert(title, contents);
      });
}
