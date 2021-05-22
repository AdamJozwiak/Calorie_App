import 'package:call_app/models/food.dart';
import 'package:call_app/models/user.dart';
import 'package:call_app/services/auth.dart';
import 'package:call_app/services/database.dart';
import 'package:call_app/shared/functions.dart';
import 'package:call_app/widgets/radial_progress.dart';
import 'package:flutter/material.dart';
import 'package:call_app/widgets/calendar.dart';
import 'package:call_app/services/speech_recognition.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _foodName;
  Food _foodData = Food();
  List<Food> _foodConsumed = List();
  List<Food> _displayedFood = List();
  User currentUser = User();
  double _caloriesConsumed;
  double recommendedDailyCalorie = 2000.0;
  double _caloriesDisplayed;
  bool _isDifferentDayDisplayed = false;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    _foodData = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<User>(context);
    _foodConsumed = Provider.of<List<Food>>(context) ?? [];
    _caloriesConsumed = countCalories(_foodConsumed) ?? 0.0;

    return Scaffold(
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
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25.0),
                RadialProgress(
                  differentDate: _isDifferentDayDisplayed,
                  calories: _caloriesConsumed,
                  differentCalories: _caloriesDisplayed,
                  recommendedCalories: recommendedDailyCalorie,
                ),
                SizedBox(height: 5.0),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Input food name',
                  ),
                  onChanged: (String _foodName) {
                    this._foodName = _foodName;
                  },
                  onSubmitted: (String _foodName) async {
                    this._foodName = _foodName;
                    if (_foodName != '' && _foodName != null) {
                      apiFoodInfo();
                    }
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton.icon(
                  onPressed: () async {
                    apiFoodInfo();
                  },
                  icon: Icon(Icons.search),
                  label: Text('Search'),
                ),
                SpeechRec(getFoodname: getSpokenFood),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void getSelectedDate(DateTime date) async {
    if (getDate(date) != getCurrentDate()) {
      DatabaseService database = DatabaseService(uid: currentUser.uid);
      _displayedFood = await database.getUserData(getDate(date));
      setState(() {
        _isDifferentDayDisplayed = true;
        _caloriesDisplayed = countCalories(_displayedFood);
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
        _caloriesConsumed = countCalories(_foodConsumed);
      });
    }
  }
}
