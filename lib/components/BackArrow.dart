import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

/// Creates a custom Back Arrow
///
/// E.g
/// ```dart
/// BackArrow();
/// ```
class BackArrow extends StatelessWidget {
  final Function clearFields;

  BackArrow({this.clearFields});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: globals.textColor,
      ),
      onPressed: () {
        // Clear the fields when moving back.
        // This applies in the case of updating or creating parking lot.
        if (clearFields != null) {
          clearFields();
        }
        Navigator.of(context).pop();
      },
    );
  }
}
