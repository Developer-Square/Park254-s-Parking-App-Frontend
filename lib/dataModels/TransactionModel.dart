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
  // This is used to determine whether the function is being fired for the second time.
  String _createdAt;

  Transaction get transaction {
    return _transaction;
  }

  bool get loader {
    return loading;
  }

  String get createdAt {
    return _createdAt;
  }

  void setCreatedAt(String dateTime) {
    _createdAt = dateTime;
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setTransaction(Transaction transactionDetails) {
    _transaction = transactionDetails;
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
