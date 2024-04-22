// import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:guia_utf/helpers/shared_prefs.dart';

// class Home extends StatefulWidget {
//   final LatLng destination;
//   final String destinationName;
//   const Home(
//       {super.key, required this.destination, required this.destinationName});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   late LatLng currentLocation = widget
//       .destination; //const LatLng(-25.052045581210123, -50.13189639528716);
//   late String currentAddress;
//   late CameraPosition _initialCameraPosition;

//   @override
//   void initState() {
//     super.initState();
//     _initialCameraPosition = CameraPosition(target: currentLocation, zoom: 18);
//     currentAddress = "";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           MapboxMap(
//             accessToken:
//                 "pk.eyJ1Ijoic2t5ZXJ2IiwiYSI6ImNsdWN2cGUyazB5bjcyc3FuZjh2c3d4bzUifQ.2rNCUcrng9xCCjpnfRXDhA",
//             initialCameraPosition: _initialCameraPosition,
//             //myLocationEnabled: true,
//           ),
//           Positioned(
//             top: 40,
//             child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Card(
//                     clipBehavior: Clip.antiAlias,
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Text(
//                               'Indo para',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             Text(widget.destinationName.toUpperCase(),
//                                 style: const TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.cyan)),
//                           ]),
//                     ),
//                   ),
//                 )),
//           ),
//           Positioned(
//             bottom: 0,
//             child: SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: Card(
//                 clipBehavior: Clip.antiAlias,
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.gps_fixed,
//                               color: Colors.lightGreen,
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "Bloco C - Exterior",
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Divider(),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Icon(
//                               Icons.place,
//                               color: Colors.redAccent,
//                             ),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 widget.destinationName,
//                                 style: const TextStyle(fontSize: 18),
//                               ),
//                             )
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Image.asset('assets/images/person_walking.png'),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             const Expanded(
//                                 child: Column(
//                               children: [
//                                 Text(
//                                   "DISTÂNCIA",
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                                 Text(
//                                   "300m",
//                                   style: TextStyle(fontSize: 22),
//                                 ),
//                               ],
//                             )),
//                             const Expanded(
//                                 child: Column(
//                               children: [
//                                 Text(
//                                   "TEMPO",
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                                 Text(
//                                   "5min",
//                                   style: TextStyle(fontSize: 22),
//                                 ),
//                               ],
//                             )),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         ElevatedButton(
//                           onPressed: () {
//                             // Adicione a ação desejada ao pressionar o botão aqui
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors
//                                 .black87, // Define a cor de fundo do botão
//                             minimumSize: const Size(
//                                 250, 50), // Define a largura do botão como 300
//                           ),
//                           child: const Text(
//                             'Cancelar',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors
//                                   .white, // Define a cor do texto como branco
//                             ),
//                           ),
//                         )
//                       ]),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.large(
//         shape: const CircleBorder(),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         child: const Icon(Icons.reply),
//       ),
//     );
//   }
// }
