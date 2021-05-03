import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

import '../../models/userWithToken.model.dart';

/// Registers a new user
///
/// Returns a user with their access and refresh tokens [UserWithToken]
/// Parameters: [email], [name], [role], and [password]
/// [role] is not required and defaults to 'user
Future<UserWithToken> register(
    {@required String email,
    @required String name,
    String role = 'user',
    @required String password,
    @required String phone}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final Uri url = Uri.https(globals.apiKey, '/v1/auth/register');
  final String body = jsonEncode({
    'email': email,
    'role': role,
    'name': name,
    'password': password,
    'phone': phone,
  });
  final response = await http.post(
    url,
    body: body,
    headers: headers,
  );

  if (response.statusCode == 201) {
    final userWithToken = UserWithToken.fromJson(jsonDecode(response.body));
    return userWithToken;
  } else {
    handleError(response.body);
  }
}
