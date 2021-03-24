import 'package:flutter/material.dart';
import 'package:park254_s_parking_app/config/globals.dart' as globals;

/// Creates a circle with icon
class CircleWithIcon extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final double sizeFactor;

  CircleWithIcon({
    @required this.icon,
    this.iconColor,
    this.bgColor,
    this.sizeFactor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor == globals.primaryColor ? globals.primaryColor : bgColor,
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor == globals.textColor ? globals.textColor : iconColor,
        ),
        widthFactor: sizeFactor == 2 ? 2 : sizeFactor,
        heightFactor: sizeFactor == 2 ? 2 : sizeFactor,
      ),
    );
  }
}