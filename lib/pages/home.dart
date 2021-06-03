import 'package:call_app/models/food.dart';
import 'package:call_app/models/user.dart';
import 'package:call_app/services/auth.dart';
import 'package:call_app/services/database.dart';
import 'package:call_app/shared/functions.dart';
import 'package:call_app/widgets/radial_progress.dart';
import 'package:call_app/widgets/text_search.dart';
import 'package:flutter/material.dart';
import 'package:call_app/widgets/calendar.dart';
import 'package:call_app/services/speech_recognition.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Food _foodData = Food();
  User currentUser = User();
  List<Food> _foodConsumed = List();
  List<Food> _displayedFood = List();

  // Time 2, because there are different values for current and different days
  List<double> _caloriesConsumed = List<double>(2);
  List<double> _fatsConsumed = List<double>(2);
  List<double> _proteinsConsumed = List<double>(2);
  List<double> recommendedDailyIntake = List<double>(3);

  String _foodName;
  bool _isDifferentDayDisplayed = false;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    _foodData = null;
    recommendedDailyIntake[0] = 2500.0;
    recommendedDailyIntake[1] = 50.0;
    recommendedDailyIntake[2] = 55.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<User>(context);
    _foodConsumed = Provider.of<List<Food>>(context) ?? [];
    _caloriesConsumed[0] = countCalories(_foodConsumed) ?? 0.0;
    _fatsConsumed[0] = countFats(_foodConsumed) ?? 0.0;
    _proteinsConsumed[0] = countProteins(_foodConsumed) ?? 0.0;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          elevation: 10.0,
          shadowColor: Colors.grey[600],
          title: Text(
            'CalApp',
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0,
                color: Colors.black87),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 55.0),
              child: FlatButton.icon(
                onPressed: () {
                  if (!_isDifferentDayDisplayed) {
                    Navigator.pushNamed(context, '/consumed',
                        arguments: _foodConsumed);
                  } else {
                    Navigator.pushNamed(context, '/consumed',
                        arguments: _displayedFood);
                  }
                },
                icon: Icon(Icons.fastfood),
                label: Text('Food'),
              ),
            ),
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('Logout'))
          ],
        ),
        backgroundColor: Colors.grey[350],
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Calendar(getChosenDate: getSelectedDate),
                  Divider(
                    height: 10.0,
                    thickness: 1.0,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    'Calories Consumed',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15.0),
                  RadialProgress(
                    differentDate: _isDifferentDayDisplayed,
                    calories: _caloriesConsumed,
                    fats: _fatsConsumed,
                    proteins: _proteinsConsumed,
                    recommendedCalories: recommendedDailyIntake,
                  ),
                  SizedBox(height: 25.0),
                  TextSearch(callback: (foodName) => textApiInfo(foodName)),
                  SpeechRec(
                    getFoodname: getSpokenFood,
                    buttonSize: 65.0,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void getSelectedDate(DateTime date) async {
    if (getDate(date) != getCurrentDate()) {
      DatabaseService database = DatabaseService(uid: currentUser.uid);
      _displayedFood = await database.getUserData(getDate(date));
      setState(() {
        _isDifferentDayDisplayed = true;
        _caloriesConsumed[1] = countCalories(_displayedFood);
        _fatsConsumed[1] = countFats(_foodConsumed);
        _proteinsConsumed[1] = countCalories(_displayedFood);
      });
    } else {
      setState(() {
        _isDifferentDayDisplayed = false;
      });
    }
  }

  void getSpokenFood(String spokenName) {
    setState(() {
      _foodName = spokenName;
    });
    apiFoodInfo();
  }

  void apiFoodInfo() async {
    print(_foodName);
    if (_foodName != null && _foodName != '') {
      final data = await Navigator.pushNamed(context, '/loading',
          arguments: this._foodName);
      if (data != null) {
        setState(() {
          _foodData = data;
        });
        updateFoodList();
      } else {
        showAlert(context, 'Wrong food name',
            'I am sorry, but I did not understand. Could you reapeat?');
      }
    } else {
      showAlert(context, 'Wrong food name',
          'You have not entered proper food name. Please, try again.');
    }
  }

  void textApiInfo(String foodName) async {
    print(foodName);
    if (foodName != null && foodName != '') {
      final data =
          await Navigator.pushNamed(context, '/loading', arguments: foodName);
      if (data != null) {
        setState(() {
          _foodData = data;
        });
        updateFoodList();
      } else {
        showAlert(context, 'Wrong food name',
            'I am sorry, but I did not understand. Could you reapeat?');
      }
    } else {
      showAlert(context, 'Wrong food name',
          'You have not entered proper food name. Please, try again.');
    }
  }

  void updateFoodList() async {
    if (_foodData != null) {
      bool isFound = false;
      for (final i in _foodConsumed) {
        if (i.name == _foodData.name) {
          i.amount += 1;
          isFound = true;
          await DatabaseService(uid: currentUser.uid).updateUserData(i);
          break;
        }
      }
      if (!isFound) {
        _foodConsumed.add(_foodData);
        await DatabaseService(uid: currentUser.uid).updateUserData(_foodData);
      }
      setState(() {
        _caloriesConsumed[0] = countCalories(_foodConsumed);
        _fatsConsumed[0] = countFats(_foodConsumed) ?? 0.0;
        _proteinsConsumed[0] = countProteins(_foodConsumed) ?? 0.0;
      });
    }
  }
}
