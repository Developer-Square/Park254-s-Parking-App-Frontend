import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/handleError.dart';
import '../config/globals.dart' as globals;

import '../models/userWithToken.model.dart';

Future<UserWithToken> login(String email, String password) async {
  final url = Uri.parse('${globals.apiUrl}/v1/auth/login');
  final response = await http.post(
    url,
    body: {'email': email, 'password': password},
  );

  if (response.statusCode == 200) {
    final userWithToken = UserWithToken.fromJson(jsonDecode(response.body));
    return userWithToken;
  } else {
    handleError(response.body);
  }
}
