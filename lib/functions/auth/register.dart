import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

import '../../models/userWithToken.model.dart';

Future<UserWithToken> register(
    String email, String name, String role, String password) async {
  final url = Uri.parse('${globals.apiUrl}/v1/auth/register');
  final response = await http.post(
    url,
    body: {'email': email, 'role': role, 'name': name, 'password': password},
  );

  if (response.statusCode == 201) {
    final userWithToken = UserWithToken.fromJson(jsonDecode(response.body));
    return userWithToken;
  } else {
    handleError(response.body);
  }
}
