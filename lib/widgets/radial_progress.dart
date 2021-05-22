import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RadialProgress extends StatefulWidget {
  final bool differentDate;
  final double calories;
  final double recommendedCalories;
  final double differentCalories;
  RadialProgress(
      {Key key,
      @required this.differentDate,
      @required this.calories,
      @required this.differentCalories,
      @required this.recommendedCalories})
      : super(key: key);
  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress> {
  double _percentage;
  @override
  void initState() {
    super.initState();
    _percentage = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    double displayedCalories =
        widget.differentDate ? widget.differentCalories : widget.calories;
    Color progressColor = displayedCalories < widget.recommendedCalories
        ? Colors.green[400]
        : Colors.red;
    _percentage = calculateCaloriePercentage(displayedCalories);
    if (_percentage >= 1.0) {
      _percentage = 1.0;
    }
    return CircularPercentIndicator(
      radius: 100.0,
      lineWidth: 10.0,
      percent: _percentage,
      center: new Text(
        displayedCalories.toString(),
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      circularStrokeCap: CircularStrokeCap.butt,
      backgroundColor: Colors.white12,
      progressColor: progressColor,
      startAngle: 270.0,
    );
  }

  double calculateCaloriePercentage(double caloriesConsumed) {
    return caloriesConsumed / (2 * widget.recommendedCalories);
  }
}
