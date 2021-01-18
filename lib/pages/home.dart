import 'package:call_app/models/food.dart';
import 'package:call_app/models/user.dart';
import 'package:call_app/services/database.dart';
import 'package:call_app/shared/functions.dart';
import 'package:flutter/material.dart';
import 'package:call_app/widgets/calendar.dart';
import 'package:call_app/services/speech_recognition.dart';
import 'package:call_app/widgets/food_list.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String foodName;
  Food foodData = Food();
  List<Food> foodConsumed = List();

  @override
  void initState() {
    foodData = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Food>>.value(
      value: DatabaseService().foods,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.green[700],
        //   elevation: 10.0,
        //   shadowColor: Colors.grey[600],
        //   title: Text('Calorie App',
        //   style: TextStyle(
        //     fontSize: 22.0,
        //     fontWeight: FontWeight.bold,
        //     letterSpacing: 3.0,
        //   )
        //     ,),
        //   centerTitle: true,
        // ),
        backgroundColor: Colors.grey[350],
        body: SafeArea(
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Calendar(),
                    SizedBox(height: 50.0),
                    Center(
                      child: Container(
                        child: Text('Calories consumed : ' +
                            countCalories(foodConsumed).toString()),
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
                    Foodlist(),
                    FlatButton.icon(
                        onPressed: () {
                          print(DatabaseService().foods);
                        },
                        icon: Icon(Icons.ac_unit),
                        label: Text('Debug button')),
                    SpeechRec(getFoodname: getSpokenFood),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
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
        checkForRepetition();
      } catch (e) {
        print(e.toString());
        return null;
      }
    } else {
      showAlert(context, 'Wrong food name',
          'You have not entered proper food name. Please, try again.');
    }
  }

  void checkForRepetition() async {
    if (foodData != null) {
      bool isFound = false;
      for (final i in foodConsumed) {
        if (i.name == foodData.name) {
          i.amount += 1;
          isFound = true;
          break;
        }
      }
      if (!isFound) {
        foodConsumed.add(foodData);

        //TODO: zrobic to dobrze
        await DatabaseService(uid: '18ovnuATgSLZ6195nlYd')
            .updateUserData(foodData);
      }
    }
  }

  void getSpokenFood(String spokenName) {
    setState(() {
      foodName = spokenName;
    });
    apiFoodInfo();
  }
}
