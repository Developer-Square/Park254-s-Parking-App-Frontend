import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/nearbyParkingLots.model.dart';
import '../../config/globals.dart' as globals;

/// Get nearby parking lots with distance from location
///
/// Returns [NearbyParkingLots]
/// Requires: [token], [longitude], [latitude]
/// optional param: [maxDistance] default=5
Future<NearbyParkingLots> getNearbyParkingLots({
  @required String token,
  @required num longitude,
  @required num latitude,
  num maxDistance = 5,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  Map<String, String> queryParameters = {
    "longitude": longitude.toString(),
    "latitude": latitude.toString(),
    "maxDistance": maxDistance.toString(),
  };
  final url = Uri.https(globals.apiKey, '/v1/nearbyParking', queryParameters);
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final results = NearbyParkingLots.fromJson(jsonDecode(response.body));
    return results;
  } else {
    handleError(response.body);
  }
}
