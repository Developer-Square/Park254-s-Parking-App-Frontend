import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String merchantRequestID;
  final String checkoutRequestID;
  final num resultCode;
  final String resultDesc;
  final num amount;
  final String mpesaReceiptNumber;
  final num transactionDate;
  final num phoneNumber;

  Transaction({
    @required this.id,
    @required this.merchantRequestID,
    @required this.checkoutRequestID,
    @required this.resultCode,
    @required this.resultDesc,
    this.amount,
    this.mpesaReceiptNumber,
    this.transactionDate,
    this.phoneNumber,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      merchantRequestID: json['MerchantRequestID'],
      checkoutRequestID: json['CheckoutRequestID'],
      resultCode: json['ResultCode'],
      resultDesc: json['ResultDesc'],
      amount: json['Amount'],
      mpesaReceiptNumber: json['MpesaReceiptNumber'],
      transactionDate: json['TransactionDate'],
      phoneNumber: json['PhoneNumber'],
    );
  }
}
