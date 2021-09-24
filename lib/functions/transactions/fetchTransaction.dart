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
  @required Function setTransaction,
  @required Function setLoading,
  Function increaseErrors,
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
  log(response.statusCode.toString());
  if (response.statusCode == 200) {
    final transaction = Transaction.fromJson(jsonDecode(response.body));
    setLoading(false);
    setTransaction(transaction);
    return transaction;
  }
  // When the request timeouts.
  else if (response.statusCode == 503) {
    Transaction transaction = Transaction(
        id: null,
        merchantRequestID: null,
        checkoutRequestID: null,
        resultCode: 503,
        resultDesc: "Transaction failed, kindly try again",
        mpesaReceiptNumber: null,
        transactionDate: null);
    setLoading(false);

    setTransaction(transaction);

    return transaction;
  } else {
    setLoading(false);

    handleError(response.body);
  }
}
