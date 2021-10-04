import 'package:flutter/material.dart';

/// Converts a vehicle object from and to Json
class Vehicle {
  final String model;
  final String plate;
  final String id;
  final String owner;

  Vehicle({
    @required this.model,
    @required this.plate,
    @required this.owner,
    this.id,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      model: json['model'],
      plate: json['plate'],
      owner: json['owner'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'model': model,
        'plate': plate,
        'owner': owner,
      };
}
