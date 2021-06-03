import 'package:call_app/shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RadialProgress extends StatefulWidget {
  final bool differentDate;
  final List<double> calories;
  final List<double> fats;
  final List<double> proteins;
  final List<double> recommendedDailyIntake;
  RadialProgress(
      {Key key,
      @required this.differentDate,
      @required this.calories,
      @required this.fats,
      @required this.proteins,
      @required this.recommendedDailyIntake})
      : super(key: key);
  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress> {
  List<double> _percentage;
  List<Color> progressColors;

  @override
  void initState() {
    super.initState();
    _percentage = new List<double>(3);
    progressColors = new List<Color>(3);
  }

  @override
  Widget build(BuildContext context) {
    double displayedCalories =
        widget.differentDate ? widget.calories[1] : widget.calories[0];
    double displayedFats =
        widget.differentDate ? widget.fats[1] : widget.fats[0];
    double displayedProteins =
        widget.differentDate ? widget.proteins[1] : widget.proteins[0];

    progressColors[0] = displayedFats < widget.recommendedDailyIntake[1]
        ? Colors.yellow[700]
        : Colors.red;
    progressColors[1] = displayedCalories < widget.recommendedDailyIntake[0]
        ? Colors.green[400]
        : Colors.red;
    progressColors[2] = displayedProteins < widget.recommendedDailyIntake[2]
        ? Colors.blue[600]
        : Colors.red;

    _percentage[0] = calculateCaloriePercentage(displayedCalories);
    _percentage[1] = calculateFatsPercentage(displayedFats);
    _percentage[2] = calculateProteinPercentage(displayedProteins);

    _percentage.forEach((element) {
      if (element >= 1.0) {
        element = 1.0;
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 40.0, 7.0, 0.0),
          child: InkResponse(
            child: CircularPercentIndicator(
              radius: 70.0,
              lineWidth: 5.0,
              percent: _percentage[1],
              center: Padding(
                padding: const EdgeInsets.symmetric(vertical: 23.0),
                child: Column(
                  children: [
                    new Text(
                      displayedFats.toStringAsFixed(1) + 'g',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    new Text(
                      'fats',
                      style: new TextStyle(fontSize: 9.0),
                    ),
                  ],
                ),
              ),
              circularStrokeCap: CircularStrokeCap.butt,
              backgroundColor: Colors.white12,
              progressColor: progressColors[0],
              startAngle: 270.0,
            ),
            onTap: () {
              showAlert(context, 'Change recommended fats', 'Tluszcze');
            },
            highlightShape: BoxShape.circle,
            radius: 30.0,
          ),
        ),
        InkResponse(
          child: CircularPercentIndicator(
            radius: 110.0,
            lineWidth: 10.0,
            percent: _percentage[0],
            center: Padding(
              padding: const EdgeInsets.symmetric(vertical: 35.0),
              child: Column(
                children: [
                  new Text(
                    displayedCalories.toStringAsFixed(1),
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25.0),
                  ),
                  new Text(
                    'kcal',
                    style: new TextStyle(fontSize: 15.0),
                  ),
                ],
              ),
            ),
            circularStrokeCap: CircularStrokeCap.butt,
            backgroundColor: Colors.white12,
            progressColor: progressColors[1],
            startAngle: 270.0,
          ),
          onTap: () {
            showAlert(context, 'Change recommended calories', 'Kalorie');
          },
          highlightShape: BoxShape.circle,
          radius: 45.0,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(7.0, 40.0, 0.0, 0.0),
          child: InkResponse(
            child: CircularPercentIndicator(
              radius: 70.0,
              lineWidth: 5.0,
              percent: _percentage[2],
              center: Padding(
                padding: const EdgeInsets.symmetric(vertical: 23.0),
                child: Column(
                  children: [
                    new Text(
                      displayedProteins.toStringAsFixed(1) + 'g',
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    new Text(
                      'proteins',
                      style: new TextStyle(fontSize: 9.0),
                    ),
                  ],
                ),
              ),
              circularStrokeCap: CircularStrokeCap.butt,
              backgroundColor: Colors.white12,
              progressColor: progressColors[2],
              startAngle: 270.0,
            ),
            onTap: () {
              showAlert(context, 'Change recommended proteins', 'Proteiny');
            },
            highlightShape: BoxShape.circle,
            radius: 30.0,
          ),
        ),
      ],
    );
  }

  double calculateCaloriePercentage(double caloriesConsumed) {
    return caloriesConsumed / (2 * widget.recommendedDailyIntake[0]);
  }

  double calculateFatsPercentage(double fatsConsumed) {
    return fatsConsumed / (2 * widget.recommendedDailyIntake[1]);
  }

  double calculateProteinPercentage(double proteinsConsumed) {
    return proteinsConsumed / (2 * widget.recommendedDailyIntake[2]);
  }
}
