import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/functions/transactions/fetchTransaction.dart';
import 'package:park254_s_parking_app/models/transaction.model.dart';

class TransactionModel with ChangeNotifier {
  Transaction _transaction = new Transaction(
    id: null,
    merchantRequestID: null,
    checkoutRequestID: null,
    resultCode: null,
    resultDesc: null,
  );
  bool loading = false;

  Transaction get transaction => _transaction;

  set transaction(Transaction transaction) {
    _transaction = transaction;
    notifyListeners();
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
    );
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
    );
  }
}
