import 'dart:async';
import 'dart:convert';
import 'dart:io' as dartIO;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/user.model.dart';
import '../../config/globals.dart' as globals;

/// Creates a new user
///
/// Can be used to create an admin user
/// Returns: [User]
/// Parameters: [email], [name], [role], [password], [phone], and [vehicles]
/// [role] is not required and defaults to 'user
Future<User> createUser({
  @required String email,
  @required String name,
  String role = 'user',
  @required String password,
  @required int phone,
}) async {
  Map<String, String> headers = {
    dartIO.HttpHeaders.contentTypeHeader: "application/json",
  };
  final Uri url = Uri.https(globals.apiKey, '/v1/users');
  final String body = jsonEncode({
    'email': email.trim(),
    'role': role,
    'name': name,
    'password': password.trim(),
    'phone': phone,
  });
  final response = await http.post(
    url,
    body: body,
    headers: headers,
  );

  if (response.statusCode == 201) {
    final user = User.fromJson(jsonDecode(response.body));
    return user;
  } else {
    handleError(response.body);
  }
}
