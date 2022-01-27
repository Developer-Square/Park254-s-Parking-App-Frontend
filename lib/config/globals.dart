library parking_app.globals;

import 'dart:math';

import 'package:flutter/material.dart';

final Color primaryColor = Color(0xff14eeb5);
final Color textColor = Color(0xff091a5e);
final Color backgroundColor = Color(0xFF2BE9BA);
final Color placeHolderColor = Color(0xFF9FA8AB);
final String apiKey = 'park254-parking-app-server.herokuapp.com';

buildTextStyle(double fontSize, bool fontWeight, color) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ? FontWeight.bold : FontWeight.normal,
      color: color == 'white' ? Colors.white : color);
}

String generateRandomNumber(length) {
  var result = '';
  Random random = new Random();
  var digits = '0123456789';
  var characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  for (var i = 0; i < length; i++) {
    result += digits[random.nextInt(digits.length - 1)];
  }
  return result;
}
