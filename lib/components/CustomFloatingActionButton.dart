import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

/// Creates an extended floating action button
///
/// E.g.
/// ```dart
/// CustomFloatingActionButton(
///   onPressed: () => _onButtonPressed(),
///   label: 'Skip',
///   heroTag: 0,
/// );
/// ```
class CustomFloatingActionButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final Object heroTag;

  CustomFloatingActionButton({
    @required this.onPressed,
    @required this.label,
    this.heroTag
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Text(
        label,
        style: TextStyle(color: globals.textColor),
      ),
      backgroundColor: globals.primaryColor,
      heroTag: heroTag,
    );
  }
}