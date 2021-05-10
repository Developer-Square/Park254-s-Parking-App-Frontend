import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/user.model.dart';
import 'package:park254_s_parking_app/models/vehicle.model.dart';
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
  List<Vehicle> vehicles,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final Uri url = Uri.https(globals.apiKey, '/v1/users');
  final String body = jsonEncode({
    'email': email,
    'role': role,
    'name': name,
    'password': password,
    'phone': phone,
    'vehicles': vehicles,
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
