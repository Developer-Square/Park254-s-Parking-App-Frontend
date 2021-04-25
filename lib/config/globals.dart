library parking_app.globals;

import 'package:flutter/material.dart';

final Color primaryColor = Color(0xff14eeb5);
final Color textColor = Color(0xff091a5e);
final Color backgroundColor = Color(0xFF2BE9BA);
final Color placeHolderColor = Color(0xFF9FA8AB);

buildTextStyle(double fontSize, bool fontWeight, color) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ? FontWeight.bold : FontWeight.normal,
      color: color == 'white' ? Colors.white : color);
}
