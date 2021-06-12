import 'package:call_app/models/food.dart';
import 'package:call_app/models/user.dart';
import 'package:call_app/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double _IMGSIZE = 70.0;

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
  List<int> _wordLength;

  @override
  Widget build(BuildContext context) {
    if (inititalBuild) {
      list = new List<Widget>();
      _modifiedData = new List<Food>();
      _wordLength = new List<int>();

      list.add(tableHeader());

      widget.foodData.forEach((element) {
        _modifiedData.add(element);
        _wordLength.add(element.name.length);
      });
      inititalBuild = false;
    }
    if (stateChanged) {
      list.clear();
      stateChanged = false;
      list.add(tableHeader());
    }

    _modifiedData.forEach((element) {
      list.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  imageCheck(element),
                  Text(
                    element.amount.toString() + 'x',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(
                    child: Text(
                      element.name.toString().capitalize(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (element.kcal * element.amount).toStringAsFixed(1) +
                        '\nkcal',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text((element.fat * element.amount).toStringAsFixed(1) + 'g'),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text((element.protein * element.amount).toStringAsFixed(1) +
                      'g'),
                  FlatButton.icon(
                    minWidth: 1.0,
                    onPressed: () {
                      _modifiedData.remove(element);
                      modifyRecords(
                              widget.user.uid, _modifiedData, widget.foodData)
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
            ),
          ],
        ),
      ));
    });

    // GridView.builder(
    //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //         maxCrossAxisExtent: 200,
    //         childAspectRatio: 3 / 2,
    //         crossAxisSpacing: 20,
    //         mainAxisSpacing: 20),
    //     itemCount: _modifiedData.length,
    //     itemBuilder: (BuildContext context, index) {
    //       Container(
    //         alignment: Alignment.center,
    //         child: ,)
    //     });

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
      width: _IMGSIZE,
      height: _IMGSIZE,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fill, image: NetworkImage(data.imageUrl))),
    );
  } else {
    return Container(
      width: _IMGSIZE,
      height: _IMGSIZE,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/unavailableImage.png'))),
    );
  }
}

Widget tableHeader() {
  return Column(children: [
    Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
      child: Row(
        children: [
          SizedBox(
            width: 45.0,
          ),
          Text('Food'),
          SizedBox(
            width: 70.0,
          ),
          Text('Calories'),
          SizedBox(
            width: 13.0,
          ),
          Text('Fat(g)'),
          SizedBox(
            width: 10.0,
          ),
          Text('Protein(g)'),
          SizedBox(
            width: 15.0,
          ),
        ],
      ),
    ),
    Divider(
      thickness: 2.0,
    )
  ]);
}
