import 'package:call_app/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

enum ModifiedNutrition { Calorie, Fat, Protein }

class RadialProgress extends StatefulWidget {
  final bool differentDate;
  final List<double> calories;
  final List<double> fats;
  final List<double> proteins;
  final List<double> recommendedDailyIntake;
  final changeRecommendedIntake;
  RadialProgress(
      {Key key,
      @required this.differentDate,
      @required this.calories,
      @required this.fats,
      @required this.proteins,
      @required this.recommendedDailyIntake,
      this.changeRecommendedIntake})
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
            onTap: () async {
              await changeRecIntake(context, 'Change recommended fats',
                  'Fats (g)', ModifiedNutrition.Fat);
              widget.changeRecommendedIntake(widget.recommendedDailyIntake);
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
          onTap: () async {
            await changeRecIntake(context, 'Change recommended calories',
                'Calories (kcal)', ModifiedNutrition.Calorie);
            widget.changeRecommendedIntake(widget.recommendedDailyIntake);
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
            onTap: () async {
              await changeRecIntake(context, 'Change recommended proteins',
                  'Proteins (g)', ModifiedNutrition.Protein);
              widget.changeRecommendedIntake(widget.recommendedDailyIntake);
            },
            highlightShape: BoxShape.circle,
            radius: 30.0,
          ),
        ),
      ],
    );
  }

  double calculateCaloriePercentage(double caloriesConsumed) {
    double percentage =
        caloriesConsumed / (2 * widget.recommendedDailyIntake[0]);
    if (percentage >= 1.0) {
      percentage = 1.0;
    }
    return percentage;
  }

  double calculateFatsPercentage(double fatsConsumed) {
    double percentage = fatsConsumed / (2 * widget.recommendedDailyIntake[1]);
    if (percentage >= 1.0) {
      percentage = 1.0;
    }
    return percentage;
  }

  double calculateProteinPercentage(double proteinsConsumed) {
    double percentage =
        proteinsConsumed / (2 * widget.recommendedDailyIntake[2]);
    if (percentage >= 1.0) {
      percentage = 1.0;
    }
    return percentage;
  }

  Future<double> changeRecIntake(BuildContext context, String title,
      String contents, ModifiedNutrition nutrition) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (BuildContext context) {
          return Alert(
            alertType: AlertType.TextInputDialog,
            title: title,
            contents: contents,
          );
        }).then((value) {
      if (value != 0.0 && value != null) {
        if (nutrition == ModifiedNutrition.Calorie) {
          setState(() {
            widget.recommendedDailyIntake[0] = value;
          });
        } else if (nutrition == ModifiedNutrition.Fat) {
          setState(() {
            widget.recommendedDailyIntake[1] = value;
          });
        } else if (nutrition == ModifiedNutrition.Protein) {
          setState(() {
            widget.recommendedDailyIntake[2] = value;
          });
        }
      }
    });
  }
}
