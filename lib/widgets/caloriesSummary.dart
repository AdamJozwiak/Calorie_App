import 'package:flutter/material.dart';

class CaloriesSummary extends StatelessWidget {
  final String calories;
  final String differentDateCalories;
  final bool differentDate;
  CaloriesSummary(
      {this.differentDate, this.calories, this.differentDateCalories});
  @override
  Widget build(BuildContext context) {
    if (!differentDate) {
      return Center(
        child: Container(
          child: Text('Calories consumed : ' + calories),
        ),
      );
    } else {
      return Center(
        child: Container(
          child: Text('Calories consumed : ' + differentDateCalories),
        ),
      );
    }
  }
}
