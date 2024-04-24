import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:guia_utf/pages/turn_by_turn.dart';
import 'package:latlng/latlng.dart';
import 'package:location/location.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../helpers/mapbox_handler.dart';
import '../main.dart';
import '../pages/home.dart';

class MicrophonePage extends StatefulWidget {
  const MicrophonePage({super.key});

  @override
  State<MicrophonePage> createState() => _MicrophonePageState();
}

class _MicrophonePageState extends State<MicrophonePage>
    with SingleTickerProviderStateMixin {
  late LatLng _destination;
  late String _destinationName;
  late String currentAdress = "";
  //late CameraPosition _initialCameraPosition;
  late String _screenText = "Passar comando";
  late String _screenSubtext = "Clique no microfone para passar um comando";

  FlutterTts flutterTts = FlutterTts();

  final Map<String, LatLng> _locations = {
    'academia': LatLng.degree(-25.052758024553686, -50.132030600382315),
    'biblioteca': LatLng.degree(-25.05179784592007, -50.13033029064471),
    'k': LatLng.degree(-25.05196612028669, -50.131037881178585),
    'ca': LatLng.degree(-25.05196612028669, -50.131037881178585),
    'l': LatLng.degree(-25.052105134672185, -50.13075655117847),
    'ru': LatLng.degree(-25.052614856920233, -50.129659651782084),
    'u': LatLng.degree(-25.052614856920233, -50.129659651782084),
    'c': LatLng.degree(-25.051611756131994, -50.13168191499036),
    'se': LatLng.degree(-25.051611756131994, -50.13168191499036),
    'd': LatLng.degree(-25.051249504796495, -50.13129008507452),
    'de': LatLng.degree(-25.051249504796495, -50.13129008507452),
    'entrada': LatLng.degree(-25.051036160579827, -50.13293188273079),
    'ônibus': LatLng.degree(-25.05141761289667, -50.132931788011355),
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Aperte o botão e comece a falar.";
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    //initialSpeech();
    initializeLocationAndSave();
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    // // Get the current user location
    LocationData _locationData = await _location.getLocation();
    LatLng currentLocation = LatLng(
        _locationData.latitude! as Angle, _locationData.longitude! as Angle);

    // // Get the current user address
    String currentAddress =
        (await getParsedReverseGeocoding(currentLocation))['place'];

    // // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);
    sharedPreferences.setString('current-address', currentAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('GuiaUTF'),
          centerTitle: true,
        ),
        body: Material(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 260.0,
                width: 500,
                child: FittedBox(
                  child: AvatarGlow(
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
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                _screenText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 260,
                child: Text(
                  _screenSubtext,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ));
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );

      if (available) {
        setState(() => _isListening = true);

        _screenText = "Ouvindo...";
        _screenSubtext = "O aplicativo irá ouvir seu comando e responder";

        _speech.listen(
            onResult: (val) => setState(() async {
                  _text = val.recognizedWords;
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    _confidence = val.confidence;
                  }

                  List<String> words =
                      val.recognizedWords.toLowerCase().split(' ');
                  bool isDestination = false;

                  for (String word in words) {
                    print(word);
                    if (_locations.containsKey(word)) {
                      isDestination = true;
                      _destination = _locations[word]!;
                      _destinationName = word;
                    }
                  }

                  //await Future.delayed(const Duration(seconds: 2));
                  if (!isDestination) {
                    // await flutterTts.speak(
                    //     "Destino não reconhecido. Por favor, tente novamente.");

                    _screenText = "Passar comando";
                    _screenSubtext =
                        "Clique no microfone para passar um comando";
                  } else {
                    await flutterTts
                        .speak("Entendido. Indo até $_destinationName");

                    sharedPreferences.setDouble(
                        'destinationLat', (_destination.latitude).degrees);
                    sharedPreferences.setDouble(
                        'destinationLon', (_destination.longitude).degrees);
                    sharedPreferences.setString(
                        'destinationName', _destinationName);

                    setState(() => _isListening = false);
                    _speech.stop();

                    navigate();
                  }
                }));
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _screenText = "Passar comando";
      _screenSubtext = "Clique no microfone para passar um comando";
    }
  }

  void navigate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const TurnByTurn(),
      ),
    );
  }
}
