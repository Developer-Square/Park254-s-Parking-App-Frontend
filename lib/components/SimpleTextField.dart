import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

/// Creates a custom TextField component
///
/// ```dart
/// SimpleTextField(
///   controller: vehicleController
/// );
/// ```
class SimpleTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextCapitalization capitalize;
  final Color textColor;
  final FontWeight fontWeight;
  final String initialValue;
  final InputDecoration decoration;
  final bool decorate;
  final TextInputType keyboardType;
  final bool alignLeft;
  final bool validate;
  final String placeholder;

  SimpleTextField(
      {this.controller,
      this.capitalize,
      this.textColor,
      this.fontWeight,
      this.initialValue,
      this.decoration,
      this.decorate,
      this.keyboardType,
      this.alignLeft,
      this.validate,
      this.placeholder});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validate
          ? (value) {
              if (value == '' || value.isEmpty) {
                return 'Please enter ${placeholder == 'Email' ? 'your email' : 'some text'}';
              }
            }
          : () {},
      controller: controller,
      style: TextStyle(
          color: textColor == globals.textColor ? globals.textColor : textColor,
          fontWeight: fontWeight == FontWeight.bold
              ? FontWeight.bold
              : FontWeight.normal),
      textAlign: alignLeft ? TextAlign.left : TextAlign.right,
      autocorrect: true,
      textCapitalization: capitalize == TextCapitalization.characters
          ? TextCapitalization.characters
          : TextCapitalization.sentences,
      decoration:
          decorate ? decoration : InputDecoration.collapsed(hintText: null),
      initialValue: initialValue,
      keyboardType: keyboardType,
    );
  }
}
