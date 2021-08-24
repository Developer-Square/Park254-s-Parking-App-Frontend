import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/queryParkingLots.models.dart';
import '../../config/globals.dart' as globals;

/// Gets parking lots based on filters
///
/// Returns [QueryParkingLots]
/// Requires: [token]
/// Optional filter params: [name], [owner], [sortBy], [limit], [page]
Future<QueryParkingLots> getParkingLots({
  @required String token,
  String name = '',
  String owner = '',
  String sortBy = '',
  int limit = 10,
  int page = 1,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  Map<String, String> queryParameters = {
    "name": name,
    "owner": owner,
    "sortBy": sortBy,
    "limit": limit.toString(),
    "page": page.toString(),
  };
  queryParameters.removeWhere((key, value) => value == '');
  final url = Uri.https(globals.apiKey, '/v1/parkingLots', queryParameters);
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final results = QueryParkingLots.fromJson(jsonDecode(response.body));
    return results;
  } else {
    handleError(response.body);
  }
}
