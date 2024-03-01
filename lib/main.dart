import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:guia_utf/pages/map_page.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:latlng/latlng.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:latlng/latlng.dart' as latLng;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 53, 189, 171)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'GuiaUTF'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _destination = "";

  final Map<String, HighlightedWord> _highlights = {
    'biblioteca': HighlightedWord(
      onTap: () => print("142.0.210"),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
    ),
    'bloco L': HighlightedWord(
      onTap: () => print("bloco L"),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
    ),
  };

  final Map<String, String> _locations = {
    'biblioteca':
        '-25.051865882571917, -50.130233731119866', //LatLng((-25.05179784592007) as Angle, (-50.13033029064471) as Angle),
    'bloco L':
        '14.23123', //LatLng((-25.05179784592007) as Angle, (-50.13033029064471) as Angle),
    'bloco C':
        '15.33212', //LatLng((-25.05179784592007) as Angle, (-50.13033029064471) as Angle),
    'ru':
        '12.424224', //LatLng((-25.05179784592007) as Angle, (-50.13033029064471) as Angle),
    'restaurante universitário':
        '11.22222', //LatLng((-25.05179784592007) as Angle, (-50.13033029064471) as Angle),
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Aperte o botão e comece a falar.";
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:
            Text('Indo até ${_destination}'),
      ),
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        duration: const Duration(milliseconds: 1000),
        repeat: true,
        child: FloatingActionButton.large(
          shape: const CircleBorder(),
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: const MapPage(),
      // body: SingleChildScrollView(
      //   reverse: true,
      //   child: Container(
      //     padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
      //     // child: TextHighlight(
      //     //   text: _text,
      //     //   words: _highlights,
      //     //   textStyle: const TextStyle(
      //     //     fontSize: 32.0,
      //     //     color: Colors.black,
      //     //     fontWeight: FontWeight.w400,
      //     //   ),
      //     // ),
      //     child: Text(
      //       _destination,
      //       style: TextStyle(
      //           fontSize: 24.0,
      //           color: Colors.teal[600],
      //           fontWeight: FontWeight.bold),
      //     ),
      //   ),
      // ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    _confidence = val.confidence;
                  }

                  print(val.recognizedWords.toString().toLowerCase());

                  List<String> words =
                      val.recognizedWords.toLowerCase().split(' ');

                  for (String word in words) {
                    if (_locations.containsKey(word)) {
                      _destination = word; // 'Coordenadas de $word: ${_locations[word]!}';
                      return;
                    }
                  }

                  _destination = 'Destino não reconhecido';
                }));
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
