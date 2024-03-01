import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guia_utf/constants.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static LatLng _initialCoords = LatLng(-25.052045581210123, -50.13189639528716);
  static LatLng _destination = LatLng(-25.052497537358487, -50.12982572992108);

  List<LatLng> polylineCoordinates = [];

  final Marker _currentLocationMarker = Marker(
    markerId: MarkerId("source"),
    position: _initialCoords,
  );

  final Marker _destinationMarker = Marker(
    markerId: MarkerId("destination"),
    position: _destination,
  );

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBQx0b02HcUqzrrAfDuwYbNI4xhoOcFKR0",
        PointLatLng(_initialCoords.latitude, _initialCoords.longitude),
        PointLatLng(_destination.latitude, _destination.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {});
    }
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialCoords,
            zoom: 17,
          ),
          polylines: {
            Polyline(
                polylineId: PolylineId("route"),
                visible: true,
                points: polylineCoordinates,
                color: Color.fromRGBO(128, 193, 201, 1),    
            )
          },
          markers: {
            _currentLocationMarker,
            _destinationMarker
          }),
    );
  }
}
