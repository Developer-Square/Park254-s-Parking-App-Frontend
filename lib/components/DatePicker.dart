import 'package:flutter/material.dart';

/// A custom date picker
///
/// ```dart
/// DatePicker(
///   onSelect: pickDate,
///   dateDisplay: arrivalDate
/// )
/// ```
class DatePicker extends StatelessWidget{
  final Function onSelect;
  final String dateDisplay;

  DatePicker({
    @required this.onSelect,
    @required this.dateDisplay
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onSelect,
        child: Text(
          dateDisplay,
          style: TextStyle(
              color: Colors.black54
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}