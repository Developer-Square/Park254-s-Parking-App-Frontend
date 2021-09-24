import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:park254_s_parking_app/dataModels/TransactionModel.dart';
import 'package:park254_s_parking_app/functions/transactions/fetchTransaction.dart';
import 'package:park254_s_parking_app/functions/utils/handleError.dart';
import 'package:park254_s_parking_app/models/transaction.model.dart';
import '../../config/globals.dart' as globals;

/// Carries out MPESA transaction and returns [Transaction]
///
/// Requires [phoneNumber], [amount], and [token]
Future<Transaction> pay({
  @required num phoneNumber,
  @required num amount,
  @required String token,
  @required Function setCreatedAt,
  @required Function setLoading,
  @required Function setTransaction,
}) async {
  String createdAt = DateTime.now().toUtc().toIso8601String();
  setCreatedAt(createdAt);
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: "Bearer $token",
    HttpHeaders.contentTypeHeader: "application/json",
  };
  final url = Uri.https(globals.apiKey, '/v1/mpesa');
  final body = jsonEncode({
    'phoneNumber': phoneNumber.toString(),
    'amount': amount.toString(),
  });
  final response = await http.post(
    url,
    headers: headers,
    body: body,
  );
  if (response.statusCode == 200) {
    return await fetchTransaction(
        phoneNumber: phoneNumber,
        amount: amount,
        token: token,
        createdAt: createdAt,
        setLoading: setLoading,
        setTransaction: setTransaction);
  } else {
    handleError(response.body);
  }
}
