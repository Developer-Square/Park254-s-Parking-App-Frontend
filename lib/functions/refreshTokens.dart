import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/handleError.dart';
import 'package:park254_s_parking_app/models/AccessAndRefreshTokens.model.dart';
import '../config/globals.dart' as globals;

Future<AccessAndRefreshTokens> refreshTokens(String refreshToken) async {
  final url = Uri.parse('${globals.apiUrl}/v1/auth/refresh-tokens');
  final response = await http.post(
    url,
    body: {'refreshToken': refreshToken},
  );

  if (response.statusCode == 200) {
    final tokens = AccessAndRefreshTokens.fromJson(jsonDecode(response.body));
    return tokens;
  } else {
    handleError(response.body);
  }
}
