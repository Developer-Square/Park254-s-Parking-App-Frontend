import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import '../../config/globals.dart' as globals;

/// Deletes transaction using id
///
/// Requires [token], [transactionId]
Future<bool> deleteTransaction({
  @required String token,
  @required String transactionId,
}) async {
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.apiKey, '/v1/mpesa/$transactionId');
  final response = await http.delete(url, headers: headers);

  if (response.statusCode == 204) {
    return true;
  } else {
    handleError(response.body);
  }
}
