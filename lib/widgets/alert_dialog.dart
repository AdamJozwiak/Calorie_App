import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  String title;
  String contents;
  Alert(this.title, this.contents);

  @override
  Widget build(BuildContext context) {
    contents = contents.replaceAll('. ', '.\n');

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(contents),
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
  }
}
