import 'package:flutter/material.dart';
import './vehicle.model.dart';

/// Creates a user object from Json
class CancelBookingUser {
  final String id;
  String email;
  String name;
  final String role;
  num phone;
  List vehicles;

  CancelBookingUser({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.role,
    @required this.phone,
    @required this.vehicles,
  });

  factory CancelBookingUser.fromJson(Map<String, dynamic> json) {
    return CancelBookingUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      phone: json['phone'],
      vehicles: json['vehicles'],
    );
  }
}
