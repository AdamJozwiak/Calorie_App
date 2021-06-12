import 'package:flutter/material.dart';

enum AlertType { InfoDialog, TextInputDialog }

class Alert extends StatefulWidget {
  String title;
  String contents;
  dynamic alertType;
  final returnIntake;
  Alert(
      {Key key,
      this.title,
      this.contents,
      @required this.alertType,
      this.returnIntake})
      : super(key: key);

  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  double _newIntake = 0.0;

  @override
  Widget build(BuildContext context) {
    widget.contents = widget.contents.replaceAll('. ', '.\n');

    if (widget.alertType == AlertType.InfoDialog) {
      return AlertDialog(
        title: Text(widget.title),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(widget.contents),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK!'))
        ],
      );
    } else if (widget.alertType == AlertType.TextInputDialog) {
      return AlertDialog(
        title: Text(widget.title),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(widget.contents),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'New daily value',
                ),
                onChanged: (String recommendedIntake) {
                  setState(() {
                    _newIntake = double.parse(recommendedIntake);
                  });
                },
                onSubmitted: (String recommendedIntake) {
                  if (recommendedIntake != null && recommendedIntake != '') {
                    Navigator.of(context).pop(_newIntake);
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (_newIntake != null && _newIntake != 0.0) {
                  Navigator.of(context).pop(_newIntake);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text('Confirm'))
        ],
      );
    }
  }
}
