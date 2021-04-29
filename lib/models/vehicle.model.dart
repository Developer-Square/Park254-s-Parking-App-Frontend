import 'package:flutter/material.dart';

/// Creates a vehicle object from Json
class Vehicle {
  final String model;
  final String plate;

  Vehicle({
    @required this.model,
    @required this.plate,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      model: json['model'],
      plate: json['plate'],
    );
  }
}
