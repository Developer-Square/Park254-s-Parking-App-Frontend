import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

/// Creates a custom Back Arrow
///
/// E.g
/// ```dart
/// BackArrow();
/// ```
class BackArrow extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back,
        color: globals.textColor,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}