import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/vehicleList.model.dart';
import '../../config/globals.dart' as globals;

Future<VehicleList> getVehicles({
  @required String token,
  @required String owner,
  String plate = '',
  String sortBy = '',
  int limit = 10,
  int page = 1,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  Map<String, String> queryParameters = {
    "owner": owner,
    "plate": plate,
    "sortBy": sortBy,
    "limit": limit.toString(),
    "page": page.toString(),
  };
  queryParameters.removeWhere((key, value) => value == '');
  final url = Uri.https(globals.apiKey, '/v1/vehicles', queryParameters);
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final vehicles = VehicleList.fromJson(jsonDecode(response.body));
    return vehicles;
  } else {
    handleError(response.body);
  }
}
