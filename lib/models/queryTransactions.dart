import 'package:flutter/material.dart';
import 'transaction.model.dart';
import 'dart:core';

class QueryTransactions {
  final List<Transaction> transactions;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  QueryTransactions({
    @required this.transactions,
    @required this.page,
    @required this.limit,
    @required this.totalPages,
    @required this.totalResults,
  });

  factory QueryTransactions.fromJson(Map<String, dynamic> json) {
    return QueryTransactions(
      transactions: (json['results'] as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      totalResults: json['totalResults'],
    );
  }
}
