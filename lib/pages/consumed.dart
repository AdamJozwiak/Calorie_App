import 'package:call_app/models/food.dart';
import 'package:call_app/models/user.dart';
import 'package:call_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Consumed extends StatefulWidget {
  @override
  _ConsumedState createState() => _ConsumedState();
}

class _ConsumedState extends State<Consumed> {
  List<Food> data = List();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          elevation: 10.0,
          shadowColor: Colors.grey[600],
          title: Text(
            'Food Consumed',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 3.0,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[350],
        body: ItemList(foodData: data, user: user));
  }
}

class ItemList extends StatefulWidget {
  final List<Food> foodData;
  final User user;
  ItemList({Key key, this.foodData, this.user}) : super(key: key);
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  bool stateChanged = false;
  bool inititalBuild = true;
  List<Widget> list;
  List<Food> _modifiedData;
  @override
  Widget build(BuildContext context) {
    if (inititalBuild) {
      list = new List<Widget>();
      _modifiedData = new List<Food>();
      widget.foodData.forEach((element) {
        _modifiedData.add(element);
      });
      inititalBuild = false;
    }
    if (stateChanged) {
      list.clear();
      stateChanged = false;
    }

    _modifiedData.forEach((element) {
      list.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            imageCheck(element),
            Text(element.amount.toString() + 'x'),
            Text(element.name.toString().capitalize()),
            Text((element.kcal * element.amount).toString()),
            Text((element.fat * element.amount).toString()),
            FlatButton.icon(
              onPressed: () {
                _modifiedData.remove(element);
                modifyRecords(widget.user.uid, _modifiedData, widget.foodData)
                    .then((value) {
                  setState(() {
                    stateChanged = value;
                  });
                });
              },
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red[300],
              ),
              label: Text(''),
            )
          ],
        ),
      ));
    });

    return ListView(shrinkWrap: true, children: [Column(children: list)]);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

Future<bool> modifyRecords(
    String uid, List<Food> foodData, List<Food> originalFoodData) async {
  if (foodData != null && originalFoodData != null) {
    for (final i in originalFoodData) {
      if (!foodData.contains(i)) {
        await DatabaseService(uid: uid).deleteUserData(i);
        return true;
      }
    }
  }
  return false;
}

Widget imageCheck(Food data) {
  if (data.imageUrl != null && data.imageUrl != '') {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fill, image: NetworkImage(data.imageUrl))),
    );
  } else {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/unavailableImage.png'))),
    );
  }
}
