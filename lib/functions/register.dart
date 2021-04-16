import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/globals.dart' as globals;

import '../models/user.model.dart';

Future<User> register(
    String email, String name, String role, String password) async {
  final url = Uri.parse('${globals.apiUrl}/v1/auth/register');
  final response = await http.post(
    url,
    body: {'email': email, 'role': role, 'name': name, 'password': password},
  );

  if (response.statusCode == 201) {
    final user = User.fromJson(jsonDecode(response.body));
    print(user.name);
    return user;
  } else {
    throw Exception('Failed to register user');
  }
}
