import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

/// Creates a custom TextField component
///
/// ```dart
/// SimpleTextField(
///   controller: vehicleController
/// );
/// ```
class SimpleTextField extends StatelessWidget{
  final TextEditingController controller;
  final TextCapitalization capitalize;
  final Color textColor;
  final FontWeight fontWeight;
  final String initialValue;

  SimpleTextField({
    this.controller,
    this.capitalize,
    this.textColor,
    this.fontWeight,
    this.initialValue
  });

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      style: TextStyle(
          color: textColor == globals.textColor ? globals.textColor : textColor,
          fontWeight: fontWeight == FontWeight.bold ? FontWeight.bold : FontWeight.normal
      ),
      textAlign: TextAlign.right,
      autocorrect: true,
      textCapitalization: capitalize == TextCapitalization.characters ? TextCapitalization.characters : TextCapitalization.sentences,
      decoration: InputDecoration.collapsed(hintText: null),
      initialValue: initialValue,
    );
  }
}