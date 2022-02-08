import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

/// Triggers a reset-password email sent from the server
///
/// Requires sender's [email]
Future<String> forgotPassword({@required String email}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final Uri url = Uri.https(globals.apiKey, '/v1/auth/forgot-password');
  final String body = jsonEncode({'email': email.trim()});
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
