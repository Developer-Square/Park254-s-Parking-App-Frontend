import 'package:flutter/material.dart';
import 'user.model.dart';
import 'dart:core';

/// Creates a list of users with metadata from Json
class QueryUsers {
  final List<User> users;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  QueryUsers({
    @required this.users,
    @required this.page,
    @required this.limit,
    @required this.totalPages,
    @required this.totalResults,
  });

  factory QueryUsers.fromJson(Map<String, dynamic> json) {
    return QueryUsers(
      users:
          (json['results'] as List).map((user) => User.fromJson(user)).toList(),
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      totalResults: json['totalResults'],
    );
  }
}
