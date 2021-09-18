import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/vehicle.model.dart';
import '../../config/globals.dart' as globals;

/// Fetches a vehicle using an id
Future<Vehicle> getVehicleById({
  @required String token,
  @required String vehicleId,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.apiKey, '/v1/vehicles/$vehicleId');
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final vehicle = Vehicle.fromJson(jsonDecode(response.body));
    return vehicle;
  } else {
    handleError(response.body);
  }
}
