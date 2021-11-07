import 'dart:async';
import 'dart:convert';
import 'dart:io' as dartIO;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/user.model.dart';
import '../../config/globals.dart' as globals;

/// Updates user's [email], [name], or [role]
///
/// Returns [User]
/// Requires: [token], [userId]
Future<User> updateUser({
  @required String token,
  @required String userId,
  String name = '',
  String email = '',
  String role = '',
  int phone = 0,
}) async {
  Map<String, String> headers = {
    dartIO.HttpHeaders.authorizationHeader: "Bearer $token",
  };

  // Removed role as it was bringing back an error.
  Map<String, dynamic> body = {
    "name": name,
    "email": email,
    "role": role,
    "phone": phone,
  };

  body.removeWhere((key, value) => value == '' || value == 0);
  final url = Uri.https(globals.apiKey, '/v1/users/$userId');
  final response =
      await http.patch(url, headers: headers, body: jsonEncode(body));

  if (response.statusCode == 200) {
    final user = User.fromJson(jsonDecode(response.body));
    return user;
  } else {
    handleError(response.body);
  }
}
