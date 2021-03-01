import 'package:flutter/material.dart';

/// A custom time picker
///
/// ```dart
/// TimePicker(
///   onSelect: pickTime,
///   timeDisplay: arrivalTime
/// )
/// ```
class TimePicker extends StatelessWidget{
  final Function onSelect;
  final String timeDisplay;

  TimePicker({
    @required this.onSelect,
    @required this.timeDisplay
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => onSelect,
        child: Text(
          timeDisplay,
          style: TextStyle(
              color: Colors.black54
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}