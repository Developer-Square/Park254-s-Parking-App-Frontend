import 'dart:async';
import 'dart:convert';
import 'dart:io' as dartIO;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/vehicle.model.dart';
import '../../config/globals.dart' as globals;

/// Updates vehicles's [owner], [model], or [plate]
///
/// Returns [Vehicle]
/// Requires: [token], [vehicleId]
Future<Vehicle> updateUser({
  @required String token,
  @required String vehicleId,
  String owner = '',
  String model = '',
  String plate = '',
}) async {
  Map<String, String> headers = {
    dartIO.HttpHeaders.authorizationHeader: "Bearer $token",
  };
  Map<String, dynamic> body = {
    "owner": owner,
    "model": model,
    "plate": plate,
  };
  body.removeWhere((key, value) => value == '');
  final url = Uri.https(globals.apiKey, '/v1/vehicles/$vehicleId');
  final response =
      await http.patch(url, headers: headers, body: jsonEncode(body));

  if (response.statusCode == 200) {
    final vehicle = Vehicle.fromJson(jsonDecode(response.body));
    return vehicle;
  } else {
    handleError(response.body);
  }
}
