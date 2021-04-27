import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

import '../../models/userWithToken.model.dart';
import 'package:park254_s_parking_app/models/error.model.dart';

/// Logs in a user using [email] and [password]
///
/// Returns the user with their access and refresh tokens
Future login({
  @required String email,
  @required String password,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final Uri url = Uri.http(globals.apiKey, '/v1/auth/login');
  final String body = jsonEncode({'email': email, 'password': password});
  final response = await http.post(
    url,
    body: body,
    headers: headers,
  );

  if (response.statusCode == 200) {
    final userWithToken = UserWithToken.fromJson(jsonDecode(response.body));
    return userWithToken;
  } else {
    // final error = Error.fromJson(jsonDecode(response.body));
    // throw error.message;
    handleError(response.body);
  }
}
