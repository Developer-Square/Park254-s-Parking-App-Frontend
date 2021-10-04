import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

/// Deletes a vehicle
///
/// Requires: [token], [vehicleId]
Future<String> deleteVehicle({
  @required String token,
  @required String vehicleId,
}) async {
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.apiKey, '/v1/vehicles/$vehicleId');
  final response = await http.delete(url, headers: headers);

  if (response.statusCode == 200) {
    return 'success';
  } else {
    handleError(response.body);
  }
}
