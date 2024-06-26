import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlng/latlng.dart';
import '../helpers/dio_exceptions.dart';

String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String accessToken = "pk.eyJ1Ijoic2t5ZXJ2IiwiYSI6ImNsdWN2cGUyazB5bjcyc3FuZjh2c3d4bzUifQ.2rNCUcrng9xCCjpnfRXDhA";
String navType = 'walking';

Dio _dio = Dio();

Future getCyclingRouteUsingMapbox(LatLng source, LatLng destination) async {
  String url =
      '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
    debugPrint(errorMessage);
  }
}