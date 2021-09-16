import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/user.model.dart';
import '../../config/globals.dart' as globals;

/// Gets a user using their id
///
/// Returns [User]
/// Requires: [token], [userId]
Future<User> getUserById({
  @required String token,
  @required String userId,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.apiKey, '/v1/users/$userId');
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final user = User.fromJson(jsonDecode(response.body));
    return user;
  } else {
    handleError(response.body);
  }
}
