import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_retry/http_retry.dart';
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/transaction.model.dart';
import '../../config/globals.dart' as globals;

/// Fetches transaction after payment. Called by [pay]
///
/// IMPORTANT: Call from [pay]
/// Retries for 5 times as long as the response status code is 404
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
  final client = RetryClient(
    http.Client(),
    when: (http.BaseResponse response) {
      return response.statusCode == 404;
    },
    retries: 5,
  );
  try {
    final response = await client.get(url, headers: headers);
    if (response.statusCode == 200) {
      final transaction = Transaction.fromJson(jsonDecode(response.body));
      return transaction;
    } else {
      handleError(response.body);
    }
  } finally {
    client.close();
  }
}
