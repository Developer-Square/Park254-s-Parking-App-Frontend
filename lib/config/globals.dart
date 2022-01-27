library parking_app.globals;

import 'dart:math';

import 'package:flutter/material.dart';

final Color primaryColor = Color(0xff14eeb5);
final Color textColor = Color(0xff091a5e);
final Color backgroundColor = Color(0xFF2BE9BA);
final Color placeHolderColor = Color(0xFF9FA8AB);

// Profile image colors
final Color profile1 = Color(0xffe7feff);
final Color profile2 = Color(0xffecf1ec);
final Color profile3 = Color(0xffcff6f4);
final Color profile4 = Color(0xffedf1fe);
final Color profile5 = Color(0xfface5ee);
final Color profile6 = Color(0xffe5e8f2);

final colors = [profile1, profile2, profile3, profile4, profile5, profile6];

final String apiKey = 'park254-parking-app-server.herokuapp.com';

buildTextStyle(double fontSize, bool fontWeight, color) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ? FontWeight.bold : FontWeight.normal,
      color: color == 'white' ? Colors.white : color);
}

Color randomColorGenerator() {
  Random random = new Random();
  int randomNumber = random.nextInt(6);
  return colors[randomNumber];
}
