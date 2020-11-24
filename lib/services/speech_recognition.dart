import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class SpeechRec extends StatefulWidget {
  @override
  _SpeechRecState createState() => _SpeechRecState();
}

class _SpeechRecState extends State<SpeechRec> {
  stt.SpeechToText _speech;
  bool _isListening;
  double _confidence;
  String _text;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _isListening = false;
    _confidence = 1.0;
    _text = '';
  }

  void listen() async {
    if(!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if(available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if(val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: Center(
        child: Column(
          children: [
            Text(_text),
            Container(
              child: AvatarGlow(
                animate: _isListening,
                glowColor: Colors.green,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                child: FloatingActionButton(
                  onPressed: () {
                    listen();
                    },
                child: Icon(Icons.mic),
                backgroundColor: Colors.green[700],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}