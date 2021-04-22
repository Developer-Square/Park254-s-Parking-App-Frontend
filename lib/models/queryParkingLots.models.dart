import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/parkingLot.model.dart';
import 'dart:core';

class QueryParkingLots {
  final List<ParkingLot> parkingLots;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  QueryParkingLots({
    @required this.parkingLots,
    @required this.page,
    @required this.limit,
    @required this.totalPages,
    @required this.totalResults,
  });

  factory QueryParkingLots.fromJson(Map<String, dynamic> json) {
    return QueryParkingLots(
      parkingLots: (json['results'] as List)
          .map((parkingLot) => ParkingLot.fromJson(parkingLot))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      totalResults: json['totalResults'],
    );
  }
}
