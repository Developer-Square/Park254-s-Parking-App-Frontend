import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

Future<void> logout(String refreshToken) async {
  final url = Uri.parse('${globals.apiUrl}/v1/auth/login');
  final response = await http.post(
    url,
    body: {'refreshToken': refreshToken},
  );

  if (response.statusCode == 204) {
    throw 'success';
  } else {
    handleError(response.body);
  }
}
