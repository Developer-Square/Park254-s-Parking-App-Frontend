import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/booking.model.dart';
import 'dart:core';

import 'package:park254_s_parking_app/models/booking.populated.model.dart';

class BookingsList {
  final List<BookingDetails> bookingDetailsList;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  BookingsList({
    @required this.bookingDetailsList,
    @required this.page,
    @required this.limit,
    @required this.totalPages,
    @required this.totalResults,
  });

  factory BookingsList.fromJson(Map<String, dynamic> json) {
    return BookingsList(
      bookingDetailsList: (json['results'] as List)
          .map((booking) => BookingDetails.fromJson(booking))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      totalResults: json['totalResults'],
    );
  }
}
