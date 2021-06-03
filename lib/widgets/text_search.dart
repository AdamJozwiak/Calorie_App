import 'package:flutter/material.dart';

typedef void StringCallback(String val);

class TextSearch extends StatefulWidget {
  final StringCallback callback;
  const TextSearch({Key key, @required this.callback}) : super(key: key);

  @override
  _TextSearchState createState() => _TextSearchState();
}

class _TextSearchState extends State<TextSearch> with TickerProviderStateMixin {
  String _foodName;
  bool visible;
  int _duration;
  final _textController = TextEditingController();
  FocusNode _textFocus;

  @override
  void initState() {
    _foodName = '';
    visible = true;
    _duration = 1;
    super.initState();
    _textFocus = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        AbsorbPointer(
          absorbing: !visible,
          child: AnimatedOpacity(
            duration: Duration(seconds: _duration),
            opacity: visible ? 1.0 : 0.0,
            child: SizedBox(
              width: 200,
              child: TextField(
                textAlign: TextAlign.center,
                focusNode: _textFocus,
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Input food name',
                ),
                onChanged: (String foodName) {
                  _textFocus.requestFocus();
                  _foodName = foodName;
                },
                onSubmitted: (String foodName) async {
                  _foodName = foodName;
                  if (_foodName != '' && _foodName != null && visible) {
                    widget.callback(_foodName);
                    _textController.clear();
                  }
                },
              ),
            ),
          ),
        ),
        FlatButton.icon(
          onPressed: () {
            if (_textController.text == null || _textController.text == '') {
              setState(() {
                visible = !visible;
              });
              _textFocus.unfocus();
            } else if ((_textController.text != null ||
                    _textController.text != '') &&
                !visible) {
              setState(() {
                visible = !visible;
              });
            } else {
              if (_foodName != '' && _foodName != null && visible) {
                widget.callback(_foodName);
                _textFocus.unfocus();
                _textController.clear();
              }
            }
          },
          icon: Icon(Icons.search),
          label: Text('Search by text'),
        ),
      ]),
    );
  }
}
