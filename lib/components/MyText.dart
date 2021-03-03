import 'package:flutter/material.dart';
import '../config/globals.dart' as globals;

/// A custom text widget
///
/// Example
/// ```dart
/// MyText(
///   content:'Words to live by'
/// );
/// ```
class MyText extends StatelessWidget {
  final String content;

  MyText({
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