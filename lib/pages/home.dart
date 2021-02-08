import 'package:call_app/models/food.dart';
import 'package:call_app/models/user.dart';
import 'package:call_app/services/auth.dart';
import 'package:call_app/services/database.dart';
import 'package:call_app/shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:call_app/widgets/calendar.dart';
import 'package:call_app/services/speech_recognition.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String foodName;
  Food foodData = Food();
  List<Food> foodConsumed = List();
  User currentUser = User();
  String caloriesConsumed;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    foodData = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<User>(context);
    foodConsumed = Provider.of<List<Food>>(context) ?? [];
    caloriesConsumed = countCalories(foodConsumed).toString() ?? '0.0';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 10.0,
        shadowColor: Colors.grey[600],
        title: Text(
          'Call App',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
          ),
        ),
        actions: [
          FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('logout'))
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
                SizedBox(height: 50.0),
                Center(
                  child: Container(
                    child: Text('Calories consumed : ' + caloriesConsumed),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Input food name',
                  ),
                  onChanged: (String foodName) {
                    this.foodName = foodName;
                  },
                ),
                SizedBox(height: 20.0),
                FlatButton.icon(
                  onPressed: () async {
                    apiFoodInfo();
                  },
                  icon: Icon(Icons.fastfood),
                  label: Text('Search food info'),
                ),
                SizedBox(height: 20.0),
                FlatButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/consumed',
                        arguments: foodConsumed);
                  },
                  icon: Icon(Icons.fastfood),
                  label: Text('Check your food'),
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
    DatabaseService database = DatabaseService(uid: currentUser.uid);
    List<Food> temp = await database.getUserData(getDate(date));
    print('Przed-> Kalorie: ' + caloriesConsumed + ' ');
    foodConsumed.forEach((element) {
      print(element.name + ' ');
    });
    setState(() {
      foodConsumed = temp;
      caloriesConsumed = countCalories(foodConsumed).toString();
    });
    print('Po-> Kalorie: ' + caloriesConsumed + ' ');
    foodConsumed.forEach((element) {
      print(element.name + ' ');
    });
  }

  void getSpokenFood(String spokenName) {
    setState(() {
      foodName = spokenName;
    });
    apiFoodInfo();
  }

  void apiFoodInfo() async {
    print(foodName);
    if (foodName != null && foodName != '') {
      try {
        //TODO: zabezpieczyc przed dziwnymi slowami
        final data = await Navigator.pushNamed(context, '/loading',
            arguments: this.foodName);
        setState(() {
          foodData = data;
        });
        updateFoodList();
      } catch (e) {
        print(e.toString());
        return null;
      }
    } else {
      showAlert(context, 'Wrong food name',
          'You have not entered proper food name. Please, try again.');
    }
  }

  void updateFoodList() async {
    if (foodData != null) {
      bool isFound = false;
      for (final i in foodConsumed) {
        if (i.name == foodData.name) {
          i.amount += 1;
          isFound = true;
          await DatabaseService(uid: currentUser.uid).updateUserData(i);
          break;
        }
      }
      if (!isFound) {
        foodConsumed.add(foodData);
        await DatabaseService(uid: currentUser.uid).updateUserData(foodData);
      }
      setState(() {
        caloriesConsumed = countCalories(foodConsumed).toString();
      });
    }
  }
}
