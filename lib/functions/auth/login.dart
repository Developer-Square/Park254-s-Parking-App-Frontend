import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

import '../../models/userWithToken.model.dart';

/// Logs in a user using [email] and [password]
///
/// Returns the user with their access and refresh tokens
Future<UserWithToken> login({
  @required String emailOrPhone,
  @required String password,
  String phone,
}) async {
  String body;
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final Uri url = Uri.https(globals.apiKey, '/v1/auth/login');
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(emailOrPhone);

  // This so as we know whether the user is logging through their email or phone number.
  if (emailValid) {
    body = jsonEncode({'email': emailOrPhone.trim(), 'password': password});
  } else {
    body = jsonEncode({'phone': emailOrPhone.trim(), 'password': password});
  }
  final response = await http.post(
    url,
    body: body,
    headers: headers,
  );

  if (response.statusCode == 200) {
    final userWithToken = UserWithToken.fromJson(jsonDecode(response.body));
    return userWithToken;
  } else {
    handleError(response.body);
  }
}
