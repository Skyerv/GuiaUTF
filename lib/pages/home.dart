import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:latlng/latlng.dart';
import 'package:guia_utf/helpers/shared_prefs.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String accessToken =
      "pk.eyJ1Ijoic2t5ZXJ2IiwiYSI6ImNsdWN2cGUyazB5bjcyc3FuZjh2c3d4bzUifQ.2rNCUcrng9xCCjpnfRXDhA";

  LatLng source = LatLng.degree(-25.051134467404218, -50.132750645742206);
  LatLng destination = getTripLatLngFromSharedPrefs('destination');
  String destinationName = getDestinationName();
  var wayPoints = <WayPoint>[];

  // Variáveis de configuração para navegação do MapBox
  late MapBoxNavigation directions;
  late double distanceRemaining, durationRemaining;
  late MapBoxNavigationViewController _controller;
  final bool isMultipleStop = false;
  String instruction = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;

  final MapBoxOptions _options = MapBoxOptions(
      zoom: 18.0,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      mode: MapBoxNavigationMode.walking,
      isOptimized: true,
      units: VoiceUnits.metric,
      simulateRoute: true,
      language: "pt-BR");

  MapBoxNavigation mapBoxNavigation = MapBoxNavigation();

  @override
  void initState() {
    super.initState();

    // Configurar waypoints com informações passadas
    final WayPoint sourceWaypoint = WayPoint(
        name: "Source",
        latitude: (source.latitude).degrees,
        longitude: (source.longitude).degrees);
    final WayPoint destinationWaypoint = WayPoint(
        name: destinationName,
        latitude: (destination.latitude).degrees,
        longitude: (destination.longitude).degrees);

    wayPoints.add(sourceWaypoint);
    wayPoints.add(destinationWaypoint);

    print(wayPoints);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            // top: 0,
            // left: 0,
            // right: 0,
            // bottom: 0,
            child: SizedBox(
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height * 0.6,
              child: MapBoxNavigationView(
                options: _options,
                onRouteEvent: _onRouteEvent,
                onCreated: (MapBoxNavigationViewController controller) async {
                  _controller = controller;
                  _controller.buildRoute(
                    wayPoints: wayPoints,
                    options: _options,
                  );
                  //controller.startNavigation(options: _options);
                },
              ),
            ),
          ),
          Positioned(
            top: 40,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Indo para',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(destinationName.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan)),
                          ]),
                    ),
                  ),
                )),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.gps_fixed,
                              color: Colors.lightGreen,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                "Bloco C - Exterior",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.place,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                destinationName,
                                style: const TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/person_walking.png'),
                            const SizedBox(
                              width: 20,
                            ),
                            const Expanded(
                                child: Column(
                              children: [
                                Text(
                                  "DISTÂNCIA",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "300m",
                                  style: TextStyle(fontSize: 22),
                                ),
                              ],
                            )),
                            const Expanded(
                                child: Column(
                              children: [
                                Text(
                                  "TEMPO",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "5min",
                                  style: TextStyle(fontSize: 22),
                                ),
                              ],
                            )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Adicione a ação desejada ao pressionar o botão aqui
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .black87, // Define a cor de fundo do botão
                            minimumSize: const Size(
                                250, 50), // Define a largura do botão como 300
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors
                                  .white, // Define a cor do texto como branco
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.reply),
      ),
    );
  }

  Future<void> _onRouteEvent(e) async {
    distanceRemaining = (await directions.getDistanceRemaining())!;
    durationRemaining = (await directions.getDurationRemaining())!;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        arrived = progressEvent.arrived!;
        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigating = true;
        break;
      case MapBoxEvent.on_arrival:
        arrived = true;
        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        routeBuilt = false;
        isNavigating = false;
        break;
      default:
        break;
    }
    //refresh UI
    setState(() {});
  }
}
