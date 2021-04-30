import 'package:flutter/material.dart';

/// Creates a token from Json
class Token {
  final String token;
  final DateTime expires;

  Token({
    @required this.token,
    @required this.expires,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
      expires: DateTime.parse(json['expires']),
    );
  }
}
