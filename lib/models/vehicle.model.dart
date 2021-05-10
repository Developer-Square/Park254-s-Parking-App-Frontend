import 'package:flutter/material.dart';

/// Converts a vehicle object from and to Json
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

  Map<String, dynamic> toJson() => {
        'model': model,
        'plate': plate,
      };
}
