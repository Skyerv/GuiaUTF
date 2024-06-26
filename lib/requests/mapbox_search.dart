import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guia_utf/main.dart';
import '../helpers/dio_exceptions.dart';

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = "pk.eyJ1Ijoic2t5ZXJ2IiwiYSI6ImNsdWN2cGUyazB5bjcyc3FuZjh2c3d4bzUifQ.2rNCUcrng9xCCjpnfRXDhA";
String searchType = 'place%2Cpostcode%2Caddress';
String searchResultsLimit = '5';
String proximity =
    '${sharedPreferences.getDouble('longitude')}%2C${sharedPreferences.getDouble('latitude')}';
String country = 'br';

Dio _dio = Dio();

Future getSearchResultsFromQueryUsingMapbox(String query) async {
  String url =
      '$baseUrl/$query.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$accessToken';
  url = Uri.parse(url).toString();
  print(url);
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } catch (e) {
    final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
    debugPrint(errorMessage);
  }
}