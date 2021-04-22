import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/queryUsers.model.dart';
import '../../config/globals.dart' as globals;

/// Gets users based on filter values
///
/// Returns [QueryUsers]
/// Requires [token]
/// Filter params: [name], [role], [sortBy], [limit], [page]
Future<QueryUsers> getUsers({
  @required String token,
  String name = '',
  String role = '',
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
    "role": role,
    "sortBy": sortBy,
    "limit": limit.toString(),
    "page": page.toString(),
  };
  queryParameters.removeWhere((key, value) => value == '');
  final url = Uri.https(globals.httpsUrl, '/v1/users', queryParameters);
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final results = QueryUsers.fromJson(jsonDecode(response.body));
    return results;
  } else {
    handleError(response.body);
  }
}
