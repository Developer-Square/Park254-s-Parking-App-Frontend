import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/functions/transactions/fetchTransaction.dart';
import 'package:park254_s_parking_app/models/transaction.model.dart';

class TransactionModel with ChangeNotifier {
  TransactionModel();

  Transaction _transaction = new Transaction(
      id: null,
      merchantRequestID: null,
      checkoutRequestID: null,
      resultCode: null,
      resultDesc: null,
      mpesaReceiptNumber: null,
      transactionDate: null);
  bool loading = false;

  Transaction get transaction {
    return _transaction;
  }

  bool get loader {
    return loading;
  }

  void fetch({
    @required num phoneNumber,
    @required num amount,
    @required String token,
    @required String createdAt,
  }) async {
    loading = true;
    _transaction = await fetchTransaction(
      phoneNumber: phoneNumber,
      amount: amount,
      token: token,
      createdAt: createdAt,
    ).timeout(Duration(seconds: 12), onTimeout: () {
      // If the request times out then set the state to an empty object
      // with the resultCode of 1.
      _transaction = Transaction(
          id: null,
          merchantRequestID: null,
          checkoutRequestID: null,
          resultCode: 1,
          resultDesc: "Transaction failed, kindly try again",
          mpesaReceiptNumber: null,
          transactionDate: null);
      return transaction;
    });
    loading = false;
    notifyListeners();
  }

  void remove() {
    _transaction = new Transaction(
        id: null,
        merchantRequestID: null,
        checkoutRequestID: null,
        resultCode: null,
        resultDesc: null,
        mpesaReceiptNumber: null,
        transactionDate: null);
  }
}
