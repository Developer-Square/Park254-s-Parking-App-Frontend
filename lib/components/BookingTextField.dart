import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

/// Creates a custom TextField component
///
/// ```dart
/// BookingTextField(
///   controller: vehicleController
/// );
/// ```
class BookingTextField extends StatelessWidget{
  final TextEditingController controller;
  final TextCapitalization capitalize;
  final Color textColor;
  final FontWeight fontWeight;

  BookingTextField({
    @required this.controller,
    this.capitalize,
    this.textColor,
    this.fontWeight
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
          color: textColor == globals.textColor ? globals.textColor : textColor,
          fontWeight: fontWeight == FontWeight.bold ? FontWeight.bold : FontWeight.normal
      ),
      textAlign: TextAlign.right,
      autocorrect: true,
      textCapitalization: capitalize == TextCapitalization.characters ? TextCapitalization.characters : TextCapitalization.sentences,
      decoration: InputDecoration.collapsed(hintText: null),
    );
  }
}