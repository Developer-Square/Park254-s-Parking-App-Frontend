import 'package:flutter/material.dart';

/// A custom text widget
///
/// Example
/// ```dart
/// SecondaryText(
///   content:'Words to live by'
/// );
/// ```
class SecondaryText extends StatelessWidget {
  final String content;

  SecondaryText({
    @required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        color: Colors.black54,
      ),
    );
  }
}