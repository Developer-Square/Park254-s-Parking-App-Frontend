import 'package:flutter/material.dart';
import 'transaction.model.dart';
import 'dart:core';

class LatestTransaction {
  final List<Transaction> transactions;

  LatestTransaction({
    @required this.transactions,
  });

  factory LatestTransaction.fromJson(Map<String, dynamic> json) {
    return LatestTransaction(
      transactions: (json['transaction'] as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList(),
    );
  }
}
