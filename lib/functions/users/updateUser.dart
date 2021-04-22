import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/user.model.dart';
import '../../config/globals.dart' as globals;

Future<User> updateUser({
  @required String token,
  @required String userId,
  String name = '',
  String email = '',
  String role = '',
}) async {
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  Map<String, String> body = {
    "name": name,
    "email": email,
    "role": role,
  };
  body.removeWhere((key, value) => value == '');
  final url = Uri.https(globals.httpsUrl, '/v1/users/$userId');
  final response = await http.patch(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final user = User.fromJson(jsonDecode(response.body));
    return user;
  } else {
    handleError(response.body);
  }
}
