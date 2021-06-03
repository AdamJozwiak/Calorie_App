import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:call_app/shared/functions.dart';

class SpeechRec extends StatefulWidget {
  final getFoodname;
  final double buttonSize;
  SpeechRec({Key key, this.getFoodname, @required this.buttonSize})
      : super(key: key);

  @override
  _SpeechRecState createState() => _SpeechRecState();
}

class _SpeechRecState extends State<SpeechRec> {
  stt.SpeechToText _speech;
  bool _isListening;
  String _text;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _isListening = false;
    _text = '';
  }

  void listen() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(onResult: (val) {
        setState(() {
          _text = val.recognizedWords;
          if (_text != null && _text != '') {
            _text = _text.substring(0, _text.indexOf(' '));
          }
        });
      });
    }
  }

  void stopListening() async {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
    widget.getFoodname(_text);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: AvatarGlow(
          animate: _isListening,
          glowColor: Colors.green,
          endRadius: widget.buttonSize,
          duration: const Duration(milliseconds: 2000),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: Listener(
            onPointerDown: (_) {
              if (!_isListening) {
                listen();
              } else {
                showAlert(
                    context, 'Error', 'An error occured. Please try again');
              }
            },
            onPointerUp: (_) {
              if (_isListening) {
                stopListening();
              } else {
                showAlert(context, 'Cannot find result',
                    'Please, try holding the button a little longer');
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.circular(40.0),
              ),
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.mic,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
