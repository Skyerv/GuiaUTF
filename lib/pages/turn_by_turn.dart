import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:guia_utf/pages/microphone.dart';
import 'package:guia_utf/helpers/shared_prefs.dart';
import 'package:latlng/latlng.dart';

class TurnByTurn extends StatefulWidget {
  final LatLng destination;
  const TurnByTurn({super.key, required this.destination});

  @override
  State<TurnByTurn> createState() => _TurnByTurnState();
}

class _TurnByTurnState extends State<TurnByTurn> {
  // Waypoints to mark trip start and end
  LatLng source = LatLng.degree((-25.051335279045908), (-50.13230204687456));
  LatLng destination = getTripLatLngFromSharedPrefs('destination');
  late WayPoint sourceWaypoint, destinationWaypoint;
  var wayPoints = <WayPoint>[];

  // Config variables for Mapbox Navigation
  late MapBoxNavigation directions;
  late MapBoxOptions _options;
  late double distanceRemaining, durationRemaining;
  late MapBoxNavigationViewController _controller;
  final bool isMultipleStop = false;
  String instruction = "";
  bool arrived = false;
  bool routeBuilt = false;
  bool isNavigating = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    if (!mounted) return;

    // Setup directions and options
    directions = MapBoxNavigation();
    _options = MapBoxOptions(
        zoom: 18.0,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        mode: MapBoxNavigationMode.walking,
        isOptimized: true,
        units: VoiceUnits.metric,
        simulateRoute: false,
        language: "pt-BR");

    // Configure waypoints
    sourceWaypoint = WayPoint(
        name: "Source", latitude: (source.latitude).degrees, longitude: (source.longitude).degrees);
    destinationWaypoint = WayPoint(
        name: "Destination",
        latitude: (destination.latitude).degrees,
        longitude: (destination.longitude).degrees);
    wayPoints.add(sourceWaypoint);
    wayPoints.add(destinationWaypoint);

    // Start the trip
    await directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  @override
  Widget build(BuildContext context) {
    return const MicrophonePage();
  }

  Future<void> _onRouteEvent(e) async {
    distanceRemaining = (await directions.getDistanceRemaining())! ?? 0;
    durationRemaining = (await directions.getDurationRemaining())! ; 0;

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
