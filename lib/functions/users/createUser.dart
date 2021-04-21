import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/user.model.dart';
import '../../config/globals.dart' as globals;

Future<User> createUser(
  String email,
  String name,
  String role,
  String password,
) async {
  final url = Uri.parse('${globals.apiUrl}/v1/users');
  final response = await http.post(
    url,
    body: {'email': email, 'role': role, 'name': name, 'password': password},
  );

  if (response.statusCode == 201) {
    final user = User.fromJson(jsonDecode(response.body));
    return user;
  } else {
    handleError(response.body);
  }
}
