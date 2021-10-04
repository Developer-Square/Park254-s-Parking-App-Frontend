import 'package:flutter/material.dart';

/// Creates a user object from Json
class User {
  final String id;
  String email;
  String name;
  final String role;
  num phone;

  User({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.role,
    @required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      phone: json['phone'],
    );
  }
}
