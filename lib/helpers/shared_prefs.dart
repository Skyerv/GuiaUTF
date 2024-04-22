import 'dart:convert';

import 'package:latlng/latlng.dart';

import '../main.dart';

LatLng getCurrentLatLngFromSharedPrefs() {
  return LatLng.degree((sharedPreferences.getDouble('latitude') ?? 0),
      (sharedPreferences.getDouble('longitude') ?? 0));
}

String getCurrentAddressFromSharedPrefs() {
  return sharedPreferences.getString('current-address') ?? '';
}

LatLng getTripLatLngFromSharedPrefs(String type) {
  // List sourceLocationList =
  //     json.decode(sharedPreferences.getString('source')!)['location'] ?? [0, 0];
  double destinationLat =
      sharedPreferences.getDouble('destinationLat')! ?? 0;
  double destinationLon =
      sharedPreferences.getDouble('destinationLon')! ?? 0;
  //LatLng source = LatLng(sourceLocationList[0], sourceLocationList[1]);
  LatLng destination =
      LatLng.degree(destinationLat, destinationLon);

  if (type == 'source') {
    //return source;
    return LatLng.degree(0, 0);
  } else {
    return destination;
  }
}

String getSourceAndDestinationPlaceText(String type) {
  String sourceAddress =
      json.decode(sharedPreferences.getString('source')!)['name'];
  String destinationAddress =
      json.decode(sharedPreferences.getString('destination')!)['name'];

  if (type == 'source') {
    return sourceAddress;
  } else {
    return destinationAddress;
  }
}