import 'package:call_app/models/food.dart';
import 'package:flutter/material.dart';

class Consumed extends StatefulWidget {
  @override
  _ConsumedState createState() => _ConsumedState();
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

Widget fillList(List<Food> data) {
  List<Widget> list = new List<Widget>();
  data.forEach((element) {
    list.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          imageCheck(element),
          SizedBox(
            width: 8,
          ),
          Text(element.amount.toString() + 'x'),
          SizedBox(
            width: 8,
          ),
          Text(element.name.toString().capitalize()),
          SizedBox(
            width: 8,
          ),
          Text((element.kcal * element.amount).toString()),
          SizedBox(
            width: 8,
          ),
          Text((element.fat * element.amount).toString()),
        ],
      ),
    ));
  });
  return new Column(children: list);
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

class _ConsumedState extends State<Consumed> {
  List<Food> data = List();

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        shrinkWrap: true,
        children: [
          fillList(data),
        ],
      ),
    );
  }
}
