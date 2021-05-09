import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/models/vehicle.model.dart';

/// Creates a user object from Json
class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final int phone;
  final List<Vehicle> vehicles;


  User({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.role,
    @required this.phone,
    @required this.vehicles,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      phone: json['phone'],
      vehicles: (json['vehicles'] as List)
          .map((vehicle) => Vehicle.fromJson(vehicle))
          .toList(),
    );
  }
}
