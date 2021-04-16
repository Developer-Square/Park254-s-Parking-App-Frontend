import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String role;

  User({
    @required this.id,
    @required this.email,
    @required this.name,
    @required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
    );
  }
}
