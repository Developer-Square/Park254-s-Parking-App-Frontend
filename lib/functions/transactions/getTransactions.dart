import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/queryTransactions.dart';
import '../../config/globals.dart' as globals;

/// Gets transactions based on filter properties
///
/// filter properties: [phoneNumber], [sortBy], [limit], and [page]
Future<QueryTransactions> getTransactions({
  @required String token,
  num phoneNumber = 0,
  String sortBy = '',
  int limit = 10,
  int page = 1,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  Map<String, String> queryParameters = {
    "PhoneNumber": phoneNumber.toString(),
    "sortBy": sortBy,
    "limit": limit.toString(),
    "page": page.toString(),
  };
  queryParameters.removeWhere(
    (key, value) => value == '' || value == 0.toString(),
  );
  final url = Uri.https(globals.apiKey, '/v1/mpesa', queryParameters);
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final results = QueryTransactions.fromJson(jsonDecode(response.body));
    return results;
  } else {
    handleError(response.body);
  }
}
