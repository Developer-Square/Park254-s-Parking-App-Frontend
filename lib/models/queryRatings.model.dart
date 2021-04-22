import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/rating.model.dart';
import 'dart:core';

class QueryRatings {
  final List<Rating> ratings;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  QueryRatings({
    @required this.ratings,
    @required this.page,
    @required this.limit,
    @required this.totalPages,
    @required this.totalResults,
  });

  factory QueryRatings.fromJson(Map<String, dynamic> json) {
    return QueryRatings(
      ratings: (json['results'] as List)
          .map((rating) => Rating.fromJson(rating))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      totalResults: json['totalResults'],
    );
  }
}
