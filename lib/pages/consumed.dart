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

Widget fillList(List<Map> data){
  List<Widget> list = new List<Widget>();
  data.forEach((element) {
    list.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.network(element['image'], scale: 3.0),
          SizedBox(width: 8,),
          Text(element['amount'].toString() + 'x'),
          SizedBox(width: 8,),
          Text(element['name'].toString().capitalize()),
          SizedBox(width: 8,),
          Text((element['kcal'] * element['amount']).toString()),
          SizedBox(width: 8,),
          Text((element['fat'] * element['amount']).toString()),
        ],
      ),
    ));
  });
  return new Column(children: list);
}

class _ConsumedState extends State<Consumed> {
  List<Map> data = List();

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 10.0,
        shadowColor: Colors.grey[600],
        title: Text('Food Consumed',
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
          )
          ,),
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