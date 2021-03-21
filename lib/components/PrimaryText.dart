import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;

/// A custom text widget
///
/// Example
/// ```dart
/// PrimaryText(
///   content:'Words to live by'
/// );
/// ```
class PrimaryText extends StatelessWidget {
  final String content;

  PrimaryText({
    @required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        color: globals.textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),
    );
  }
}