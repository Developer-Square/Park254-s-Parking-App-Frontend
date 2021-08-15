import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/transaction.model.dart';
import '../../config/globals.dart' as globals;

/// Fetches transaction after payment. Called by [pay]
///
/// IMPORTANT: Call from [pay]
/// Requires [phoneNumber], [amount], [token], and [createdAt]
Future<Transaction> fetchTransaction({
  @required num phoneNumber,
  @required num amount,
  @required String token,
  @required String createdAt,
}) async {
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "Bearer $token",
    HttpHeaders.contentTypeHeader: "application/json",
  };
  Map<String, String> queryParameters = {
    'PhoneNumber': phoneNumber.toString(),
    'Amount': amount.toString(),
    'createdAt': createdAt,
  };
  final url = Uri.https(globals.apiKey, '/v1/mpesaWebHook', queryParameters);
  final response = await http.get(url, headers: headers);
  log('In fetch transaction');
  log(response.body.toString());
  if (response.statusCode == 200) {
    final transaction = Transaction.fromJson(jsonDecode(response.body));
    return transaction;
  } else {
    handleError(response.body);
  }
}
