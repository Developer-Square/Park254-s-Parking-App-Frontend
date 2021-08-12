import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/transaction.model.dart';
import '../../config/globals.dart' as globals;

Future<Transaction> getTransactionById({
  @required String token,
  @required String transactionId,
}) async {
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: "application/json", // or whatever
    HttpHeaders.authorizationHeader: "Bearer $token",
  };
  final url = Uri.https(globals.apiKey, '/v1/mpesa/$transactionId');
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    final transaction = Transaction.fromJson(jsonDecode(response.body));
    return transaction;
  } else {
    handleError(response.body);
  }
}
