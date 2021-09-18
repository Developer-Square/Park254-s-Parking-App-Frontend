import 'package:flutter/material.dart';
import 'vehicle.model.dart';
import 'dart:core';

/// Creates a list of vehicles with metadata from Json
class VehicleList {
  final List<Vehicle> vehicles;
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  VehicleList({
    @required this.vehicles,
    @required this.page,
    @required this.limit,
    @required this.totalPages,
    @required this.totalResults,
  });

  factory VehicleList.fromJson(Map<String, dynamic> json) {
    return VehicleList(
      vehicles: (json['results'] as List)
          .map((vehicle) => Vehicle.fromJson(vehicle))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
      totalResults: json['totalResults'],
    );
  }
}
