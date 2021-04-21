import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/user.model.dart';
import '../../config/globals.dart' as globals;

Future<void> deleteUser(
  String token,
  String userId,
) async {
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.httpsUrl, '/v1/users/$userId');
  final response = await http.delete(url, headers: headers);

  if (response.statusCode == 200) {
    throw 'success';
  } else {
    handleError(response.body);
  }
}
