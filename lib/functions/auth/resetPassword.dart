import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

/// Sets a new password for user
///
/// Requires the new [password] and authentication [token]
Future<String> resetPassword({
  @required String password,
  @required String token,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
  Map<String, String> queryParameters = <String, String>{'token': '$token'};
  final Uri url = Uri.https(
    globals.apiKey,
    '/v1/auth/reset-password',
    queryParameters,
  );
  log(url.toString());
  final String body = jsonEncode({'password': password});
  final response = await http.post(
    url,
    body: body,
    headers: headers,
  );

  if (response.statusCode == 204) {
    return 'success';
  } else {
    handleError(response.body);
  }
}
