import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

Future<void> forgotPassword(String email) async {
  final url = Uri.parse('${globals.apiUrl}/v1/auth/forgot-password');
  final response = await http.post(
    url,
    body: {'email': email},
  );

  if (response.statusCode == 204) {
    throw 'success';
  } else {
    handleError(response.body);
  }
}
