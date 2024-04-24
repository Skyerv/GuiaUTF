import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:guia_utf/pages/microphone.dart';
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
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 205, 255, 255)),
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
  FlutterTts flutterTts = FlutterTts();
  
  @override
  void initState() {
    super.initState();
    initialSpeech();
  }

  void initialSpeech() async {
    await flutterTts.speak(
        "Bem-vindo ao Guia UTF. No meio da tela há um botão. Clique nele e diga para onde deseja ir.");
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: MicrophonePage());
  }
}
