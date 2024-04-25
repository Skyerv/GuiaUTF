import 'dart:ffi';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_tts/flutter_tts.dart';


class CompassPage extends StatefulWidget {
  const CompassPage({super.key});

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  double? heading = 0;
  FlutterTts flutterTts = FlutterTts();
  int directionSelected = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterCompass.events!.listen((event) {setState(() {
      heading = event.heading;

      print(heading);
      if ((heading! <= 10 && heading! >= -10) && directionSelected != 1) {
        speechDirection("Norte");
        directionSelected = 1;
      }
      if ((heading! <= -170 || heading! >= 170) && directionSelected != 5) {
        speechDirection("Sul");
        directionSelected = 5;
      }
      if ((heading! <= 100 && heading! >= 70) && directionSelected != 3) {
        speechDirection("Leste");
        directionSelected = 3;
      }
      if ((heading! <= -70 && heading! >= -100) && directionSelected != 7) {
        speechDirection("Oeste");
        directionSelected = 7;
      }
    });});
  }
  void initialSpeech() async {
    await flutterTts.speak(
        "Bem-vindo ao Guia UTF. No meio da tela há um botão. Clique nele e diga para onde deseja ir.");
  }
  void speechDirection(String speechDirection) async {
    await flutterTts.speak(
        speechDirection);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.black12,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("${heading!.ceil()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26.0,
            fontWeight: FontWeight.bold,
            ),
          )
        ],
        ),
        
      );
  }
}