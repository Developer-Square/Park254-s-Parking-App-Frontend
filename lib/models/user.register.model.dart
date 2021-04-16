import 'package:flutter/material.dart';

class UserDetails {
  final String email;
  final String name;
  final String role;
  final String password;

  UserDetails({
    @required this.email,
    @required this.name,
    this.role,
    @required this.password,
  });
}
