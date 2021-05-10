import 'package:flutter/material.dart';

/// Creates an error object from Json
class Error {
  final int code;
  final String message;

  Error({
    @required this.code,
    @required this.message,
  });

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      code: json['code'],
      message: json['message'],
    );
  }
}
