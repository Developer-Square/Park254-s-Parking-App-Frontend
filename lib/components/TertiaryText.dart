import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;

/// A custom text widget
///
/// Example
/// ```dart
/// TertiaryText(
///   content:'Words to live by'
/// );
/// ```
class TertiaryText extends StatelessWidget {
  final String content;

  TertiaryText({
    @required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        color: globals.textColor,
      ),
    );
  }
}