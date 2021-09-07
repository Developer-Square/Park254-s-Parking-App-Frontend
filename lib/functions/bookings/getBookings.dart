import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/bookingsList.dart';
import '../../config/globals.dart' as globals;

/// Gets bookings using filters
///
/// Filters: [clientId], [parkingLotId], [isCancelled], [sortBy], [limit], [page]
Future<BookingsList> getBookings({
  @required String token,
  String clientId = '',
  String parkingLotId = '',
  bool isCancelled = false,
  String sortBy = '',
  int limit = 10,
  int page = 1,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  Map<String, String> queryParameters = {
    "clientId": clientId,
    "parkingLotId": parkingLotId,
    "isCancelled": isCancelled.toString(),
    "sortBy": sortBy,
    "limit": limit.toString(),
    "page": page.toString(),
  };
  queryParameters.removeWhere((key, value) => value == '');
  final url = Uri.https(globals.apiKey, '/v1/bookings', queryParameters);
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final results = BookingsList.fromJson(jsonDecode(response.body));
    return results;
  } else {
    handleError(response.body);
  }
}
