import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/queryRatings.model.dart';
import '../../config/globals.dart' as globals;

/// Gets ratings based on filters
///
/// Returns [QueryRatings]
/// Requires [token]
/// Optional filter params: [userId], [parkingLotId], [sortBy], [limit], [page]
Future<QueryRatings> getRatings({
  @required String token,
  String userId = '',
  String parkingLotId = '',
  String sortBy = '',
  int limit = 10,
  int page = 1,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  Map<String, String> queryParameters = {
    "userId": userId,
    "parkingLotId": parkingLotId,
    "sortBy": sortBy,
    "limit": limit.toString(),
    "page": page.toString(),
  };
  queryParameters.removeWhere((key, value) => value == '');
  final url = Uri.https(globals.httpsUrl, '/v1/ratings', queryParameters);
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final results = QueryRatings.fromJson(jsonDecode(response.body));
    return results;
  } else {
    handleError(response.body);
  }
}
