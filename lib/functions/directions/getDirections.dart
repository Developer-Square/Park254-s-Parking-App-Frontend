import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:park254_s_parking_app/.env.dart';
import 'package:park254_s_parking_app/models/directions.model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  Dio _dio;

  DirectionsRepository({Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({
    @required LatLng origin,
    @required LatLng destination,
  }) async {
    Map<String, String> queryParameters = {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': kGOOGLE_API_KEY,
    };

    final response = await _dio.get(_baseUrl, queryParameters: queryParameters);
    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    } else {
      // Error handling.
      log('Not successful, In get directions file');
      log(response.data.toString());
      throw response.data;
    }
  }
}
