import 'package:call_app/models/food.dart';
import 'package:call_app/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';

String getCurrentDate() {
  var date = new DateTime.now().toString();
  var parsedDate = DateTime.parse(date);
  return '${parsedDate.day}${parsedDate.month}${parsedDate.year}';
}

String getDate(DateTime date) {
  var parsedDate = DateTime.parse(date.toString());
  return '${parsedDate.day}${parsedDate.month}${parsedDate.year}';
}

double countCalories(List<Food> foodConsumed) {
  double calories = 0.0;
  foodConsumed.forEach((element) {
    calories += element.kcal * element.amount;
  });
  return calories;
}

double countFats(List<Food> foodConsumed) {
  double fats = 0.0;
  foodConsumed.forEach((element) {
    fats += element.fat * element.amount;
  });
  return fats;
}

double countProteins(List<Food> foodConsumed) {
  double proteins = 0.0;
  foodConsumed.forEach((element) {
    proteins += element.protein * element.amount;
  });
  return proteins;
}

Future<void> showAlert(BuildContext context, String title, String contents,
    AlertType alertType) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Alert(
          alertType: alertType,
          title: title,
          contents: contents,
        );
      });
}
