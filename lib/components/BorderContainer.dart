import 'package:flutter/material.dart';

/// Custom container with border and padding
///
/// Example
/// ```dart
/// BorderContainer(
///   content: Text('An example')
/// );
/// ```
class BorderContainer extends StatelessWidget {
  final Widget content;

  BorderContainer({
    @required this.content
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(left: width/20, right: width/20),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black54.withOpacity(0.1), width: 1))
      ),
      child: content,
    );
  }
}