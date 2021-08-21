import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/functions/transactions/fetchTransaction.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';
import 'package:park254_s_parking_app/models/transaction.model.dart';

class TransactionModel with ChangeNotifier {
  Transaction _transaction = new Transaction(
    id: null,
    merchantRequestID: null,
    checkoutRequestID: null,
    resultCode: null,
    resultDesc: null,
    mpesaReceiptNumber: null,
    transactionDate: null,
  );
  bool loading = false;
  // This is used to determine whether the function is being fired for the second time.
  String _createdAt;
  BookingDetails _bookingDetails;

  Transaction get transaction => _transaction;

  BookingDetails get booking => _bookingDetails;

  bool get loader => loading;

  String get createdAt => _createdAt;

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
      setLoading: setLoading,
      setTransaction: setTransaction,
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
        transactionDate: null,
      );
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
      transactionDate: null,
    );
    notifyListeners();
  }
}
