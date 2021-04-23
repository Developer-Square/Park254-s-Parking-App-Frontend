import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

/// logs out a user using [refreshToken]
Future<String> logout({@required String refreshToken}) async {
  final Uri url = Uri.https(globals.apiKey, '/v1/auth/login');
  final String body = jsonEncode({'refreshToken': refreshToken});
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
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
