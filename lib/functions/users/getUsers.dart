import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/queryUsers.model.dart';
import '../../config/globals.dart' as globals;

Future<QueryUsers> getUsers(
  String name,
  String role,
  String sortBy,
  int limit,
  int page,
  String token,
) async {
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
  final url = Uri.https(globals.httpsUrl, '/v1/users', queryParameters);
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final results = QueryUsers.fromJson(jsonDecode(response.body));
    return results;
  } else {
    handleError(response.body);
  }
}
