import 'dart:async';
import 'dart:convert';
import 'dart:io' as dartIO;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/vehicle.model.dart';
import '../../config/globals.dart' as globals;

/// Creates a new vehicle
Future<Vehicle> createVehicle({
  @required String owner,
  @required String plate,
  @required String model,
}) async {
  Map<String, String> headers = {
    dartIO.HttpHeaders.contentTypeHeader: "application/json",
  };
  final Uri url = Uri.https(globals.apiKey, '/v1/vehicles');
  final Map<String, String> vehicle = new Vehicle(
    model: model,
    plate: plate,
    owner: owner,
  ).toJson();
  final response = await http.post(
    url,
    body: vehicle,
    headers: headers,
  );

  if (response.statusCode == 201) {
    final vehicle = Vehicle.fromJson(jsonDecode(response.body));
    return vehicle;
  } else {
    handleError(response.body);
  }
}
