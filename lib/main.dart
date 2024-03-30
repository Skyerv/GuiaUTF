import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:guia_utf/helpers/shared_prefs.dart';
import 'package:guia_utf/pages/home.dart';
import 'package:guia_utf/pages/microphone.dart';
import 'package:guia_utf/ui/splash.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:latlng/latlng.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:latlng/latlng.dart' as latLng;
import 'package:mapbox_gl/mapbox_gl.dart' as mapbox;
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
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
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 205, 255, 255)),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('GuiaUTF'),
          centerTitle: true,
        ),
        body: const MicrophonePage());
  }
}
