import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/accessAndRefreshTokens.model.dart';
import '../../config/globals.dart' as globals;

/// Gets new access and refresh tokens
///
/// Requires a [refreshToken]
Future<AccessAndRefreshTokens> refreshTokens({
  @required String refreshToken,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final Uri url = Uri.https(globals.apiKey, '/v1/auth/refresh-tokens');
  final String body = jsonEncode({'refreshToken': refreshToken});
  final response = await http.post(
    url,
    body: body,
    headers: headers,
  );

  if (response.statusCode == 200) {
    final tokens = AccessAndRefreshTokens.fromJson(jsonDecode(response.body));
    return tokens;
  } else {
    handleError(response.body);
  }
}
